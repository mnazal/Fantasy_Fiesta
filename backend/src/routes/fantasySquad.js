const express = require('express');
const cache = require('../cache');
const User = require('../../models/user.models');
const Match = require('../../models/match.models');
const FantasyTeam=require('../../models/fantasy_team.models');

const Player=require('../../models/player.models');


const router = express.Router();

router.post('/', async (req, res) => {
  const { userName, matchID } = req.body;

  console.log('Incoming Request for fantasy Squad',userName,matchID );

  try {
    const cacheKey = `user_players_${userName}_${matchID}`;
    const cachedFantasyTeam = cache.get(cacheKey);
    if (cachedFantasyTeam) {
      return res.json(cachedFantasyTeam);
    }

    const user = await User.findOne({ username: userName });
    if (!user) {
      return res.status(404).send('User not found');
    }
    const fantasyTeam = await FantasyTeam.findOne({user: user._id, matchId: parseInt(matchID)}).lean();
    if (!fantasyTeam || fantasyTeam.length === 0) {
      return res.status(404).send('No matches found');
    }
    const players = await Player.find({ _id: { $in: fantasyTeam.players } }).lean();
    cache.set(cacheKey, players);
    res.json(players);
    console.log("Fantasy Players List Sent");
  } catch (error) {
    console.error('Error fetching match data:', error);
    res.status(500).send('Internal Server Error');
  }
});

module.exports = router;
