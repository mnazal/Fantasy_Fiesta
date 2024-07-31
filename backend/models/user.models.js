const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
  username: { type: String, 
    required: true,
     unique: true },
  email: { type: String, 
    required: true, unique: true },
  password: { type: String,
     required: true },
  created_at: { type: Date,
     default: Date.now
     },
  teams: [{ type: mongoose.Schema.Types.ObjectId, ref: 'FantasyTeam' }],
  totalPoints:{
    type: Number,
    default:0,
  },
  totalTeams:{
    type:Number,default:0
  }
});

module.exports = mongoose.model('User', UserSchema);
