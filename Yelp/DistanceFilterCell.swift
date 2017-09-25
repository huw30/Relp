//
//  CheckmarkFilterCell.swift
//  Yelp
//
//  Created by Raina Wang on 9/23/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
//protocol DistanceFilterCellDelegate {
//    optional func distanceFilterCell(distanceFilterCell: DistanceFilterCell, didSelected
//}

class DistanceFilterCell: UITableViewCell {
    var labelData: String!

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var layerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        UITransform.addBorder(layer: layerView.layer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell() {
        distanceLabel.text = labelData
        self.selectionStyle = .none
    }
}
