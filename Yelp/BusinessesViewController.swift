//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var businesses: [Business]!
    var searchTerm: String = "Restaurants"
    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        let searchBar = UISearchBar()
        searchBar.delegate = self
        navigationItem.titleView = searchBar

        self.loadResult()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationNavController = segue.destination as! UINavigationController
        let filtersController = destinationNavController.topViewController as! FiltersViewController

        filtersController.delegate = self
    }
    
    func loadResult() {
        Business.searchWithTerm(term: self.searchTerm, completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            }
        )
    }
}

// MARK: delegates implementation
extension BusinessesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as? BusinessCell else {
            return BusinessCell()
        }

        cell.business = self.businesses[indexPath.row]

        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.businesses != nil {
            return businesses!.count
        } else {
            return 0
        }
    }
}

extension BusinessesViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchTerm = searchText
        self.loadResult()
    }
}

extension BusinessesViewController: FiltersViewControllerDelegate {
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : Any]) {
        let categories = filters["categories"] as? [String]
        let deals = filters["offerADeal"] as? Bool
        let sortBy = filters["sortBy"] as? YelpSortMode
        let radius = filters["radius"] as? Int

        Business.searchWithTerm(term: self.searchTerm, sort: sortBy, radius: radius, categories: categories, deals: deals) {
            (businesses: [Business]?, error: Error?) in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }
}
