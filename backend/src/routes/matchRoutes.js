const express = require('express');
const { getMatchesList } = require('../services/getMatches');
const cache = require('../cache');

const router = express.Router();

router.get('/', async (req, res) => {
  console.log("Incoming MatchList Request");
  try {
    const tournament = 'club.friendly';
    const matchListUrl = `https://www.espn.in/football/fixtures?league=${tournament}`;
    
    const cachedMatches = cache.get(matchListUrl);
    if (cachedMatches) {
      return res.json(cachedMatches);
    }
    
    const matches = await getMatchesList(matchListUrl);

    if (!matches || matches.length === 0) {
      res.status(404).send('No matches found');
    } else {
      cache.set(matchListUrl, matches);
      res.json(matches);
      console.log("MatchList Sent");
    }
  } catch (error) {
    console.error('Error fetching match data:', error);
    res.status(500).send('Internal Server Error');
  }
});

module.exports = router;
