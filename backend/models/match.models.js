const mongoose = require('mongoose');

const MatchSchema = new mongoose.Schema({
  matchId:{type: Number, required:true},
  homeTeamId: { type: Number, required: true },
  homeTeam: { type: String, required: true },
  awayTeamId: { type: Number, required: true },
  awayTteam: { type: String, required: true },
  time: { type: String, required: true },
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  result: {
    home_score: { type: Number, default: 0 },
    away_score: { type: Number, default: 0 },
    status: { type: String, default: 'upcoming' } 
  }
});

module.exports = mongoose.model('Match', MatchSchema);
