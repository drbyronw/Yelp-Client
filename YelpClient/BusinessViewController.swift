//
//  BusinessViewController.swift
//  YelpClient
//
//  Created by Byron J. Williams on 10/19/16.
//  Copyright © 2016 Byron J. Williams. All rights reserved.
//

import UIKit

class BusinessViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FiltersViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!

    var businesses: [Business]?
    var filteredBusinesses: [Business]?
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // tableView initialization
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        // search bar intialization
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        searchController.dimsBackgroundDuringPresentation = false // prevent dimming while searching
        searchController.searchBar.sizeToFit()
        navigationItem.titleView = searchController.searchBar // add search bar to nav title area
        
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
        
        // By default the navigation bar hides when presenting the
        // search interface.  Obviously we don't want this to happen if
        // our search bar is inside the navigation bar.
        searchController.hidesNavigationBarDuringPresentation = false
        
        Business.searchWithTerm(term: "Seafood", completion: { (businesses: [Business]?, error: Error?) -> Void in

            if businesses != nil {
                self.businesses = businesses!
            } else {
                print("busineses empty = propblem with initial search \n\n ==============================")
            }
            
            self.tableView.reloadData()
            
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }

        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            if searchController.isActive && searchController.searchBar.text != "" {
                return filteredBusinesses!.count
            } else {
                return businesses!.count
            }
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as? BusinessCell

        if searchController.isActive && searchController.searchBar.text != "" {
            cell?.business = filteredBusinesses?[indexPath.row]
        } else {
            cell?.business = businesses?[indexPath.row]
        }
        
        return cell!
    }
    
       
    // MARK: Perform Search
    func filterContent(with searchText: String) {
        var searchCheck = ""
        filteredBusinesses = businesses!.filter {business in
            searchCheck = business.name!
            if searchCheck.lowercased().contains(searchText.lowercased()) {
                print("Search Match: \(searchCheck)")
                return true
            } else {
                return false
            }
        }
        
        tableView.reloadData()
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        filtersViewController.delegate = self
        
    }

    func filtersViewController(_ filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        
        let categories = filters["categories"] as? [String]
        let deals = filters["deals"] as? Bool
        let sortedBy = filters["sortedBy"] as? Int
        let sortMode = YelpSortMode(rawValue: sortedBy!)
        print("Categories \(categories)-------------")
        print("Deals: \(deals) ------------------------")
        print("SortedBy Int: \(sortedBy) ------------------------")
        
        Business.searchWithTerm(term: "Restaurant", sort: sortMode, categories: categories, deals: deals, completion: {
            (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        })
    }
}

extension BusinessViewController: UISearchResultsUpdating {
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        filterContent(with: searchController.searchBar.text!)
    }
}
