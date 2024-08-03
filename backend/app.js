const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');
const path = require('path');

const matchRoutes = require('./src/routes/matchRoutes');
const squadRoutes = require('./src/routes/squadRoutes');
const playerRoutes = require('./src/routes/playerRoutes');
const squadSubmissionRoutes = require('./src/routes/squadSubmission');
const userMatches = require('./src/routes/userMatches');
const fantasySquad = require('./src/routes/fantasySquad');
const matchResult = require('./src/routes/matchResult');
const userDetails = require('./src/routes/userDetails');
require('dotenv').config();





const app = express();
const PORT = process.env.PORT || 8000;
app.use(cors());

const mongoUri = process.env.MONGODB_URI;
mongoose.connect(mongoUri)
  .then(() => console.log('MongoDB connected...'))
  .catch(err => console.log(err));

app.use(cors());
app.use('/static', express.static(path.join(__dirname, 'static')));
app.use(express.json());


app.use('/matches', matchRoutes);
app.use('/squad', squadRoutes);
app.use('/player_details', playerRoutes);
app.use('/submitSquad', squadSubmissionRoutes);
app.use('/userMatches', userMatches);
app.use('/fantasySquad', fantasySquad);
app.use('/matchResult', matchResult);
app.use('/user_details', userDetails);

app.listen(PORT, () => {
  console.log(`Server running successfully at http://localhost:${PORT}`);
});
