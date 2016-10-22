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

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

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
            return businesses!.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as? BusinessCell

        cell?.business = businesses?[indexPath.row]

        return cell!
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
        
        Business.searchWithTerm(term: "Restaurant", sort: nil, categories: categories, deals: nil, completion: {
            (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        })
    }

}
