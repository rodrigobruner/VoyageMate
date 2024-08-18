//
//  ForecastTableViewCell.swift
//  VoyageMate
//
//  Created by Rodrigo Bruner on 2024-08-16.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var minLabel: UILabel!
    
    @IBOutlet weak var maxLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(weather:DailyWeather){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        dateLabel.text = dateFormatter.string(from: weather.date)
        
        iconImageView.image = imageForWeatherCondition(icon: weather.icon)
        
            minLabel.text = "Min: \(weather.minTemp)°C"
            maxLabel.text = "Max: \(weather.maxTemp)°C"
            descriptionLabel.text = "\(weather.description)"
    }

}
