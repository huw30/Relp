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
        let filters = self.prepareFilters()

        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: filters)
    }

    let tableStructure: [PrefRowIdentifier] = [.OfferingADeal, .Distance, .SortBy, .Category]
    let categories = Categories.retrieve()
    
    var categorySwitchStates = [Int:Bool]()
    var offerADealSwitchState: Bool = false

    var delegate: FiltersViewControllerDelegate?

    // MOVE TO OTHER PLACES
    let distances: [String] = ["Auto", "0.3 miles", "1 mile", "5 miles", "20 miles"]
    var selectedDistance: Int = 0 //TODO: let this equals to actually selected
    var distanceExpend = false

    let sortBy: [YelpSortMode] = [.bestMatched, .distance, .highestRated]
    var selectedSortBy: Int = 0 //TODO: let this equals to actually selected
    var sortByExpend = false
    // MOVE TO OTHER PLACES

    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        
        return filters
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}



// MARK: Table data source and delegate
extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let prefIdentifier = tableStructure[indexPath.section]

        // Category filters
        if prefIdentifier == PrefRowIdentifier.Category {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryFilterCell") as! CategoryFilterCell
            cell.category = self.categories[indexPath.row]
            cell.categorySwitch.isOn = self.categorySwitchStates[indexPath.row] ?? false
            cell.delegate = self
            cell.setCell()
            return cell
        } else if prefIdentifier == PrefRowIdentifier.OfferingADeal {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OfferDealFilterCell") as! OfferDealFilterCell
            cell.delegate = self
            cell.offerDealSwitch.isOn = self.offerADealSwitchState
            return cell
        } else if prefIdentifier == PrefRowIdentifier.Distance {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceFilterCell") as! DistanceFilterCell
            let distance = self.distances[indexPath.row]

            cell.labelData = distance
            cell.setupCell()

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SortByCell") as! SortByCell
            let sortMode = self.sortBy[indexPath.row]

            cell.sortMode = sortMode
            cell.setupCell()

            return cell

        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableStructure[section] == PrefRowIdentifier.Category {
            return self.categories.count
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
                // expend
                self.distanceExpend = true
            } else{
                self.selectedDistance = indexPath.row
                self.distanceExpend = false
            }
            self.tableView.reloadSections(IndexSet (integer: indexPath.section), with: .automatic)
        }
        if tableStructure[indexPath.section] == PrefRowIdentifier.SortBy {
            if indexPath.row == self.selectedSortBy {
                // expend
                self.sortByExpend = true
            } else{
                self.selectedSortBy = indexPath.row
                self.sortByExpend = false
            }
            self.tableView.reloadSections(IndexSet (integer: indexPath.section), with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableStructure[indexPath.section] == PrefRowIdentifier.Distance {
            if self.distanceExpend == true {
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
            if self.sortByExpend == true {
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
