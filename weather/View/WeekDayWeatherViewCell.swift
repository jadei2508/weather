//
//  TableView.swift
//  ApiTest
//
//  Created by Roman Alikevich on 02.04.2021.
//

import UIKit

class WeekDayWeatherViewCell: UICollectionViewCell {
    @IBOutlet var date: UILabel!
    @IBOutlet var picture: UIImageView!
    @IBOutlet weak var minimalDegree: UILabel!
    @IBOutlet weak var maximalDegree: UILabel!

    //    @IBOutlet var degree: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
