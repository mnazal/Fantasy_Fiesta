const axios = require('axios');
const cheerio = require('cheerio');

async function getPlayerDetails(url) {
    try {
        const { data } = await axios.get(url);
        const $ = cheerio.load(data);


               // Extract player details for a single player
        const playerDetails = $('tr.odd').first().map((index, element) => {
            const playerImage = $(element).find('img.bilderrahmen-fixed').attr('src');
            const someValue = $(element).find('td.hauptlink').text().trim()||
                $(element).find('td.rechts').last().text().trim();
            const marketValue=parseFloat(someValue.split('€')[1].replace('m',''));
            

            return {
                playerImage,
                marketValue
            };
        }).get()[0]; // Get the first (and only) result


        return playerDetails;

    } catch (error) {
        console.error("Error fetching data: ", error);
    }
}

module.exports = { getPlayerDetails };
