const NodeCache = require('node-cache');
const cache = new NodeCache({ stdTTL: 700000 });

module.exports = cache;
