//
//  SortByCell.swift
//  Yelp
//
//  Created by Raina Wang on 9/23/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class SortByCell: UITableViewCell {
    @IBOutlet weak var sortByLabel: UILabel!

    var sortMode: YelpSortMode = YelpSortMode.bestMatched

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setupCell() {
        switch sortMode {
        case YelpSortMode.bestMatched:
            sortByLabel.text = "Best Matched"
        case YelpSortMode.distance:
            sortByLabel.text = "Distance"
        case YelpSortMode.highestRated:
            sortByLabel.text = "Highest Rated"
        }
    }

}
