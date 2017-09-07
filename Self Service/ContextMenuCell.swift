//
//  ContextMenuCell.swift
//  Self Service
//
//  Created by Aprido Sandyasa on 12/31/16.
//  Copyright © 2016 PT. Jasa Marga, Tbk. All rights reserved.
//

import UIKit

class ContextMenuCell: UITableViewCell, YALContextMenuCell {

    @IBOutlet weak var ivContextMenu: UIImageView!
    @IBOutlet weak var lblContextMenu: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func animatedIcon() ->  UIView{
        return self.ivContextMenu;
    }
    
    func animatedContent() ->  UIView{
        return self.lblContextMenu;
    }
    
}
