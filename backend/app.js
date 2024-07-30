const express = require('express');
const { getMatchesList } = require('./src/getMatches');
const { getSquadList } = require('./src/getSquad');
const { getPlayerDetails } = require('./src/getPlayerDetail');
const { calculatePlayerValue } = require('./src/playerValueAgorithm');

const NodeCache = require('node-cache');
const cache = new NodeCache({ stdTTL: 600 }); //


const app = express();
const PORT = process.env.PORT || 3000;

app.get('/match_list', async (req, res) => {
  try {
    const tournament = 'fifa.olympics';
    const matchListUrl = `https://www.espn.in/football/fixtures?league=${tournament}`;
    const matches = await getMatchesList(matchListUrl); // Await the async function

    if (!matches || matches.length === 0) {
      res.status(404).send('No matches found');
    } else {
      res.json(matches); // Send the data as JSON
    }
  } catch (error) {
    console.error('Error fetching match data:', error);
    res.status(500).send('Internal Server Error');
  }
});


app.get('/squad', async (req, res) => {
  try {
    const teamID = 359;
    const cacheKey = `squad_${teamID}`;
    let squad = cache.get(cacheKey);

    if (!squad) {
      const squadListUrl = `https://www.espn.in/football/team/squad/_/id/${teamID}/`;
      squad = await getSquadList(squadListUrl);

      if (!squad || squad.length === 0) {
        res.status(404).send('No squad found');
        return;
      }
      cache.set(cacheKey, squad); // Cache the squad list
    }

    const playerPromises = squad.map(async (player) => {
      if (!player.playerName) return player;

      try {
        const playerNameFormatted = player.playerName.replace(' ', '+');
        const playerDetailsCacheKey = `playerDetails_${playerNameFormatted}`;
        let playerDetails = cache.get(playerDetailsCacheKey);

        if (!playerDetails) {
          const playerFinderURL = `https://www.transfermarkt.com/schnellsuche/ergebnis/schnellsuche?query=${playerNameFormatted}`;
          playerDetails = await getPlayerDetails(playerFinderURL);
          cache.set(playerDetailsCacheKey, playerDetails); // Cache player details
        }

        if (playerDetails) {
          player.marketValue = calculatePlayerValue(player.position, player.age, playerDetails.marketValue);
          player.playersNetImage = playerDetails.playerImage.replace('small', 'medium');
        }
      } catch (err) {
        console.error(`Error fetching details for player: ${player.playerName}`, err);
      }

      return player;
    });

    const updatedSquad = await Promise.all(playerPromises);
    res.json(updatedSquad);
  } catch (error) {
    console.error('Error fetching squad data:', error);
    res.status(500).send('Internal Server Error');
  }
});




  app.get('/player_details', async (req, res) => {
    try {
      const player_name ='Michael+Rosaik';
      const playerFinderURL = `https://www.transfermarkt.com/schnellsuche/ergebnis/schnellsuche?query=${player_name}`;
      const player = await getPlayerDetails(playerFinderURL); // Await the async function
  
      if (!player || player.length === 0) {
        res.status(404).send('No Player found');
      } else {
        res.json(player); // Send the data as JSON
      }
    } catch (error) {
      console.error('Error fetching match data:', error);
      res.status(500).send('Internal Server  404Error');
    }
  });


app.listen(PORT, () => {
  console.log(`Server running successfully at http://localhost:${PORT}`);
});
