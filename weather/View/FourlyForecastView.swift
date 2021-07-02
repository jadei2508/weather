//
//  FourlyForecastView.swift
//  weather
//
//  Created by Roman Alikevich on 08.05.2021.
//

import UIKit
enum TypeView {
    case hourly
    case daily
}
class FourlyForecastView: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    var dailyWeatherList: [HourlyWeatherData]? {
        didSet {
            collectionViewCellSize = dailyWeatherList?.count
            typeView = .hourly
            collectionViewWidth = collectionView.frame.width / 8
            collectionViewHeight = viewHeight
        }
    }
    var weekdayWeatherArray: [WeatherArray]? {
        didSet {
            collectionViewCellSize = weekdayWeatherArray?.count
            typeView = .daily
            collectionViewWidth = viewWidth
            collectionViewHeight = collectionView.frame.height / 10
        }
    }
    var collectionViewCellSize: Int?
    var typeView: TypeView?
    var viewHeight: CGFloat?
    var viewWidth: CGFloat?
    var collectionViewWidth: CGFloat?
    var collectionViewHeight: CGFloat?
    var convertTime: TimeConverter?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("blablablabblaawakeFromNib")
        //        print(dailyWeatherList)
        convertTime = TimeConverter()
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(UINib(nibName: "DailyWeatherController", bundle: nil), forCellWithReuseIdentifier: "dailyWeather")
        collectionView?.register(UINib(nibName: "WeekDayWeatherViewCell", bundle: nil), forCellWithReuseIdentifier: "weekDayWeather")
        collectionView?.backgroundColor = .clear
    }
}


extension FourlyForecastView:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewCellSize ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        print(viewHeight)
        return CGSize(width: collectionViewWidth ?? 0.0, height: collectionViewHeight ?? 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("collectionViewCellSize")
        
        if typeView == TypeView.hourly {
            if let currentView = collectionView.dequeueReusableCell(withReuseIdentifier: "dailyWeather", for: indexPath) as? DailyWeatherController {
                currentView.degree.text = "\(Int(dailyWeatherList?[indexPath.item].temp ?? 273 - 273))°"
                var url = URL(string: "https://openweathermap.org/img/w/" + (dailyWeatherList?[indexPath.item].weather?.first?.icon ?? "") + ".png")
                if let imageData = try? Data(contentsOf: url!) {
                    let img = UIImage(data: imageData)
                    currentView.imageView.image = img
                }
                
                currentView.time.text = convertTime?.sunTimeCoverter(timeValue: Double(dailyWeatherList?[indexPath.item].dt ?? 0))
                currentView.backgroundColor = .clear
                return currentView
            }
        } else if typeView == TypeView.daily {
            if let currentView = collectionView.dequeueReusableCell(withReuseIdentifier: "weekDayWeather", for: indexPath) as? WeekDayWeatherViewCell {
                currentView.date.text = convertTime?.convertWeekDayTime(timeValue: Double(weekdayWeatherArray?[indexPath.item].dt ?? 0))
                var url = URL(string: "https://openweathermap.org/img/w/" + (weekdayWeatherArray?[indexPath.item].weather?.first?.icon ?? "") + ".png")
                if let imageData = try? Data(contentsOf: url!) {
                    let img = UIImage(data: imageData)
                    currentView.picture.image = img
                }
                //                currentView.picture =
                currentView.maximalDegree.text = String(Int(weekdayWeatherArray?[indexPath.item].temp?.max ?? 0))
                currentView.minimalDegree.text = String(Int(weekdayWeatherArray?[indexPath.item].temp?.min ?? 0))
                currentView.backgroundColor = .clear
                
                return currentView
            }
        }
        
        
        
        //        for i in 0..<length {
        //            currentView.degree.text = "\(Int(weather.temp ?? 273 - 273))°"
        //            var url = URL(string: "https://openweathermap.org/img/w/" + (weather.weather?.first?.icon ?? "") + ".png")
        //            if let imageData = try? Data(contentsOf: url!) {
        //                let img = UIImage(data: imageData)
        //                currentView.imageView.image = img
        //            }
        //
        //            currentView.time.text = convertTime?.sunTimeCoverter(timeValue: Double(weather.dt ?? 0))
        //            currentView.backgroundColor = .clear
        ////                            hourlyForecastView.dailyWeatherList.append(currentView)
        //
        //        }
        return UICollectionViewCell()
    }
    
    
}
