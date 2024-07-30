const express = require('express');
const { getMatchesList } = require('./src/getMatches');
const { getSquadList } = require('./src/getSquad');
const { getPlayerDetails } = require('./src/getPlayerDetail');
const { calculatePlayerValue } = require('./src/playerValueAgorithm');
const cors = require('cors');

const NodeCache = require('node-cache');
const cache = new NodeCache({ stdTTL: 700000 }); //


const app = express();
const PORT = process.env.PORT || 8000;

app.use(cors());


let i=0;




app.get('/match_list/', async (req, res) => {
  console.log("Incoming MatchList Request");
  try {
    const tournament = 'fifa.olympics';
    const matchListUrl = `https://www.espn.in/football/fixtures?league=${tournament}`;
    
    // Check cache first
    const cachedMatches = cache.get(matchListUrl);
    if (cachedMatches) {
      return res.json(cachedMatches); // Return cached data
    }
    
    // Fetch data if not cached
    const matches = await getMatchesList(matchListUrl);

    if (!matches || matches.length === 0) {
      res.status(404).send('No matches found');
    } else {
      // Cache the fetched data
      cache.set(matchListUrl, matches);
      res.json(matches); // Send the data as JSON
      console.log(" MatchList Sent");
    }
  } catch (error) {
    console.error('Error fetching match data:', error);
    res.status(500).send('Internal Server Error');
  }
});

app.get('/squad/:teamID', async (req, res) => {
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
      cache.set(cacheKey, squad); // Cache the squad list
    }
    res.json(squad);
    console.log(`Squad sent ${i}`);
  } catch (error) {
    console.error('Error fetching squad data:', error);
    res.status(500).send('Internal Server Error');
  }
});


app.use(express.json());


  app.post('/player_details/', async (req, res) => {
    
    
    const { player_name, key2, key3 } = req.body;
    try {
      
      const playerFinderURL = `https://www.transfermarkt.com/schnellsuche/ergebnis/schnellsuche?query=${player_name}`;
      const player = await getPlayerDetails(playerFinderURL, key2, key3); // Await the async function
  
      if (!player || player.length === 0) {
        res.status(404).send('No Player found');
      } else {
        console.log(player);
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
