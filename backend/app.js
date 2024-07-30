const express = require('express');
const { getMatchesList } = require('./src/getMatches');
const { getSquadList } = require('./src/getSquad');
const { getPlayerDetails } = require('./src/getPlayerDetail');

const app = express();
const PORT = process.env.PORT || 3000;

app.get('/match_list', async (req, res) => {
  try {
    const tournament = 'fifa.olympics';
    const matchListUrl = `https://www.espn.in/football/fixtures?league=${tournament}`;
    const matches = await getMatchesList(matchListUrl); // Await the async function

    if (!matches || matches.length === 0) {
      res.status(404).send('No matches found');
    } else {
      res.json(matches); // Send the data as JSON
    }
  } catch (error) {
    console.error('Error fetching match data:', error);
    res.status(500).send('Internal Server Error');
  }
});


app.get('/squad', async (req, res) => {
    try {
      const teamID = 359;
      const squadListUrl = `https://www.espn.in/football/team/squad/_/id/${teamID}/`;
      const squad = await getSquadList(squadListUrl); // Await the async function
  
      if (!squad || squad.length === 0) {
        res.status(404).send('No squad found');
      } else {
        res.json(squad); // Send the data as JSON
      }
    } catch (error) {
      console.error('Error fetching match data:', error);
      res.status(500).send('Internal Server Error');
    }
  });


  app.get('/player_details', async (req, res) => {
    try {
      const player_name = 'FERMIN+LOPEZ';
      const playerFinderURL = `https://www.transfermarkt.com/schnellsuche/ergebnis/schnellsuche?query=${player_name}`;
      const player = await getPlayerDetails(playerFinderURL); // Await the async function
  
      if (!player || player.length === 0) {
        res.status(404).send('No matches found');
      } else {
        res.json(player); // Send the data as JSON
      }
    } catch (error) {
      console.error('Error fetching match data:', error);
      res.status(500).send('Internal Server Error');
    }
  });


app.listen(PORT, () => {
  console.log(`Server running successfully at http://localhost:${PORT}`);
});
