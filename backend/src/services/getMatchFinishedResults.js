const cheerio = require("cheerio");
const axios = require("axios");
const fs = require("fs");

async function fetchMatchResult(url) {
  try {
    const response = await axios.get(url);
    const html = response.data;
    const $ = cheerio.load(html);
    const scriptTags = $("script");

    const scriptContent = scriptTags.eq(25).html();
    let result = {
      status: "Pending",
      players: [],
      scores: {},
      goalScorers: []
    };
    if (scriptContent) {
      const matchStatusStart = scriptContent.lastIndexOf("gmStrp");
      const matchStatusEnd = scriptContent.indexOf("gpLinks");

      if (matchStatusEnd !== -1 || matchStatusStart != -1) {
        const statusData = scriptContent
          .substring(matchStatusStart, matchStatusEnd)
          .trim();

        let matchNewStatusData="{\""+ statusData.substring(0,statusData.length - 2)+"}";
        
        let parsedMatchStatus=JSON.parse(matchNewStatusData);
        const matchstatusData = statusData
          .substring(statusData.indexOf("det"), statusData.indexOf(',"id'))
          .trim();

        let cleanedJsonmatchStatusData = '{"' + matchstatusData + "}";
        let statusJsonObject = JSON.parse(cleanedJsonmatchStatusData);
        if (statusJsonObject.det.includes("FT")) {
          result.status = "FT";


          const teams= parsedMatchStatus.gmStrp;
          
          const goals = teams.goals;
              result.scores[goals.home.id] = goals.home.goals.length;
              result.scores[goals.away.id] = goals.away.goals.length;

              // Mapping goal scorers
              result.goalScorers = [
                ...goals.home.goals.map(goal => ({
                  teamId: goals.home.id,
                  playerid:parseInt(goal.id),
                  playerName: goal.name,
                  time: goal.clock
                })),
                ...goals.away.goals.map(goal => ({
                  teamId: goals.away.id,
                  playerid:parseInt(goal.id),
                  playerName: goal.name,
                  time: goal.clock
                }))
              ];


          const lineUpsIndex = scriptContent.indexOf("lineUps");
          const metaIndex = scriptContent.indexOf("gmHilghts");
          if (
            lineUpsIndex !== -1 &&
            metaIndex !== -1 &&
            lineUpsIndex < metaIndex
          ) {
            const dataAfterLineUps = scriptContent
              .substring(lineUpsIndex, metaIndex)
              .trim();

            let jsonData = JSON.stringify(dataAfterLineUps, null, 2);
            jsonData = '{"' + jsonData.substring(1, jsonData.length - 14) + "}";
            jsonData = jsonData
              .replace(/\\n/g, "") 
              .replace(/\\t/g, "") 
              .replace(/\\r/g, "") 
              .replace(/\\'/g, "'")
              .replace(">- ", '"')
              .replace(/\\"/g, '"');

            fs.writeFileSync(
              "lineups.json",
              (jsonData = jsonData.replace(/\\n/g, "")) 
            );

            const jsonObject = JSON.parse(jsonData);
            const playerDetails = [];
            jsonObject.lineUps.forEach((lineUp) => {
              if (lineUp.playersMap) {
                Object.keys(lineUp.playersMap).forEach((playerId) => {
                  const player = lineUp.playersMap[playerId];
                  const playerStats = player.stats || {};

                  if (player.stats && Object.keys(player.stats).length > 0) {
                    const playerDetail = {
                      id: parseInt(player.id),
                      fantasyPoints: Math.ceil(calculateFantasyPoints({
                        foulsCommitted: parseInt(playerStats.foulsCommitted) || 0,
                        ownGoals: parseInt(playerStats.ownGoals) || 0,
                        redCards: parseInt(playerStats.redCards) || 0,
                        yellowCards: parseInt(playerStats.yellowCards) || 0,
                        goalsConceded: parseInt(playerStats.goalsConceded) || 0,
                        goalAssists: parseInt(playerStats.goalAssists) || 0,
                        totalGoals: parseInt(playerStats.totalGoals) || 0,
                        shotsOnTarget: parseInt(playerStats.shotsOnTarget) || 0
                      }))
                    };
                    
                    result.players.push(playerDetail);
                  }
                });
              } else {
                console.log("No playersMap available in this lineUp.");
              }
            });

            
          }
        }
      } else {
        console.log("lineUps keyword not found in the script content.");
      }
    } else {
      console.log("No content found in the script tag at index 25.");
    }

    return result;
  } catch (error) {
    console.error("Error:", error);
  }
}

function calculateFantasyPoints(playerStats) {
  const points = {
    foulsCommitted: -0.5,
    ownGoals: -1,
    redCards: -3,
    yellowCards: -2,
    goalsConceded: -1,
    goalAssists: 3,
    totalGoals: 5,
    shotsOnTarget: 0.5,
    playing: 3
  };

  let totalPoints = 0;
  totalPoints += playerStats.foulsCommitted * points.foulsCommitted;
  totalPoints += playerStats.ownGoals * points.ownGoals;
  totalPoints += playerStats.redCards * points.redCards;
  totalPoints += playerStats.yellowCards * points.yellowCards;
  totalPoints += playerStats.goalsConceded * points.goalsConceded;
  totalPoints += playerStats.goalAssists * points.goalAssists;
  totalPoints += playerStats.totalGoals * points.totalGoals;
  totalPoints += playerStats.shotsOnTarget * points.shotsOnTarget;
  totalPoints += points.playing; // Adding points for playing

  return totalPoints;
}

module.exports = { fetchMatchResult };
