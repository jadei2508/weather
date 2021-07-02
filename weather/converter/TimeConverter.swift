//
//  TimeConverter.swift
//  ApiTest
//
//  Created by Roman Alikevich on 04.03.2021.
//

import UIKit

class TimeConverter {

    func convertHourlyTime(_ data: Double) -> String {
        let dateAndTime = Date(timeIntervalSince1970: data)
        let dateFormater = DateFormatter()
        dateFormater.timeStyle = .short
        dateFormater.dateFormat = "EEEE, MMMM, HH:mm"
        let currentdateAndTime = dateFormater.string(from: dateAndTime as Date)
        return currentdateAndTime
    }
    
    func sunTimeCoverter(timeValue: Double) -> String {
        let dateAndTime = Date(timeIntervalSince1970: timeValue)
        let dateFormater = DateFormatter()
        dateFormater.timeStyle = .short
        dateFormater.dateFormat = "h a"
        let currentdateAndTime = dateFormater.string(from: dateAndTime)
        return currentdateAndTime
    }
    
    func convertWeekDayTime(timeValue: Double) -> String {
        let dateAndTime = Date(timeIntervalSince1970: timeValue)
        let dateFormater = DateFormatter()
        dateFormater.timeStyle = .short
        dateFormater.dateFormat = "EEEE"
        let currentdateAndTime = dateFormater.string(from: dateAndTime)
        return currentdateAndTime
    }
}
