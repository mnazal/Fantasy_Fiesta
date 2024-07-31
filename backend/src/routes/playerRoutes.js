const express = require('express');
const { getPlayerDetails } = require('../services/getPlayerDetail');
const cache = require('../cache');

const router = express.Router();

router.post('/', async (req, res) => {
  const { player_name, key2, key3 } = req.body;

  const cacheKey = `player_${player_name}_${key2}_${key3}`;

  try {
    const cachedPlayer = cache.get(cacheKey);
    if (cachedPlayer) {
      return res.json(cachedPlayer);
    }

    const playerFinderURL = `https://www.transfermarkt.com/schnellsuche/ergebnis/schnellsuche?query=${player_name}`;
    const player = await getPlayerDetails(playerFinderURL, key2, key3);

    if (!player || player.length === 0) {
      res.status(404).send('No Player found');
    } else {
      cache.set(cacheKey, player);
      res.json(player);
    }
  } catch (error) {
    console.error('Error fetching player data:', error);
    res.status(500).send('Internal Server Error');
  }
});

module.exports = router;
