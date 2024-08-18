//
//  WeatherAPI.swift
//  VoyageMate
//
//  Created by Rodrigo Bruner on 2024-08-16.
//

import Foundation
import UIKit

func getTheClimateIn(latitude lat: Double, longitude lon: Double, completion: @escaping (WeatherRequest?, Error?) -> Void) {
    let urlSession = URLSession(configuration: .default)
    let apiToken = Constants.WeatherAPI.keyAPI
    let unit = Constants.WeatherAPI.unit
    guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(String(lat))&lon=\(String(lon))&units=\(unit)&appid=\(apiToken)")
    else {
        completion(nil, NSError(domain: "InvalidURL", code: 0, userInfo: nil))
        return
    }
    
    print(url)

    let dataTask = urlSession.dataTask(with: url) { (data, response, error) in
        if let error = error {
            completion(nil, error)
            return
        }
        
        guard let data = data else {
            completion(nil, NSError(domain: "NoData", code: 0, userInfo: nil))
            return
        }
        
        do {
            let weather = try JSONDecoder().decode(WeatherRequest.self, from: data)
            completion(weather, nil)
        } catch {
            completion(nil, error)
        }
    }
    dataTask.resume()
}

func getWeatherForecast(latitude lat: Double, longitude lon: Double, completion: @escaping (WeatherResponse?, Error?) -> Void) {
    let urlSession = URLSession(configuration: .default)
    let apiToken = Constants.WeatherAPI.keyAPI
    let unit = Constants.WeatherAPI.unit
    guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(String(lat))&lon=\(String(lon))&units=\(unit)&appid=\(apiToken)")
    else {
        completion(nil, NSError(domain: "InvalidURL", code: 0, userInfo: nil))
        return
    }
    
    print(url)

    let dataTask = urlSession.dataTask(with: url) { (data, response, error) in
        if let error = error {
            completion(nil, error)
            return
        }
        
        guard let data = data else {
            completion(nil, NSError(domain: "NoData", code: 0, userInfo: nil))
            return
        }
        
        do {
            let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
            completion(weatherResponse, nil)
        } catch {
            completion(nil, error)
        }
    }
    dataTask.resume()
}

//Source https://openweathermap.org/weather-conditions#Weather-Condition-Codes-2
func imageForWeatherCondition(icon: String) -> UIImage {
    switch icon {
    case "01d":
        var img = UIImage(systemName: "sun.max.fill")!
        img = img.withTintColor(.yellow, renderingMode: .alwaysOriginal)
        return img
    case "01n":
        var img = UIImage(systemName: "moon.fill")!
        img = img.withTintColor(.white, renderingMode: .alwaysOriginal)
        return img
    case "02d", "03d", "04d":
        var img = UIImage(systemName: "cloud.sun.fill")!
        img = img.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        return img
    case "02n", "03n", "04n":
        var img = UIImage(systemName: "cloud.moon.fill")!
        img = img.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        return img
    case "09d", "09n", "10d", "10n":
        var img = UIImage(systemName: "cloud.rain.fill")!
        img = img.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
        return img
    case "11d", "11n":
        var img = UIImage(systemName: "cloud.bolt.rain.fill")!
        img = img.withTintColor(.darkGray, renderingMode: .alwaysOriginal)
        return img
    case "13d", "13n":
        var img = UIImage(systemName: "snowflake")!
        img = img.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        return img
    case "50d":
        var img = UIImage(systemName: "sun.haze.fill")!
        img = img.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        return img
    case "50n":
        var img = UIImage(systemName: "moon.haze.fill")!
        img = img.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        return img
    default:
        var img = UIImage(systemName: "sun.max.fill")!
        img = img.withTintColor(.yellow, renderingMode: .alwaysOriginal)
        return img
    }
}


//Source https://openweathermap.org/weather-conditions#Weather-Condition-Codes-2
func backgroundForWeatherCondition(icon: String) -> UIImage {
    switch icon {
    case "01d":
        let img = UIImage(named: "sun")!
        return img
    case "01n":
        let img = UIImage(named: "night")!
        return img
    case "02d", "03d", "04d", "50d":
        let img = UIImage(named: "cloud")!
        return img
    case "02n", "03n", "04n","50n":
        let img = UIImage(named: "night")!
        return img
    case "09d", "09n", "10d", "10n":
        let img = UIImage(named: "rain")!
        return img
    case "11d", "11n":
        let img = UIImage(named: "rainNight")!
        return img
    case "13d", "13n":
        let img = UIImage(named: "snow")!
        return img
    default:
        let img = UIImage(named: "cloud")!
        return img
    }
}
