//
//  Delegates.swift
//  Yelp
//
//  Created by Raina Wang on 9/23/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String: Any])
}

@objc protocol OfferDealFilterCellDelegate {
    @objc optional func offerDealFilterCell(offerDealFilterCell: OfferDealFilterCell, didChangeValue value: Bool)
}

@objc protocol CategoryFilterCellDelegate {
    @objc optional func categoryFilterCell(categoryFilterCell: CategoryFilterCell, didChangeValue value: Bool)
}
