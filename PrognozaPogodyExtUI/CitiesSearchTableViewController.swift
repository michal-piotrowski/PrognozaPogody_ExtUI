//
//  CitiesSearchTableViewController.swift
//  PrognozaPogodyExtUI
//
//  Created by IHaveAMacNow on 12/11/2018.
//  Copyright © 2018 MPiotrowski. All rights reserved.
//

import UIKit

class CitiesSearchTableViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var weathers : [WeathersInLocation] = [WeathersInLocation]()
    var searching = false
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text
        if (!text!.isEmpty) {
            citiesFiltered = cities.filter({$0.cityName.prefix(text!.count) == text!})
        }
        self.searching = true
        self.tableView.reloadData()
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        self.searching = false
        self.navigationController?.popViewController(animated: true)
    }
    
    var selectedCity: WeathersInLocation!
    
    var cities: [City] = [
        City(cityName:"Ciudad de Buenos Aires", woeid:"468739"),
        City(cityName:"Buenos Aires", woeid:"344675"),
        City(cityName:"Phuket", woeid:"1226113"),
        City(cityName:"Miami, FL", woeid:"2450022"),
        City(cityName:"Anchorage, AL", woeid:"2354490"),
        City(cityName:"Tjanjin", woeid:"2159908"),
        City(cityName:"Kinshasa", woeid:"1290062"),
        City(cityName:"Bogota", woeid:"368148")   
    ]
    var citiesFiltered: [City] = [City]()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "unwindSegue") {
            var mainView = segue.destination as! MasterViewController
            mainView.weathers = self.weathers
            print("unwindSegue")
            print(String(mainView.weathers.count) + " mainViewWeathers" )
//            self.tableView.reloadData()
        }

    }
    
    override func viewDidLoad() {
        self.searchBar.delegate = self
        super.viewDidLoad()
        self.searchBar.placeholder = "Search by city name"
//        self.tableView.dataSource = self
//        self.tableView.delegate = self
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searching) {
            return citiesFiltered.count
        } else {
            return cities.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CityCell
        if (searching) {
            cell.textLabel?.text = citiesFiltered[indexPath.row].cityName
        } else {
            cell.textLabel?.text = cities[indexPath.row].cityName
        }
//        var targetController = na
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Tutaj wchodzi przy wybraniu komorki
       var city = cities[indexPath.row]
//        var weather = WeathersInLocation()
//        weather.location = city.cityName
//        weather.woeid = city.woeid
//        print("adding city " + city.cityName)
//        weathers.append(weather)
        (self.navigationController?.topViewController as! MasterViewController).getWeatherInformationForWOEID(woeid: city.woeid, locationName: city.cityName)
        self.navigationController?.popViewController(animated: true)
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         Get the new view controller using segue.destination.
         Pass the selected object to the new view controller.
    }
    */

}
