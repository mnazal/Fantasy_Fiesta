const axios = require('axios');
const cheerio = require('cheerio');


const { calculatePlayerValue } = require('./playerValueAgorithm');

async function getPlayerDetails(url, age, position) {
    try {
        const { data } = await axios.get(url);
        const $ = cheerio.load(data);


               // Extract player details for a single player
        const playerDetails = $('tr.odd').first().map((index, element) => {
            let marketValue=0
            const playerImage = $(element).find('img.bilderrahmen-fixed').attr('src');
            const someValue = $(element).find('td.hauptlink').text().trim()||
                $(element).find('td.rechts').last().text().trim();

                if(someValue.slice(-1)=='-'){
                    marketValue=0
               }else{
                   if(someValue.slice(-1)=='k'){
                        marketValue=parseFloat(someValue.split('€')[1].replace('k',''))/1000;
                   }else{
                        marketValue=parseFloat(someValue.split('€')[1].replace('m',''));
                   }
               }

               const newMarketValue=marketValue==0 ?0: calculatePlayerValue(position,parseInt(age),marketValue);
               console.log(newMarketValue);
           
            

            return {
                playerImage,
                newMarketValue
            };
        }).get()[0]; // Get the first (and only) result


        return playerDetails;

    } catch (error) {
        console.error("Error fetching data: ", error);
    }
}

module.exports = { getPlayerDetails };
