//
//  ProjectSettings.swift
//  Weather
//
//  Created by Rodrigo Bruner on 2024-07-20.
//

import Foundation

class Constants{
    
    class WeatherAPI{
        // Create your API key on the openweathermap.org website
        static let keyAPI = "721a2c19ff4023ffafd089406c3f0f71"
        
        //options :
        //   - metric:  in Kelvin
        //   - imperial: in Fahrenheit
        //   - standard:  in Celsius
        static let unit = "metric"
    }
    
    class Destination{
        static let withoutDestination = "Destination not assigned"
    }
    
    class Cost{
        static let totalCost = "Total: "
    }
}
