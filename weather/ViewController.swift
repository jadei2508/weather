//
//  ViewController.swift
//  weather
//
//  Created by Roman Alikevich on 07.05.2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    public static let BACKGROUND_IMAGE_VIEW = "clouds-1.jpg"
    public static let BACKGROUND_ERROR_IMAGE_VIEW = "exclamationmark.triangle"
    public static let CITY_LABEL_FLOAT_DIVIDER: CGFloat = 21.1
    public static let ADDITIONAL_LABEL_FLOAT_DIVIDER: CGFloat = 46.8
    public static let DEGREE_LABEL_FLOAT_DIVIDER: CGFloat = 7.887
    @IBOutlet private weak var city: UILabel!
    @IBOutlet private weak var additional: UILabel!
    @IBOutlet private weak var degree: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    private var tableViewCellHeightArray: [CGFloat] = [30.0, 90.0, 330.0, 50.0]
    private var getCurrentLocation: ((Double, Double)->Void)?
    private var network: WeatherNetwork?
    private var convertTime: TimeConverter?
    private var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        network = WeatherNetwork()
        convertTime = TimeConverter()
        setBackground()
        setUpColor()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.register(UINib(nibName: "CurrentWeatherView", bundle: nil), forCellReuseIdentifier: "currentWeatherView")
        tableView.register(UINib(nibName: "FourlyForecastView", bundle: nil), forCellReuseIdentifier: "fourlyForecastView")
        tableView.register(UINib(nibName: "CharacterViewCell", bundle: nil), forCellReuseIdentifier: "characterViewCell")
        
        getCurrentLocation = {(latitude, longitude) in
                DispatchQueue.global(qos: .userInitiated).sync { [weak self] in
                    guard let self = self else { return }
                    self.loadCurrentWeather(latitude: latitude, longitude: longitude)
                }
                
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    guard let self = self else { return }
                    self.loadHourlyForecastWeather(latitude: latitude, longitude: longitude)
                }
                
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    guard let self = self else { return }
                    self.loadDailyWeather(city: self.network?.currentWeather?.name ?? "London")
                }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    func loadCurrentWeather(latitude: Double, longitude: Double) {
        self.network?.currentWeather = network?.findWeatherByCoordinate(latitude: latitude, longitude: longitude) { [weak self] in
            guard let self = self else { return }
            self.city.text = self.network?.currentWeather?.name
            self.additional.text = self.network?.currentWeather?.weather.first?.weatherDescription
            self.degree.text = "\(Int(self.network?.currentWeather?.main?.temp ?? 0.0))°"
            self.tableView.reloadData()
        }
    }
    
    func loadDailyWeather(city: String) {
        self.network?.dailyWeather = network?.findDailyWeatherByCity(city: city) { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
    func loadHourlyForecastWeather(latitude: Double, longitude: Double) {
        self.network?.hourlyWeather = network?.findHourlyForecastByCoordinate(latitude: latitude, longitude: longitude) { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
    func setBackground() {
        self.view.backgroundColor = UIColor(patternImage: (UIImage(named: ViewController.BACKGROUND_IMAGE_VIEW) ?? UIImage(systemName: ViewController.BACKGROUND_ERROR_IMAGE_VIEW)!))
        tableView.backgroundColor = .clear
    }
    
    func setUpColor() {
        city.font = UIFont(name: city.font.fontName, size: self.view.frame.height / ViewController.CITY_LABEL_FLOAT_DIVIDER)
        additional.font = UIFont(name: city.font.fontName, size: self.view.frame.height / ViewController.ADDITIONAL_LABEL_FLOAT_DIVIDER)
        degree.font = UIFont(name: city.font.fontName, size: self.view.frame.height / ViewController.DEGREE_LABEL_FLOAT_DIVIDER)
        city.textColor = .white
        additional.textColor = .white
        degree.textColor = .white
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row > 3 {
            return tableViewCellHeightArray[4]
        }
        return tableViewCellHeightArray[indexPath.row]
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        if self.network?.currentWeather != nil {
            if indexPath.row == 0 {
                if let currentWeatherView = tableView.dequeueReusableCell(withIdentifier: "currentWeatherView", for: indexPath) as? CurrentWeatherView {
                    
                    let currentData = convertTime?.convertHourlyTime(Double(self.network?.currentWeather!.dt ?? 0))
                    currentWeatherView.weekDay.text = String((currentData?.components(separatedBy: ",")[0]) ?? "Monday")
                    currentWeatherView.maxDegree.text = String(Int(self.network?.currentWeather?.main?.tempMax ?? 0.0))
                    currentWeatherView.minDegree.text = String(Int(self.network?.currentWeather?.main?.tempMin ?? 0.0))
                    
                    currentWeatherView.weekDay.textColor = .white
                    currentWeatherView.maxDegree.textColor = .white
                    currentWeatherView.minDegree.textColor = .white
                    cell = currentWeatherView
                    cell?.backgroundColor = .clear
                }
            } else if indexPath.row == 2 {
                if let hourlyForecastView = tableView.dequeueReusableCell(withIdentifier: "fourlyForecastView", for: indexPath) as? FourlyForecastView {
                    print("dailyWeather")
                    if let layout = hourlyForecastView.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                        layout.scrollDirection = .vertical
                    }
                    print("dailyWeather")
                    let currentData = convertTime?.convertHourlyTime(Double(self.network?.currentWeather!.dt ?? 0))
                    
                    hourlyForecastView.viewWidth = tableView.frame.width
                    hourlyForecastView.weekdayWeatherArray = self.network?.dailyWeather?.list
                    cell = hourlyForecastView
                    cell?.backgroundColor = .clear
                    hourlyForecastView.collectionView?.reloadData()
                }
            } else if indexPath.row == 1 {
                print("weekDayWeather")
                if let hourlyForecastView = tableView.dequeueReusableCell(withIdentifier: "fourlyForecastView", for: indexPath) as? FourlyForecastView {
                    if let layout = hourlyForecastView.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                        layout.scrollDirection = .horizontal
                    }
                    print("weekDayWeather")
                    hourlyForecastView.viewHeight = tableViewCellHeightArray[indexPath.row]
                    hourlyForecastView.dailyWeatherList = self.network?.hourlyWeather?.hourly
                    cell = hourlyForecastView
                    cell?.backgroundColor = .clear
                    hourlyForecastView.collectionView?.reloadData()
                }
            } else if indexPath.row == 3 {
                if let characterView = tableView.dequeueReusableCell(withIdentifier: "characterViewCell", for: indexPath) as? CharacterViewCell {
                    characterView.title.text = "Восход солнца"
                    characterView.character.text = String((convertTime?.convertWeekDayTime(timeValue: Double(self.network?.currentWeather?.sys?.sunrise ?? 0)))!)
                    cell = characterView
                }
            } else {
                
            }
            cell?.backgroundColor = .clear
        }
        
        return cell ?? UITableViewCell()
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        if let action = getCurrentLocation {
            action(locValue.latitude, locValue.longitude)
        }
    }
}
