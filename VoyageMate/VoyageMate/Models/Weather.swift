//
//  Weather.swift
//  VoyageMate
//
//  Created by Rodrigo Bruner on 2024-08-16.
//
import Foundation

// MARK: - WeatherRequest
struct WeatherRequest: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [WeatherForecast]
    let city: City
}

// MARK: - WeatherForecast
struct WeatherForecast: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let sys: Sys
    let dt_txt: String
    let rain: Rain?
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity, seaLevel, grndLevel: Int
    let temp_kf: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case temp_kf
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int?
    let country: String?
    let sunrise, sunset: Int?
    let pod: String?
}

// MARK: - Rain
struct Rain: Codable {
    let threeHour: Double?

    enum CodingKeys: String, CodingKey {
        case threeHour = "3h"
    }
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: Int
    let sunset: Int
}

// MARK: - Coordinate
struct Coord: Codable {
    let lon, lat: Double
}


// MARK: - Daily Weather
struct DailyWeather {
    let date: Date
    let minTemp: Double
    let maxTemp: Double
    let description: String
    let icon: String
}
