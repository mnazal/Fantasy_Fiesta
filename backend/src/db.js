const mongoose = require('mongoose');

const dbName = 'fantasyfiesta';
const dbUri = `mongodb+srv://mnazal:wantsandneeds@cluster0.3jkakfx.mongodb.net/${dbName}?retryWrites=true&w=majority&appName=Cluster0`;

module.exports = { dbUri };
