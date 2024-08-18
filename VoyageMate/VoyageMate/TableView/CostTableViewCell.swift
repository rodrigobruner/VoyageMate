//
//  CostTableViewCell.swift
//  VoyageMate
//
//  Created by Rodrigo Bruner on 2024-08-16.
//

import UIKit

class CostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func set(cost: Cost) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        
        let formatterCurrency = NumberFormatter()
        formatterCurrency.numberStyle = .currency
        formatterCurrency.locale = Locale.current
        
        
        var strDate = ""
        if let date = cost.date {
            strDate = formatter.string(from: date)
        }
        
        nameLabel.text = cost.name
        dateLabel.text = strDate
        valueLabel.text = formatterCurrency.string(from: NSNumber(value: cost.value))
    }
}
