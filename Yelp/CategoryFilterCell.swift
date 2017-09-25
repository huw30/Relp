//
//  FilterCell.swift
//  Yelp
//
//  Created by Raina Wang on 9/22/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class CategoryFilterCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categorySwitch: UISwitch!
    @IBOutlet weak var layerView: UIView!

    weak var delegate: CategoryFilterCellDelegate?
    var category: [String: String]!

    @IBAction func switchValueChanged(_ sender: Any) {
        delegate?.categoryFilterCell?(categoryFilterCell: self, didChangeValue: categorySwitch.isOn)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        UITransform.addBorder(layer: layerView.layer)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell() {
        categoryLabel.text = category["name"]
        self.selectionStyle = .none
    }
}
