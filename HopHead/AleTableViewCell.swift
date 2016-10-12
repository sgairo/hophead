//
//  AleTableViewCell.swift
//  HopHead
//
//  Created by Sophie Gairo on 10/11/16.
//  Copyright © 2016 Sophie Gairo. All rights reserved.
//

import UIKit

class AleTableViewCell: UITableViewCell {
    
    //MARK:Property
    
    @IBOutlet weak var color_lbl: UILabel!
    
    @IBOutlet weak var beerName_lbl: UILabel!
    
    
    @IBOutlet weak var abv_lbl: UILabel!
    
    @IBOutlet weak var ibu_lbl: UILabel!
    
    
    @IBOutlet weak var abvValue_lbl: UILabel!
    
    @IBOutlet weak var ibuValue_lbl: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
