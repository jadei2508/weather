//
//  CurrentWeatherView.swift
//  weather
//
//  Created by Roman Alikevich on 07.05.2021.
//

import UIKit

class CurrentWeatherView: UITableViewCell {
    @IBOutlet weak var weekDay: UILabel!
    @IBOutlet weak var minDegree: UILabel!
    @IBOutlet weak var maxDegree: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
