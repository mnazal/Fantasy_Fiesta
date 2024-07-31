const mongoose = require('mongoose');

const PlayerSchema = new mongoose.Schema({
  name: { type: String, required: true },
  age: { type: Number, required: true },
  position: { type: String, required: true },
  team: { type: String, required: true }, 
  market_value: { type: Number, required: true },
  points: { type: Number, default: 0 }, 
  image: { type: String },
});

module.exports = mongoose.model('Player', PlayerSchema);
