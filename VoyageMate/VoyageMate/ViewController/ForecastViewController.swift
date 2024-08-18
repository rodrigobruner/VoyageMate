//
//  ForecastViewController.swift
//  VoyageMate
//
//  Created by Rodrigo Bruner on 2024-08-16.
//

import UIKit
import CoreLocation

class ForecastViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var minImageView: UIImageView!
    
    @IBOutlet weak var minLabel: UILabel!
    
    @IBOutlet weak var maxImageView: UIImageView!
    
    @IBOutlet weak var maxLabel: UILabel!
    
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var loadingLabel: UILabel!
    
    
    var trip: Trip?
    var lat: Double?
    var lon: Double?
    
    private var models = [DailyWeather]()
    private var now: DailyWeather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Table View
        tableView.dataSource = self
        tableView.delegate = self
        
        let tabBar = tabBarController as! TabBarViewController
        trip = tabBar.objTrip
        
        if let dest = trip?.destination, !dest.isEmpty {
            getCoordinateFromAddress(address: trip?.destination)
            loadingView.isHidden = false
        } else {
            loadingLabel.text = Constants.Destination.withoutDestination
        }
        
        
    }
    
    
    //MARK: Get trip ---
    override func viewWillAppear(_ animated: Bool) {
        let tabBar = tabBarController as! TabBarViewController
        trip = tabBar.objTrip
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let tabBar = tabBarController as! TabBarViewController
        tabBar.objTrip = trip
    }
    
    //MARK: get coordinate ---
    private func getCoordinateFromAddress(address: String?) {
        
        if address != nil {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address!) { (placemarks, error) in
                if let error = error {
                    // TODO: Add alert
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                if let placemark = placemarks?.first, let location = placemark.location {
                    let coordinate = location.coordinate
                    
                    self.lat = coordinate.latitude
                    self.lon = coordinate.longitude
                    
//                    print(self.lat)
//                    print(self.lon)
                    
                    self.getForecast()
                }
            }
        }
    }
    
    //MARK: get Forcast ---
    func getForecast(){
        if self.trip?.destination == nil || self.lat == nil || self.lon == nil {
            //TODO: Show a mensage
            
//            print(self.lat)
//            print(self.lon)
//            print(self.trip?.destination)
            
            print("The destination could not be defined")
        } else {
            getWeatherForecast(latitude: self.lat!, longitude: self.lon!) { [self] weatherResponse, error in
                if let error = error {
                    print("Failed to fetch weather forecast: \(error)")
                } else if let weatherResponse = weatherResponse {
//                  print(weatherResponse)
                    
                    let groupedForecasts = Dictionary(grouping: weatherResponse.list) { forecast -> Date in
//                        print(forecast)
                         let date = Date(timeIntervalSince1970: TimeInterval(forecast.dt))
                         let calendar = Calendar.current
                         return calendar.startOfDay(for: date)
                    }
                    
                    // https://openweathermap.org/forecast5#example_JSON
                    self.models = groupedForecasts.map { (key, value) -> DailyWeather in
//                        print(key)
//                        print(value)
                        let minTemp = value.map { $0.main.tempMin }.min() ?? 0.0
                        let maxTemp = value.map { $0.main.tempMax }.max() ?? 0.0
                        let description = value.first?.weather.first?.description ?? ""
                        let icon = value.first?.weather.first?.icon ?? ""
                        
                        return DailyWeather(date: key, minTemp: minTemp, maxTemp: maxTemp, description: description, icon: icon)
                    }
                    //Order by date
                    self.models.sort(by: { $0.date < $1.date })
                    print(self.models.count)
                    
                    //Separate current forecast
                    if !self.models.isEmpty {
                        self.now = self.models.removeFirst()
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.renderNow()
                    }
                }
            }
        }
    }
    
    
    func renderNow(){
        print("Render NOW")
        if now != nil {
            
            iconImageView.translatesAutoresizingMaskIntoConstraints = false
            iconImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            iconImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
            minImageView.translatesAutoresizingMaskIntoConstraints = false
            minImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            minImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            maxImageView.translatesAutoresizingMaskIntoConstraints = false
            maxImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            maxImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            iconImageView.image = imageForWeatherCondition(icon: self.now!.icon)
            titleLabel.text = trip?.destination
            
            let description = now?.description != nil ? String(now!.description) : ""
            let min = now?.minTemp != nil ? String(now!.minTemp) : ""
            let max = now?.maxTemp != nil ? String(now!.maxTemp) : ""
            
            descriptionLabel.text = "Now: \(description)"
            minLabel.text = "Min: \(min)°C"
            maxLabel.text = "Max: \(max)°C"
            
            loadingView.isHidden = true
        }
    }
}


extension ForecastViewController:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath) as! ForecastTableViewCell
        let forecast = models[indexPath.row]
        print(forecast)
        cell.set(weather: forecast)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 80.0
    }
}
