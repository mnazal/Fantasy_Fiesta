const express = require('express');
const cache = require('../cache');
const User = require('../../models/user.models');
const Match = require('../../models/match.models');

const router = express.Router();

router.get('/:userName', async (req, res) => {
  const { userName } = req.params;

  try {
    const cacheKey = `user_matche_${userName}`;
    const cachedUserMatches = cache.get(cacheKey);
    if (cachedUserMatches) {
      return res.json(cachedUserMatches);
    }

    const user = await User.findOne({ username: userName });
    if (!user) {
      return res.status(404).send('User not found');
    }
    const userMatches = await Match.find({ user: user._id })
                                   .sort({ createdAt: -1 })
                                   .lean();
    if (!userMatches || userMatches.length === 0) {
      return res.status(404).send('No matches found');
    }

    cache.set(cacheKey, userMatches);
    
    res.json(userMatches);
    console.log("MatchList Sent");
  } catch (error) {
    console.error('Error fetching match data:', error);
    res.status(500).send('Internal Server Error');
  }
});

module.exports = router;
