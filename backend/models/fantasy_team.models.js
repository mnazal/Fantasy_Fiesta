const mongoose = require('mongoose');

const FantasyTeamSchema = new mongoose.Schema({
  name: { type: String, required: true },
  matchId: { type:String, required: true},
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  players: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Player' }], 
  created_at: { type: Date, default: Date.now },
  total_points: { type: Number, default: 0 }, 
});

module.exports = mongoose.model('FantasyTeam', FantasyTeamSchema);
