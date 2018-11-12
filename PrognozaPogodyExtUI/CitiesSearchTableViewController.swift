//
//  CitiesSearchTableViewController.swift
//  PrognozaPogodyExtUI
//
//  Created by IHaveAMacNow on 12/11/2018.
//  Copyright © 2018 MPiotrowski. All rights reserved.
//

import UIKit

class CitiesSearchTableViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var cities: [String: String] = [
        "Ciudad de Buenos Aires": "468739",
        "Buenos Aires": "344675",
        "Buenos Aires": "152190",
        "Lajeado Novo": "458847",
        "Morrop": "418679",
        "Trujillo Province": "418680",
        "Morales Izabal Depart": "111234",
        "Escarcega": "113900",
        "San Andres": "81233",
        "Huehuetenango": "812318",
        "Alicante": "370516",
        "Lima": "723503",
        "Panama": "155070",
        "Hermosillo": "113870",
        "Chame": "155074",
        "Guaymas": "113873",
        "Tonosi": "155081",
        "Pedasi": "155080",
        "Muna": "155079",
        "Degollado": "113886",
        "Ameca": "113885",
        "Nurum": "155078",
        "Ojinaga": "113902",
        "Janos": "113901",
        "Cusihuiriachi": "113872",
        "Hidalgo": "113881",
        "Nuevo Laredo": "113874",
        "Mugica": "113889",
        "Tepic": "113883",
        "Motozintla": "113897",
        "Mazatan": "113898",
        "Aguascalientes": "113882",
        "Inde": "113877",
        "Buenos Aires": "426167",
        "Palmares": "808906",
        "Montes de Oca": "723723",
        "Santa Elena": "375949",
        "Naranjal": "371262",
        "Ciudad de Mexico": "160694",
        "Palmares": "57881",
        "Buenos Aires": "57885",
        "Carrillo    Guanacaste Provi": "358408",
        "Campo Alegre de Lourdes": "458846",
        "Distrito Central": "398402",
        "Cali": "351819",
        "Vargas": "381959",
        "Pima": "371432",
        "Maicao": "351822"

    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cities.count
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
