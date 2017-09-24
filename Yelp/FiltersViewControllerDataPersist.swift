//
//  FiltersViewControllerDataPersist.swift
//  Yelp
//
//  Created by Raina Wang on 9/24/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation
import UIKit

extension FiltersViewController {
    func getFiltersFromUserDefaults() {
        let defaults = UserDefaults.standard
        if let savedFilters = defaults.value(forKey: "yelpFilters") as? [String: Any] {
            self.offerADealSwitchState = savedFilters["offerADealSwitchState"] as! Bool
            self.selectedDistance = savedFilters["selectedDistance"] as! Int
            self.selectedSortBy = savedFilters["selectedSortBy"] as! Int
        }

        if let data = defaults.object(forKey: "categorySwitchStates") as? NSData {
            self.categorySwitchStates = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [Int : Bool]
        }
    }

    func setFiltersToUserDefaults() {
        let defaults = UserDefaults.standard
        var savedFilters = [String: Any]()

        savedFilters["offerADealSwitchState"] = self.offerADealSwitchState
        savedFilters["selectedDistance"] = self.selectedDistance
        savedFilters["selectedSortBy"] = self.selectedSortBy
        defaults.setValue(savedFilters, forKey: "yelpFilters")
        defaults.setValue(NSKeyedArchiver.archivedData(withRootObject: self.categorySwitchStates), forKey: "categorySwitchStates")
    }
}
