const express = require('express');
const User = require('../../models/user.models');
const FantasyTeam = require('../../models/fantasy_team.models');

const router = express.Router();

router.get('/:username', async (req, res) => {
  const { username } = req.params;

  try {
    // Find user by username
    const user = await User.findOne({ username });
    if (!user) {
      return res.status(404).send('User not found');
    }

    // Find all fantasy teams associated with the user
    const fantasyTeams = await FantasyTeam.find({ user: user._id }).lean();
    if (!fantasyTeams || fantasyTeams.length === 0) {
      return res.status(404).send('No fantasy teams found for the user');
    }

    // Calculate total points from all fantasy teams
    let totalPoints = 0;
    let matchesPlayed=0;
    for (const team of fantasyTeams) {
      totalPoints += team.total_points || 0; 
      matchesPlayed+=1;
    }

    res.json({
      user: {
        username: user.username,
        email: user.email, 
      },
      totalPoints,
      matchesPlayed
    });
  } catch (error) {
    console.error('Error fetching player details:', error);
    res.status(500).send('Internal Server Error');
  }
});

module.exports = router;
