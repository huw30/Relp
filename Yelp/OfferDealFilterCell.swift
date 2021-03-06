//
//  OfferDealFilterCell.swift
//  Yelp
//
//  Created by Raina Wang on 9/23/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class OfferDealFilterCell: UITableViewCell {
    @IBOutlet weak var offerDealSwitch: UISwitch!
    @IBOutlet weak var layerView: UIView!
    weak var delegate: OfferDealFilterCellDelegate?

    @IBAction func switchValueChanged(_ sender: Any) {
        delegate?.offerDealFilterCell?(offerDealFilterCell: self, didChangeValue: offerDealSwitch.isOn)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        UITransform.addBorder(layer: layerView.layer)
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
