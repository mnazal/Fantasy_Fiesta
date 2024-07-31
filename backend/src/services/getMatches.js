const axios = require('axios');
const cheerio = require('cheerio');


let match_number=0



async function getMatchesList(url) {
    try {
        
        const { data } = await axios.get(url);

        
        const $ = cheerio.load(data);
        let match_number=0

  
        const matches = $('tbody.Table__TBODY .Table__TR--sm').map((index, element) => {
            
            const matchLink = $(element).find('.date__col a').attr('href');

            match_number=match_number+1
            
            
            let matchId = null;
            if (matchLink) {
                const parts = matchLink.split('/');
                matchId = parts.length > 2 ? parts[parts.length - 2] : null;
            }

            
            const awayTeamLink = $(element).find('.Table__Team.away a').eq(1).attr('href');

            let awayTeamId = null;
            if (awayTeamLink) {
                const parts = awayTeamLink.split('/');
                awayTeamId = parts.length > 2 ? parts[parts.length - 2] : null;
            }
            const awayTeam = $(element).find('.Table__Team.away a').eq(1).text().trim();

            const homeTeamLink = $(element).find('.Table__Team').eq(1).find('a').eq(1).attr('href');
            let homeTeamId = null;
            if (homeTeamLink) {
                const parts = homeTeamLink.split('/');
                homeTeamId = parts.length > 2 ? parts[parts.length - 2] : null;
            }
            const homeTeam = $(element).find('.Table__Team').eq(1).find('a').eq(1).text().trim();
            
           
         
            const time = $(element).find('.date__col a').text().trim();
            const venue = $(element).find('.venue__col').text().trim();
            const ftText = $(element).find('td.teams__col.Table__TD a.AnchorLink').text().trim();
            
            if(time=='LIVE' || ftText.includes('FT')){
                return {};
            }

            return { match_number, matchId, awayTeamId, awayTeam, homeTeamId, homeTeam, time, venue };
        }).get();

        const selectedMatches=matches.filter(match=> match.match_number!=null).slice(0,6);

        return selectedMatches
    } catch (error) {
        console.error('Error fetching data:', error);
    }
}

module.exports = { getMatchesList };

