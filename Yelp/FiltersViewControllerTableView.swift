//
//  FiltersViewControllerTableView.swift
//  Yelp
//
//  Created by Raina Wang on 9/24/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation
import UIKit

// MARK: Table data source and delegate
extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let prefIdentifier = tableStructure[indexPath.section]

        switch prefIdentifier {
        case PrefRowIdentifier.Category:
            // show more/show less row
            if indexPath.row == self.categories.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ToggleCategoryCell") as! ToggleCategoryCell
                cell.togLabel.text = self.categoryExpand ? "Show Less" : "See All"
                UITransform.addBorder(layer: cell.layer)

                return cell
            }

            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryFilterCell") as! CategoryFilterCell
            cell.category = self.categories[indexPath.row]
            cell.categorySwitch.isOn = self.categorySwitchStates[indexPath.row] ?? false
            cell.delegate = self
            cell.setCell()
            UITransform.addBorder(layer: cell.layer)
            return cell
        case PrefRowIdentifier.OfferingADeal:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OfferDealFilterCell") as! OfferDealFilterCell
            cell.delegate = self
            cell.offerDealSwitch.isOn = self.offerADealSwitchState
            UITransform.addBorder(layer: cell.layer)

            return cell
        case PrefRowIdentifier.Distance:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceFilterCell") as! DistanceFilterCell
            let distance = self.distances[indexPath.row]
            cell.labelData = distance
            cell.setupCell()
            UITransform.addBorder(layer: cell.layer)
            return cell
        case PrefRowIdentifier.SortBy:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SortByCell") as! SortByCell
            let sortMode = self.sortBy[indexPath.row]
            cell.sortMode = sortMode
            cell.setupCell()
            UITransform.addBorder(layer: cell.layer)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableStructure[section] {
        case PrefRowIdentifier.Category:
            return self.categories.count + 1
        case PrefRowIdentifier.Distance:
            return self.distances.count
        case PrefRowIdentifier.SortBy:
            return self.sortBy.count
        default:
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
                self.distanceExpand = true
            } else{
                self.selectedDistance = indexPath.row
                self.distanceExpand = false
            }
        }

        if tableStructure[indexPath.section] == PrefRowIdentifier.SortBy {
            if indexPath.row == self.selectedSortBy {
                self.sortByExpand = true
            } else{
                self.selectedSortBy = indexPath.row
                self.sortByExpand = false
            }
        }

        if tableStructure[indexPath.section] == PrefRowIdentifier.Category {
            let cell = tableView.cellForRow(at: indexPath)
            if cell is ToggleCategoryCell {
                if self.categoryExpand {
                    self.categories = Categories.getFirst4()
                } else {
                    self.categories = Categories.retrieve()
                }
                self.categoryExpand = !self.categoryExpand
            }
        }
        self.tableView.reloadSections(IndexSet (integer: indexPath.section), with: .automatic)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableStructure[indexPath.section] == PrefRowIdentifier.Distance {
            if self.distanceExpand {
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
            if self.sortByExpand {
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

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Helvetica", size: 15)!
        header.backgroundView?.backgroundColor = UIColor.white
    }
}
