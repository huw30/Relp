//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Raina Wang on 9/23/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func onSearch(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.setFiltersToUserDefaults()

        let filters = self.prepareFilters()

        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: filters)
    }


    let tableStructure: [PrefRowIdentifier] = [.OfferingADeal, .Distance, .SortBy, .Category]
    let categories = Categories.retrieve()

    var categorySwitchStates = [Int:Bool]()
    var offerADealSwitchState: Bool = false
    var selectedDistance: Int = 0
    var selectedSortBy: Int = 0

    var delegate: FiltersViewControllerDelegate?

    let distances: [String] = Definition.distances
    let radius: [Double] = Definition.radius
    let sortBy: [YelpSortMode] = [.bestMatched, .distance, .highestRated]
    var distanceExpend = false
    var sortByExpend = false
    var categoryExpend = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getFiltersFromUserDefaults()
    }

    func prepareFilters() -> [String: Any] {
        // categories
        var filters = [String: Any]()
        var selectedCategories = [String]()
        for (row, isSelected) in self.categorySwitchStates {
            if isSelected {
                selectedCategories.append(self.categories[row]["code"]!)
            }
        }

        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories
        }
        
        // offer a deal
        
        filters["offerADeal"] = self.offerADealSwitchState
        filters["sortBy"] = self.sortBy[selectedSortBy]

        let radius = Int(Double(self.radius[selectedDistance] * 1609.34).rounded())

        if radius > 0 {
            filters["radius"] = radius
        }

        return filters
    }
}



// MARK: Table data source and delegate
extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let prefIdentifier = tableStructure[indexPath.section]

        switch prefIdentifier {
        case PrefRowIdentifier.Category:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryFilterCell") as! CategoryFilterCell

            //TODO: BUILD A CUSTOM SHOWMORE/LESS CELL
            // show more
            if indexPath.row == 3 && !categoryExpend{
                cell.showAsShowMore()
                return cell
            } else if indexPath.row == self.categories.count {
                cell.showAsShowLess()
                return cell
            }

            cell.category = self.categories[indexPath.row]
            cell.categorySwitch.isOn = self.categorySwitchStates[indexPath.row] ?? false
            cell.delegate = self
            cell.setCell()
            return cell
        case PrefRowIdentifier.OfferingADeal:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OfferDealFilterCell") as! OfferDealFilterCell
            cell.delegate = self
            cell.offerDealSwitch.isOn = self.offerADealSwitchState
            return cell
        case PrefRowIdentifier.Distance:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceFilterCell") as! DistanceFilterCell
            let distance = self.distances[indexPath.row]
            cell.labelData = distance
            cell.setupCell()
            return cell
        case PrefRowIdentifier.SortBy:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SortByCell") as! SortByCell
            let sortMode = self.sortBy[indexPath.row]
            cell.sortMode = sortMode
            cell.setupCell()
            return cell
        }

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableStructure[section] == PrefRowIdentifier.Category {
            if self.categoryExpend {
                return self.categories.count + 1
            } else {
                return 4
            }
        } else if tableStructure[section] == PrefRowIdentifier.Distance {
            return self.distances.count
        } else if tableStructure[section] == PrefRowIdentifier.SortBy {
            return self.sortBy.count
        } else {
            return 1
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return tableStructure.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableStructure[section].rawValue
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableStructure[indexPath.section] == PrefRowIdentifier.Distance {
            if indexPath.row == self.selectedDistance {
                self.distanceExpend = true
            } else{
                self.selectedDistance = indexPath.row
                self.distanceExpend = false
            }
            self.tableView.reloadSections(IndexSet (integer: indexPath.section), with: .automatic)
        }
        if tableStructure[indexPath.section] == PrefRowIdentifier.SortBy {
            if indexPath.row == self.selectedSortBy {
                self.sortByExpend = true
            } else{
                self.selectedSortBy = indexPath.row
                self.sortByExpend = false
            }
            self.tableView.reloadSections(IndexSet (integer: indexPath.section), with: .automatic)
        }
        if tableStructure[indexPath.section] == PrefRowIdentifier.Category {
            if indexPath.row == 3 && !self.categoryExpend {
                self.categoryExpend = true
            } else if indexPath.row == self.categories.count && self.categoryExpend {
                self.categoryExpend = false
            }

            self.tableView.reloadSections(IndexSet (integer: indexPath.section), with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableStructure[indexPath.section] == PrefRowIdentifier.Distance {
            if self.distanceExpend {
                return 45
            } else {
                if indexPath.row == selectedDistance {
                    return 45
                } else {
                    return 0
                }
            }
        }
        if tableStructure[indexPath.section] == PrefRowIdentifier.SortBy {
            if self.sortByExpend {
                return 45
            } else {
                if indexPath.row == selectedSortBy {
                    return 45
                } else {
                    return 0
                }
            }
        }
        return 45
    }
}

// MARK: CategoryFilterCellDelegate implementation
extension FiltersViewController: CategoryFilterCellDelegate {
    func categoryFilterCell(categoryFilterCell: CategoryFilterCell, didChangeValue value: Bool) {
        let indexPath = self.tableView.indexPath(for: categoryFilterCell)!
        self.categorySwitchStates[indexPath.row] = value
    }
}

// MARK: OfferDealFilterCellDelegate implementation
extension FiltersViewController: OfferDealFilterCellDelegate {
    func offerDealFilterCell(offerDealFilterCell: OfferDealFilterCell, didChangeValue value: Bool) {
        self.offerADealSwitchState = value
    }
}

// Mark: data persist
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
