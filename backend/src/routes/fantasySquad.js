const express = require('express');
const cache = require('../cache');
const User = require('../../models/user.models');
const FantasyTeam = require('../../models/fantasy_team.models');
const {
  fetchMatchResult
} = require('../services/getMatchFinishedResults');
const Player = require('../../models/player.models');
const router = express.Router();
router.post('/', async (req, res) => {
  const {
    userName,
    matchID
  } = req.body;
  console.log('Incoming Request for fantasy Squad', userName, matchID);
  try {
    // const cacheKey = `user_players_${userName}_${matchID}`;
    // const cachedFantasyTeam = cache.get(cacheKey);
    // if (cachedFantasyTeam) {
    //   return res.json(cachedFantasyTeam);
    // }
    const user = await User.findOne({
      username: userName
    });
    if (!user) {
      return res.status(404).send('User not found');
    }
    const fantasyTeam = await FantasyTeam.findOne({
      user: user._id,
      matchId: parseInt(matchID)
    }).lean();
    if (!fantasyTeam || !fantasyTeam.players || fantasyTeam.players.length === 0) {
      return res.status(404).send('No fantasy team found for the match');
    }
    const matchUrl = `https://www.espn.in/football/lineups/_/gameId/${matchID}`;
    const matchResultObtained = await fetchMatchResult(matchUrl);
    let totalPoints;
    let status = "NS";
    let scores = {};
    let goalScorers = [];
    if (!matchResultObtained || !matchResultObtained.players) {
      return res.status(500).send('Match result not available');
    }
    if (matchResultObtained.status.includes('FT')) {
      status = "FT";
      goalScorers = matchResultObtained.goalScorers;
      scores = matchResultObtained.scores;
      if (!fantasyTeam.points_updated) {
        let playersData = matchResultObtained.players;
        for (const player of playersData) {
          const playerId = player.id;
          const fantasyPoints = player.fantasyPoints;
          const updateResult = await Player.updateOne({
            playerID: playerId,
            _id: {
              $in: fantasyTeam.players
            }
          }, {
            $set: {
              points: fantasyPoints
            }
          });
          if (updateResult.matchedCount === 0) {
            //console.warn(`No player found with playerId ${playerId} in the fantasy team.`);
          } else {
            // console.log(updateResult.matchedCount);
          }
        }
        await FantasyTeam.updateOne({
          _id: fantasyTeam._id
        }, {
          $set: {
            points_updated: true
          }
        });
      }
    }
    const players = await Player.find({
      _id: {
        $in: fantasyTeam.players
      }
    }).lean();
    totalPoints = players.reduce((sum, player) => sum += player.points || 0, 0);
    if(totalPoints>0){
      await FantasyTeam.updateOne({
        _id: fantasyTeam._id
      }, {
        $set: {
          total_points: totalPoints
        }
      });
    }
    let result = {
      players,
      totalPoints,
      status,
      goalScorers,
      scores
    }
    //cache.set(cacheKey, result);
    res.json(result);
    console.log("Fantasy Players List Sent");
  } catch (error) {
    console.error('Error fetching match data:', error);
    res.status(500).send('Internal Server Error');
  }
});
module.exports = router;