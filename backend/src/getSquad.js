const axios = require('axios');
const cheerio = require('cheerio');

let player_number=0;

async function getSquadList(url) {
    try {
        const { data } = await axios.get(url);
        const $ = cheerio.load(data);

        const squad = $('tbody.Table__TBODY tr').map((index, element) =>{
            player_number=player_number+1;
            const playerName = $(element).find('a.AnchorLink').text().trim();
            
            const jerseyNumber = $(element).find('span.pl2.n10').text().trim();
            const position = $(element).find('td:nth-child(2) div').text().trim();

            const playerLink= $(element).find('a').attr('href');
            let playerid=null;
            if (playerLink) {
                const parts = playerLink.split('/');
                playerid = parts.length > 2 ? parts[parts.length - 2] : null;
            }
            
            
            return { player_number, playerid, playerName, jerseyNumber, position };
        }).get();

        return squad;
    } catch (error) {
        console.error("Error fetching data: ", error);
    }
}


module.exports={ getSquadList }
