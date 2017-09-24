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
        if prefIdentifier.rawValue == PrefRowIdentifier.Category.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryFilterCell") as! CategoryFilterCell
            cell.category = self.categories[indexPath.row]
            cell.categorySwitch.isOn = self.categorySwitchStates[indexPath.row] ?? false
            cell.delegate = self
            cell.setCell()
            return cell
        } else if prefIdentifier.rawValue == PrefRowIdentifier.OfferingADeal.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OfferDealFilterCell") as! OfferDealFilterCell
            cell.delegate = self
            cell.offerDealSwitch.isOn = self.offerADealSwitchState
            return cell
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableStructure[section].rawValue == PrefRowIdentifier.Category.rawValue {
            return self.categories.count
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
