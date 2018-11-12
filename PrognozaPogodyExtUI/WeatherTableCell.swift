//
//  WeatherCell.swift
//  PrognozaPogodyExtUI
//
//  Created by IHaveAMacNow on 11/11/2018.
//  Copyright © 2018 MPiotrowski. All rights reserved.
//

import UIKit

class WeatherTableCell: UITableViewCell {

    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var cityName: UILabel!
    
    @IBOutlet weak var temperature: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
