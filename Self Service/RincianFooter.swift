//
//  RincianFooter.swift
//  Self Service
//
//  Created by Aprido Sandyasa on 1/18/17.
//  Copyright © 2017 PT. Jasa Marga, Tbk. All rights reserved.
//

import UIKit

class RincianFooter: UITableViewCell {

    @IBOutlet weak var lblTotalTitle: UILabel!
    @IBOutlet weak var lblTotalDetail: UILabel!
    @IBOutlet weak var lblTotalGajiTitle: UILabel!
    @IBOutlet weak var lblTotalGajiDetail: UILabel!
    @IBOutlet weak var lblTotalPotonganTitle: UILabel!
    @IBOutlet weak var lblTotalPotonganDetail: UILabel!
    @IBOutlet weak var lblPenerimaanBersihTitle: UILabel!
    @IBOutlet weak var lblPenerimaanBersihDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
