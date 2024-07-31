const express = require('express');
const User = require('../../models/user.models');
const Player = require('../../models/player.models');
const Match = require('../../models/match.models');
const FantasyTeam = require('../../models/fantasy_team.models');

const router = express.Router();

router.post('/', async (req, res) => {
  const { teamName, user, match, squad } = req.body;

  try {
    const userDocument = await User.findOne({ username: user });
    if (!userDocument) {
      return res.status(404).send('User not found');
    }

    const matchDetails = new Match({
      matchId: parseInt(match.matchId),
      user: userDocument._id,
      homeTeamId: match.homeTeamId,
      homeTeam: match.homeTeam,
      awayTeamId: match.awayTeamId,
      awayTeam: match.awayTeam,
      time: match.time,
    });

    const existingTeam = await FantasyTeam.findOne({ user: userDocument._id, matchId: match.matchId });
    if (existingTeam) {
      console.log('You have already submitted a squad for this match.');
      return res.status(205).send('You have already submitted a squad for this match.');
    }

    const playerIds = [];
    for (const playerData of squad) {
      const existingPlayer = await Player.findOne({ playerID: playerData.playerID });
      if (existingPlayer) {
        playerIds.push(existingPlayer._id);
      } else {
        const newPlayer = new Player(playerData);
        await newPlayer.save();
        playerIds.push(newPlayer._id);
      }
    }

    await matchDetails.save();

    const fantasyTeam = new FantasyTeam({
      name: teamName,
      user: userDocument._id,
      matchId: matchDetails.matchId,
      players: playerIds
    });

    await fantasyTeam.save();
    console.log("Squad saved successfully!");
    res.status(200).send('Squad saved successfully!');
  } catch (error) {
    console.error(error);
    console.log("Error saving squad");
    res.status(500).send('Error saving squad');
  }
});

module.exports = router;
