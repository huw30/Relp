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

    var businesses = [Business]()
    var searchTerm: String = "Restaurants"
    var categories: [String]?
    var deals: Bool?
    var sortBy: YelpSortMode?
    var radius: Int?
    var goffset: Int = 0

    var searchActive: Bool = false
    var isMoreDataLoading: Bool = false
    var loadingMoreView: InfiniteScrollActivityView?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        let searchBar = UISearchBar()

        searchBar.placeholder = "Restaurants"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        let leftBarButton = navigationItem.leftBarButtonItem!
        
        if let font = UIFont(name: "Helvetica", size: 16) {
            leftBarButton.setTitleTextAttributes([NSFontAttributeName:font], for: .normal)
        }

        self.addLoadingView()
        self.loadResult(offset: 0)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationNavController = segue.destination as! UINavigationController
        let filtersController = destinationNavController.topViewController as? FiltersViewController
        filtersController?.delegate = self
        
        let mapViewController = destinationNavController.topViewController as? BusinessMapViewController
        mapViewController?.businesses = self.businesses
    }
    
    func loadResult(offset: Int) {

        if offset == 0 {
            self.goffset = 0
            self.businesses.removeAll()
        }

        Business.searchWithTerm(term: searchTerm, sort: sortBy, radius: radius, categories: categories, deals: deals, offset: offset) {
            (businesses: [Business]?, error: Error?) in
            self.businesses = self.businesses + businesses!
            self.isMoreDataLoading = false
            self.tableView.reloadData()
            self.loadingMoreView!.stopAnimating()
            self.goffset += self.businesses.count
        }
    }

    func addLoadingView() {
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
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
        return businesses.count
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
        self.loadResult(offset: 0)
    }
}

extension BusinessesViewController: FiltersViewControllerDelegate {
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : Any]) {
        categories = filters["categories"] as? [String]
        deals = filters["offerADeal"] as? Bool
        sortBy = filters["sortBy"] as? YelpSortMode
        radius = filters["radius"] as? Int

        loadResult(offset: 0)
    }
}

extension BusinessesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height

            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true

                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()

                loadResult(offset: goffset)
            }
        }
    }
}
