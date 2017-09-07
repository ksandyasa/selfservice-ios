//
//  PersonalInfoCell.swift
//  Self Service
//
//  Created by Aprido Sandyasa on 1/19/17.
//  Copyright © 2017 PT. Jasa Marga, Tbk. All rights reserved.
//

import UIKit

class PersonalInfoCell: UITableViewCell {

    @IBOutlet weak var ivProfil: UIImageView!
    @IBOutlet weak var lblNamaPersonalInfo: UILabel!
    @IBOutlet weak var lblJabatanPersonalInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
