const express = require('express');
const { getSquadList } = require('../services/getSquad');
const cache = require('../cache');

const router = express.Router();

router.get('/:teamID', async (req, res) => {
  console.log("Incoming SQUAD Request");
  const { teamID } = req.params;

  try {
    const cacheKey = `squad_${teamID}`;
    let squad = cache.get(cacheKey);

    if (!squad) {
      const squadListUrl = `https://www.espn.in/football/team/squad/_/id/${teamID}/`;
      squad = await getSquadList(squadListUrl);

      if (!squad || squad.length === 0) {
        res.status(404).send('No squad found');
        return;
      }
      cache.set(cacheKey, squad);
    }
    res.json(squad);
    console.log(`Squad sent`);
  } catch (error) {
    console.error('Error fetching squad data:', error);
    res.status(500).send('Internal Server Error');
  }
});

module.exports = router;
