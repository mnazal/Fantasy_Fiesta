const express = require('express');
const { fetchMatchResult } = require('../services/getMatchFinishedResults');
const cache = require('../cache');

const router = express.Router();

router.get('/:matchID', async (req, res) => {

    const { matchID } = req.params; 
  console.log("Incoming MatchResult Request");
  try {
    const matchUrl = `https://www.espn.in/football/lineups/_/gameId/${matchID}`;
    
    const cachedMatchResult = cache.get(matchUrl);
    if (cachedMatchResult) {
      return res.json(cachedMatchResult);
    }
    
    const matchResult = await fetchMatchResult(matchUrl);

    if (!matchResult || matchResult.length === 0) {
      res.status(404).send('No matches found');
    } else {
      cache.set(matchUrl, matchResult);
      res.json(matchResult);
      console.log("Match Result Sent");
    }
  } catch (error) {
    console.error('Error fetching match data:', error);
    res.status(500).send('Internal Server Error');
  }
});

module.exports = router;
