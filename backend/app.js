const express = require('express');
const { getMatchesList } = require('./src/getMatches');
const { getSquadList } = require('./src/getSquad');
const { getPlayerDetails } = require('./src/getPlayerDetail');
const { calculatePlayerValue } = require('./src/playerValueAgorithm');
const cors = require('cors');
const mongoose = require('mongoose');
const User = require('./models/user.models');
const Player = require('./models/player.models');
const Match=require('./models/match.models');
const FantasyTeam = require('./models/fantasy_team.models');
const path = require('path');

const NodeCache = require('node-cache');
const cache = new NodeCache({ stdTTL: 700000 });

const dbName = 'fantasyfiesta';
const dbUri = `mongodb+srv://mnazal:wantsandneeds@cluster0.3jkakfx.mongodb.net/${dbName}?retryWrites=true&w=majority&appName=Cluster0`;


mongoose.connect(dbUri)
  .then(() => console.log('MongoDB connected...'))
  .catch(err => console.log(err));




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

  // Create a unique cache key based on player_name and keys
  const cacheKey = `player_${player_name}_${key2}_${key3}`;

  try {
    // Check cache first
    const cachedPlayer = cache.get(cacheKey);
    if (cachedPlayer) {
      return res.json(cachedPlayer); // Return cached data
    }

    // Fetch data if not cached
    const playerFinderURL = `https://www.transfermarkt.com/schnellsuche/ergebnis/schnellsuche?query=${player_name}`;
    const player = await getPlayerDetails(playerFinderURL, key2, key3); // Await the async function

    if (!player || player.length === 0) {
      res.status(404).send('No Player found');
    } else {
      // Cache the fetched data
      cache.set(cacheKey, player);
      res.json(player); // Send the data as JSON
    }
  } catch (error) {
    console.error('Error fetching player data:', error);
    res.status(500).send('Internal Server Error');
  }
});

app.use('/static', express.static(path.join(__dirname, 'static')));



app.post('/submit_squad', async (req,res)=>{
  const { teamName, user, match, squad }=req.body;

try{

  const userDocument = await User.findOne({ username: user }); // or { _id: user }
    if (!userDocument) {
      return res.status(404).send('User not found');
    }

   

 

  
    const matchDetails = new Match(
  {
    matchId:parseInt(match.matchId),
    user:userDocument._id,
    homeTeamId:match.homeTeamId,
    homeTeam:match.homeTeam,
    awayTeamId:match.awayTeamId,
    awayTteam:match.awayTeam,
  time: (match.time),
  }
  );
  const existingTeam = await FantasyTeam.findOne({ user: userDocument._id, matchId: match.matchId });
  if (existingTeam) {
    console.log('You have already submitted a squad for this match.');

    return res.status(205).send('You have already submitted a squad for this match.');
  }
  const playerIds = [];

  for (const playerData of squad) {
    const existingPlayer = await Player.findOne({ playerID: playerData.playerID });
    if (existingPlayer) {
      // Use existing player ObjectId
      playerIds.push(existingPlayer._id);
    } else {
      // Insert new player and get ObjectId
      const newPlayer = new Player(playerData);
      await newPlayer.save();
      playerIds.push(newPlayer._id);
    }
  }
  await matchDetails.save();



  

  const fantasyTeam = new FantasyTeam({
    name:teamName,
    user: userDocument._id,
    matchId: matchDetails.matchId,
    players:playerIds
  });
  await fantasyTeam.save();
  console.log("Squad saved successfully!");
  res.status(200).send('Squad saved successfully!');
  }catch(error) {
    console.error(error);
    console.log("Error saving squad");
    res.status(500).send('Error saving squad');
  }



});

app.listen(PORT, () => {
  console.log(`Server running successfully at http://localhost:${PORT}`);
});
