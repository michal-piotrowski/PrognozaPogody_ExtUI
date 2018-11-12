//
//  MasterViewController.swift
//  PrognozaPogodyExtUI
//
//  Created by Student on 23.10.2018.
//  Copyright © 2018 MPiotrowski. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var weathers = [WeathersInLocation]()
    var downloadedImages: [String: UIImage] = [:]
    
    private let WOEID_WARSAW: String = "523920"
    private let WOEID_HELSINKI: String = "565346"
    private let WOEID_OSLO: String = "862592"

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        loadInitialCities();
        
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
//
//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        
//        navigationItem.rightBarButtonItem = addButton
//        if let split = splitViewController {
//            let controllers = split.viewControllers
//            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
//        }
    }
    
    func loadInitialCities() {
        // get weather for WARSAW, LONDON, HELSINKI FROM API
        self.getWeatherInformationForWOEID(woeid: WOEID_WARSAW, locationName: "Warszawa")
        self.getWeatherInformationForWOEID(woeid: WOEID_HELSINKI, locationName: "Helsinki")
        self.getWeatherInformationForWOEID(woeid: WOEID_OSLO, locationName: "Oslo")
    }
    
    func getWeatherInformationForWOEID(woeid: String, locationName: String) {
        let locationWeathers: WeathersInLocation = WeathersInLocation()
        locationWeathers.location = locationName
        locationWeathers.woeid = woeid
        let url: URL = URL(string: "https://www.metaweather.com/api/location/\(woeid)/")!
        let session = URLSession.shared
        var json: [String: Any] = [:]
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if data != nil {
                do {
                    json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                    locationWeathers.weathers = self.getWeatherForNDays(json: json)
                    self.weathers.append(locationWeathers)
                    self.downloadImage(typeAbbr: locationWeathers.weathers[0].weather_state_abbr)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    //                    self.setInitialView()
                }
                catch
                {
                    return
                }
            }
        })
        task.resume()
    }
    
    func downloadImage(typeAbbr:String) {
        if (downloadedImages.keys.contains(typeAbbr)) {
            return
        }
        let url: URL = URL(string: "https://www.metaweather.com/static/img/weather/png/\(typeAbbr).png")!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if (error != nil) {
                print(error!)
                return
            }
            if data != nil {
                self.downloadedImages[typeAbbr] = UIImage(data: data!)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        task.resume()
    }
    
    func getWeatherForNDays (json: [String: Any]?) -> [DayWeatherInLocation] {
        var weathers: [DayWeatherInLocation] = [DayWeatherInLocation]()
        for i in 0...(json!["consolidated_weather"] as! [[String: Any]]).count - 1 {
            let singleWeatherDict = (json!["consolidated_weather"]as! [[String: Any]])[i]
            let dayWeather = DayWeatherInLocation()
            dayWeather.min_temp = (singleWeatherDict["min_temp"] as! NSNumber)
            dayWeather.max_temp = (singleWeatherDict["max_temp"] as! NSNumber)
            dayWeather.weather_state_name = (singleWeatherDict["weather_state_name"] as! String)
            dayWeather.weather_state_abbr = (singleWeatherDict["weather_state_abbr"] as! String)
            dayWeather.wind_speed = (singleWeatherDict["wind_speed"] as! NSNumber)
            dayWeather.wind_direction = (singleWeatherDict["wind_direction"] as! NSNumber)
            dayWeather.air_pressure = (singleWeatherDict["air_pressure"] as! NSNumber)
            dayWeather.applicable_date = (singleWeatherDict["applicable_date"] as! String)
            WeatherDAO.downloadImage(typeAbbr: dayWeather.weather_state_abbr!)
            weathers.append(dayWeather)
        }
        return weathers;
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
//
//    @objc
//    func insertNewObject(_ sender: Any) {
//        weathers.insert(WeathersInLocation(), at: 0)
//        let indexPath = IndexPath(row: 0, section: 0)
//        tableView.insertRows(at: [indexPath], with: .automatic)
//    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = weathers[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weathers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WeatherTableCell
        let weather = weathers[indexPath.row]
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        tableView.estimatedRowHeight = 170
        cell.cityName.text = weather.location
        if !weather.weathers.isEmpty {
            cell.temperature.text = String(format:"%.1f°C", weather.weathers[0].max_temp.floatValue)
        } else {
            cell.temperature.text = "emptyArray"
        }
        cell.weatherIcon.image = downloadedImages[weather.weathers[0].weather_state_abbr]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            weathers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
//
//    func parseJson(weather: WeathersInLocation) {
//        let url: URL = URL(string: "https://www.metaweather.com/api/location/\(weather.woeid!)/")!
//        let session = URLSession.shared
//        var json: [String: Any] = [:]
//                session.dataTask(with: url, completionHandler: {
//                    (data, response, error) in
//                    if data != nil {
//                        do {
//                            json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
//                            let weathers = WeatherDAO.getWeatherForNDays(json: json)
//                            //                    self.setInitialView()
//                            DispatchQueue.main.async {
//                                cell.cityName.text = weather.location
//                                    cell.weatherIcon.image = weathers[0].weather_state_image
//                                cell.temperature.text = String(format:"%.1f°C", weathers[0].max_temp.floatValue)
//                                //                    return cell
//                                tableView.reloadData()
//                            }
//
//                        }
//                        catch
//                        {
//                            return
//                        }
//                    }
//                }).resume()
//    }


}

