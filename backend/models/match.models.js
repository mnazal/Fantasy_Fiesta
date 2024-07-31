const mongoose = require('mongoose');

const MatchSchema = new mongoose.Schema({
  home_team: { type: mongoose.Schema.Types.ObjectId, ref: 'Team', required: true },
  away_team: { type: mongoose.Schema.Types.ObjectId, ref: 'Team', required: true },
  date: { type: Date, required: true },
  result: {
    home_score: { type: Number, default: 0 },
    away_score: { type: Number, default: 0 },
    status: { type: String, default: 'upcoming' } 
  }
});

module.exports = mongoose.model('Match', MatchSchema);
