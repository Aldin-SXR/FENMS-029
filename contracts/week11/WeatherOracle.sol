// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract WeatherOracle {
    // Mapping from jobId => completion status for smart contract interactions to check
    mapping(uint => bool) public jobStatus;

    // Mapping jobId => temperature
    mapping(uint => uint) public jobResults;

    // Current jobId available
    uint jobId;

    // Event to trigger the Oracle API
    event RequestWeatherData(uint lat, uint lon, uint jobId);

    constructor(uint initialId) {
        jobId = initialId;
    }

    function getWeather(uint lat, uint lon) public {
        // Emit event to API with data and JobId
        emit RequestWeatherData(lat, lon, jobId);
        // Increment jobId for next job/function call
        jobId++;
    }

    function updateWeather(uint temp, uint _jobId) public {
        // updateWeather() is called by Node.js; upon API results, data is updated
        jobResults[_jobId] = temp;
        jobStatus[_jobId] = true;
    }

    function getLatestTemperature() external view returns (uint) {
        return jobResults[jobId - 1];
    }
}
