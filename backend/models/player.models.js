const mongoose = require('mongoose');

const PlayerSchema = new mongoose.Schema({
  playerID:{type:Number, required: true, unique : true},
  playerName: { type: String, required: true },
  age: { type: Number, required: false },
  position: { type: String, required: true },
  teamName: { type: String, required: true }, 
  marketValue: { type: Number, required: true },
  points: { type: Number, default: 0 }, 
  playerImage: { type: String },
});

module.exports = mongoose.model('Player', PlayerSchema);
