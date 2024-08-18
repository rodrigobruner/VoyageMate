//
//  TripTableViewCell.swift
//  VoyageMate
//
//  Created by user228347 on 8/11/24.
//

import UIKit

class TripTableViewCell: UITableViewCell {
    
    let tripNameLabel = UILabel()
    let destinationLabel = UILabel()
    let destinationIcon = UIImageView()
    let startDateLabel = UILabel()
    let startDateIcon = UIImageView()
    let endDateLabel = UILabel()
    let endDateIcon = UIImageView()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(trip:Trip){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        
        var destination = Constants.Destination.withoutDestination
        if let dest = trip.destination, !dest.isEmpty {
            destination = trip.destination!
        }
        
        var start = ""
        startDateIcon.isHidden = true
        if trip.start != nil {
            start = formatter.string(from:trip.start!)
            startDateIcon.isHidden = false
        }
        
        var end = ""
        endDateIcon.isHidden = true
        if trip.end != nil {
            end = formatter.string(from:trip.end!)
            endDateIcon.isHidden = false
        }
        
        tripNameLabel.text = trip.name
        destinationLabel.text = destination
        startDateLabel.text = start
        endDateLabel.text = end
    }
    
    func render(){
        tripNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        contentView.addSubview(tripNameLabel)
        tripNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        destinationIcon.image = UIImage(systemName: "mappin.and.ellipse")
        destinationIcon.tintColor = .gray
        contentView.addSubview(destinationIcon)
        destinationIcon.translatesAutoresizingMaskIntoConstraints = false
        
        destinationLabel.font = UIFont.boldSystemFont(ofSize: 14)
        destinationLabel.textColor = .gray
        contentView.addSubview(destinationLabel)
        destinationLabel.translatesAutoresizingMaskIntoConstraints = false
      
        
        startDateIcon.image = UIImage(systemName: "calendar.badge.clock.rtl")
        startDateIcon.tintColor = .gray
        contentView.addSubview(startDateIcon)
        startDateIcon.translatesAutoresizingMaskIntoConstraints = false
        
        startDateLabel.font = UIFont.systemFont(ofSize: 14)
        startDateLabel.textColor = .gray
        contentView.addSubview(startDateLabel)
        startDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        endDateIcon.image = UIImage(systemName: "calendar.badge.clock")
        endDateIcon.tintColor = .gray
        contentView.addSubview(endDateIcon)
        endDateIcon.translatesAutoresizingMaskIntoConstraints = false
        
        endDateLabel.font = UIFont.systemFont(ofSize: 14)
        endDateLabel.textColor = .gray
        contentView.addSubview(endDateLabel)
        endDateLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            tripNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            tripNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            tripNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            destinationIcon.topAnchor.constraint(equalTo: tripNameLabel.bottomAnchor, constant: 5),
            destinationIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            destinationIcon.widthAnchor.constraint(equalToConstant: 20),
            destinationIcon.heightAnchor.constraint(equalToConstant: 20),
            
            destinationLabel.centerYAnchor.constraint(equalTo: destinationIcon.centerYAnchor),
            destinationLabel.leadingAnchor.constraint(equalTo: destinationIcon.trailingAnchor, constant: 8),
            destinationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            startDateIcon.topAnchor.constraint(equalTo: destinationIcon.bottomAnchor, constant: 5),
            startDateIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            startDateIcon.widthAnchor.constraint(equalToConstant: 20),
            startDateIcon.heightAnchor.constraint(equalToConstant: 20),
            
            startDateLabel.centerYAnchor.constraint(equalTo: startDateIcon.centerYAnchor),
            startDateLabel.leadingAnchor.constraint(equalTo: startDateIcon.trailingAnchor, constant: 8),
            
            endDateIcon.centerYAnchor.constraint(equalTo: startDateIcon.centerYAnchor),
            endDateIcon.leadingAnchor.constraint(equalTo: startDateLabel.trailingAnchor, constant: 20),
            endDateIcon.widthAnchor.constraint(equalToConstant: 20),
            endDateIcon.heightAnchor.constraint(equalToConstant: 20),
            
            endDateLabel.centerYAnchor.constraint(equalTo: endDateIcon.centerYAnchor),
            endDateLabel.leadingAnchor.constraint(equalTo: endDateIcon.trailingAnchor, constant: 8),
            endDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            endDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        self.backgroundColor = UIColor(named: "background")
    }
    

}
