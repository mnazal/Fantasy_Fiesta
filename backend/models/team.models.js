
const mongoose = require('mongoose');

const TeamSchema = new mongoose.Schema({
  name: { type: String, required: true },
  logo: { type: String }, 
  players: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Player' }] 
});

module.exports = mongoose.model('Team', TeamSchema);
