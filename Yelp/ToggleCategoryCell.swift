//
//  toggleCategoryCell.swift
//  Yelp
//
//  Created by Raina Wang on 9/24/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class ToggleCategoryCell: UITableViewCell {
    @IBOutlet weak var togLabel: UILabel!
    @IBOutlet weak var layerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        UITransform.addBorder(layer: layerView.layer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
