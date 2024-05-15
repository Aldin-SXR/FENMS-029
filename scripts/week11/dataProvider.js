const axios = require('axios');

console.log("Setting up data provider...");

// your weather contract address
const WEATHER_ORACLE_ADDRESS = '0xACd765b8173F797311286f2fd7F78b6c3eDB38b9'

// A simple function for calling API with lat and long, returning temp from JSON
const callAPI = async (lat, long) => {
    return await axios.get(`https://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${long}&current_weather=true`)
}

main = async () => {
    // Initialize a contract listener for emissions of the "RequestWeatherData" event
    const weatherOracle = await ethers.getContractAt("WeatherOracle", WEATHER_ORACLE_ADDRESS);
    console.log("Listening for events...")

    // Since EVM does not support floating-point numbers, we will be
    // dividing and multiplying by 100 (assume all values are rounded to 2 decimals)
    weatherOracle.on("RequestWeatherData", async (lat, long, jobId) => {
        // Use lat and long to call API
        const { data: weatherData } = await callAPI((Number(lat) / 100).toFixed(2), (Number(long) / 100).toFixed(2))
        const temp = weatherData.current_weather.temperature
        console.log(`Weather update request received. Temperature: ${temp}`)

        if (weatherData) {
            // Send data to updateWeather function on blockchain if temp is received
            await weatherOracle.updateWeather((temp * 100).toFixed(0), jobId);
            console.log("Weather data successfully updated.")
        }
    })
}

main()
