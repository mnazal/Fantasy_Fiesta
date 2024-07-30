



function calculatePlayerValue(position, age, marketValue){

    const positionWeights={
        "G":0.7,
        "D":1.2,
        "M":1.4,
        "F":1.7
    }

    const peakAge=25;
    const minValue=0;
    const maxValue=180;

    const ageFactor=1-(Math.abs(age-peakAge)/peakAge);


    const logMarketValue=Math.log(marketValue+1);
    const logMaxValue=Math.log(maxValue);
    const normalisedMarketValue=(logMarketValue)/logMaxValue;
    const positionWeightage=positionWeights[position] || 1.0;


    const playerValue= (positionWeightage * ageFactor * normalisedMarketValue)*10;

    return playerValue.toFixed(1);
}

module.exports={calculatePlayerValue}