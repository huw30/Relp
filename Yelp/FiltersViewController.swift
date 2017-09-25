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
    var categories: [[String: String]]!

    var categorySwitchStates = [Int:Bool]()
    var offerADealSwitchState: Bool = false
    var selectedDistance: Int = 0
    var selectedSortBy: Int = 0

    var delegate: FiltersViewControllerDelegate?

    let distances: [String] = Definition.distances
    let radius: [Double] = Definition.radius
    let sortBy: [YelpSortMode] = [.bestMatched, .distance, .highestRated]
    var distanceExpand = false
    var sortByExpand = false
    var categoryExpand = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.categories = Categories.getFirst4()
        self.getFiltersFromUserDefaults()
        
        let leftBarButton = navigationItem.leftBarButtonItem!
        let rightBarButton = navigationItem.rightBarButtonItem!
        
        if let font = UIFont(name: "Helvetica", size: 16) {
            leftBarButton.setTitleTextAttributes([NSFontAttributeName:font], for: .normal)
            rightBarButton.setTitleTextAttributes([NSFontAttributeName:font], for: .normal)
        }
    }

    func prepareFilters() -> [String: Any] {
        // categories
        var filters = [String: Any]()
        var selectedCategories = [String]()
        for (row, isSelected) in self.categorySwitchStates {
            if isSelected {
                selectedCategories.append(Categories.retrieve()[row]["code"]!)
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
