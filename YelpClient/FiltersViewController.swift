//
//  FiltersViewController.swift
//  YelpClient
//
//  Created by Byron J. Williams on 10/21/16.
//  Copyright © 2016 Byron J. Williams. All rights reserved.
//

import UIKit

enum YelpSections: Int {
    case deals
    case distance
    case sortBy
    case categories
}

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(_ filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate?
    var switchStates = [Int:Bool]()
    var dealsSelected = false
    var sortBySelection = "Best Match"
    var distanceSelection = "1 mile"
    
//    let tableStructure:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSearchButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        
        var filters = [String:AnyObject]()
        
        var selectedCategories = [String]()
        for (row, isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(Filters.categories[row]["code"]!)
                print("Appending: \(Filters.categories[row]["code"]!)")
            }
        }
        
        if selectedCategories.count > 0 {
            print("# of Selected Categories: \(selectedCategories.count)")
            filters["categories"] = selectedCategories as AnyObject?
        }
        
        if dealsSelected {
            filters["deals"] = true as AnyObject?
            print ("Deals Selected: \(filters["deals"] as! Bool)")
        }
        
        for (index, distanceText) in Filters.distanceName.enumerated() {
            if distanceText == distanceSelection {
                filters["distanceInMiles"] = Filters.distanceValue[index] as AnyObject
            }
        }
        for (index, sortedByText) in Filters.sortBy.enumerated() {
            if sortedByText == sortBySelection {
                filters["sortedBy"] = Filters.sortByValue[index] as AnyObject
            }
        }
        
        
        delegate?.filtersViewController!(self, didUpdateFilters: filters)

    }
    
    @IBAction func onCancelButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
   
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == YelpSections.deals.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            cell.filterLabel?.text = "Offering a Deal"
            cell.delegate = self
            
            cell.onSwitch.isOn = switchStates[indexPath.section] ?? false
            
            return cell
            
        } else if indexPath.section == YelpSections.distance.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionCell", for: indexPath)
            cell.textLabel?.text = Filters.distanceName[indexPath.row]
            
            if cell.textLabel?.text == distanceSelection {
                cell.accessoryType = .checkmark
            }
            
            return cell
            
        } else if indexPath.section == YelpSections.sortBy.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionCell", for: indexPath)
            cell.textLabel?.text = Filters.sortBy[indexPath.row]
            
            if cell.textLabel?.text == sortBySelection {
                cell.accessoryType = .checkmark
            }

            
            return cell
            
        } else if indexPath.section == YelpSections.categories.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            cell.filterLabel?.text = Filters.categories[indexPath.row]["name"]
            cell.delegate = self
            
            cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
            
            return cell

        } else {
            return UITableViewCell()
        }

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == YelpSections.deals.rawValue {
            return ""
        } else if section == YelpSections.distance.rawValue {
            return "Distance"
        } else if section == YelpSections.sortBy.rawValue {
            return "Sort By"
        } else if section == YelpSections.categories.rawValue {
            return "Category"
        } else {
            return ""
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == YelpSections.deals.rawValue {
            return 1 // just one option
        } else if section == YelpSections.distance.rawValue {
            return Filters.distanceName.count
        } else if section == YelpSections.sortBy.rawValue {
            return Filters.sortBy.count
        } else if section == YelpSections.categories.rawValue {
            return Filters.categories.count
        } else {
            return 0
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if indexPath.section == 1 {
            
            cell?.accessoryType = .checkmark
            print(cell?.textLabel?.text)
            distanceSelection = (cell?.textLabel?.text)!
            //tableView.deselectRow(at: indexPath, animated: false)
            
        } else if indexPath.section == 2 {
            
            cell?.accessoryType = .checkmark
            print(cell?.textLabel?.text)
            sortBySelection = (cell?.textLabel?.text)!
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)

        if indexPath.section == 1 {
            
            cell?.accessoryType = .none
        } else if indexPath.section == 2 {
            
            cell?.accessoryType = .none
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func switchCell(_ switchCell: SwitchCell, didChangeValue value: Bool) {
        let section = tableView.indexPath(for: switchCell)?.section
        let indexPath = tableView.indexPath(for: switchCell)
        print("SwitchCell IndexPath \(indexPath?.row) and Section: \(section)")
        if section == 0 {
            dealsSelected = value
        } else {
            
            switchStates[(indexPath?.row)!] = value
            
            print("switchStates[\((indexPath?.row)!)] = \(value) -----------")
        }
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    struct Filters {
        static let sortBy = ["Best Match", "Distance", "Highest Rated"]
        static let sortByValue = [0, 1, 2]
        static let distanceValue = [0.3, 1.0, 5.0, 20.0]
        static let distanceName = ["0.3 miles", "1 mile", "5 miles", "20 miles"]
        static var deals = true
        static let categories: [[String:String]] = [["name" : "Afghan", "code": "afghani"],
                                                    ["name" : "African", "code": "african"],
                                                    ["name" : "American, New", "code": "newamerican"],
                                                    ["name" : "American, Traditional", "code": "tradamerican"],
                                                    ["name" : "Arabian", "code": "arabian"],
                                                    ["name" : "Argentine", "code": "argentine"],
                                                    ["name" : "Armenian", "code": "armenian"],
                                                    ["name" : "Asian Fusion", "code": "asianfusion"],
                                                    ["name" : "Asturian", "code": "asturian"],
                                                    ["name" : "Australian", "code": "australian"],
                                                    ["name" : "Austrian", "code": "austrian"],
                                                    ["name" : "Baguettes", "code": "baguettes"],
                                                    ["name" : "Bangladeshi", "code": "bangladeshi"],
                                                    ["name" : "Barbeque", "code": "bbq"],
                                                    ["name" : "Basque", "code": "basque"],
                                                    ["name" : "Bavarian", "code": "bavarian"],
                                                    ["name" : "Beer Garden", "code": "beergarden"],
                                                    ["name" : "Beer Hall", "code": "beerhall"],
                                                    ["name" : "Beisl", "code": "beisl"],
                                                    ["name" : "Belgian", "code": "belgian"],
                                                    ["name" : "Bistros", "code": "bistros"],
                                                    ["name" : "Black Sea", "code": "blacksea"],
                                                    ["name" : "Brasseries", "code": "brasseries"],
                                                    ["name" : "Brazilian", "code": "brazilian"],
                                                    ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
                                                    ["name" : "British", "code": "british"],
                                                    ["name" : "Buffets", "code": "buffets"],
                                                    ["name" : "Bulgarian", "code": "bulgarian"],
                                                    ["name" : "Burgers", "code": "burgers"],
                                                    ["name" : "Burmese", "code": "burmese"],
                                                    ["name" : "Cafes", "code": "cafes"],
                                                    ["name" : "Cafeteria", "code": "cafeteria"],
                                                    ["name" : "Cajun/Creole", "code": "cajun"],
                                                    ["name" : "Cambodian", "code": "cambodian"],
                                                    ["name" : "Canadian", "code": "New)"],
                                                    ["name" : "Canteen", "code": "canteen"],
                                                    ["name" : "Caribbean", "code": "caribbean"],
                                                    ["name" : "Catalan", "code": "catalan"],
                                                    ["name" : "Chech", "code": "chech"],
                                                    ["name" : "Cheesesteaks", "code": "cheesesteaks"],
                                                    ["name" : "Chicken Shop", "code": "chickenshop"],
                                                    ["name" : "Chicken Wings", "code": "chicken_wings"],
                                                    ["name" : "Chilean", "code": "chilean"],
                                                    ["name" : "Chinese", "code": "chinese"],
                                                    ["name" : "Comfort Food", "code": "comfortfood"],
                                                    ["name" : "Corsican", "code": "corsican"],
                                                    ["name" : "Creperies", "code": "creperies"],
                                                    ["name" : "Cuban", "code": "cuban"],
                                                    ["name" : "Curry Sausage", "code": "currysausage"],
                                                    ["name" : "Cypriot", "code": "cypriot"],
                                                    ["name" : "Czech", "code": "czech"],
                                                    ["name" : "Czech/Slovakian", "code": "czechslovakian"],
                                                    ["name" : "Danish", "code": "danish"],
                                                    ["name" : "Delis", "code": "delis"],
                                                    ["name" : "Diners", "code": "diners"],
                                                    ["name" : "Dumplings", "code": "dumplings"],
                                                    ["name" : "Eastern European", "code": "eastern_european"],
                                                    ["name" : "Ethiopian", "code": "ethiopian"],
                                                    ["name" : "Fast Food", "code": "hotdogs"],
                                                    ["name" : "Filipino", "code": "filipino"],
                                                    ["name" : "Fish & Chips", "code": "fishnchips"],
                                                    ["name" : "Fondue", "code": "fondue"],
                                                    ["name" : "Food Court", "code": "food_court"],
                                                    ["name" : "Food Stands", "code": "foodstands"],
                                                    ["name" : "French", "code": "french"],
                                                    ["name" : "French Southwest", "code": "sud_ouest"],
                                                    ["name" : "Galician", "code": "galician"],
                                                    ["name" : "Gastropubs", "code": "gastropubs"],
                                                    ["name" : "Georgian", "code": "georgian"],
                                                    ["name" : "German", "code": "german"],
                                                    ["name" : "Giblets", "code": "giblets"],
                                                    ["name" : "Gluten-Free", "code": "gluten_free"],
                                                    ["name" : "Greek", "code": "greek"],
                                                    ["name" : "Halal", "code": "halal"],
                                                    ["name" : "Hawaiian", "code": "hawaiian"],
                                                    ["name" : "Heuriger", "code": "heuriger"],
                                                    ["name" : "Himalayan/Nepalese", "code": "himalayan"],
                                                    ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
                                                    ["name" : "Hot Dogs", "code": "hotdog"],
                                                    ["name" : "Hot Pot", "code": "hotpot"],
                                                    ["name" : "Hungarian", "code": "hungarian"],
                                                    ["name" : "Iberian", "code": "iberian"],
                                                    ["name" : "Indian", "code": "indpak"],
                                                    ["name" : "Indonesian", "code": "indonesian"],
                                                    ["name" : "International", "code": "international"],
                                                    ["name" : "Irish", "code": "irish"],
                                                    ["name" : "Island Pub", "code": "island_pub"],
                                                    ["name" : "Israeli", "code": "israeli"],
                                                    ["name" : "Italian", "code": "italian"],
                                                    ["name" : "Japanese", "code": "japanese"],
                                                    ["name" : "Jewish", "code": "jewish"],
                                                    ["name" : "Kebab", "code": "kebab"],
                                                    ["name" : "Korean", "code": "korean"],
                                                    ["name" : "Kosher", "code": "kosher"],
                                                    ["name" : "Kurdish", "code": "kurdish"],
                                                    ["name" : "Laos", "code": "laos"],
                                                    ["name" : "Laotian", "code": "laotian"],
                                                    ["name" : "Latin American", "code": "latin"],
                                                    ["name" : "Live/Raw Food", "code": "raw_food"],
                                                    ["name" : "Lyonnais", "code": "lyonnais"],
                                                    ["name" : "Malaysian", "code": "malaysian"],
                                                    ["name" : "Meatballs", "code": "meatballs"],
                                                    ["name" : "Mediterranean", "code": "mediterranean"],
                                                    ["name" : "Mexican", "code": "mexican"],
                                                    ["name" : "Middle Eastern", "code": "mideastern"],
                                                    ["name" : "Milk Bars", "code": "milkbars"],
                                                    ["name" : "Modern Australian", "code": "modern_australian"],
                                                    ["name" : "Modern European", "code": "modern_european"],
                                                    ["name" : "Mongolian", "code": "mongolian"],
                                                    ["name" : "Moroccan", "code": "moroccan"],
                                                    ["name" : "New Zealand", "code": "newzealand"],
                                                    ["name" : "Night Food", "code": "nightfood"],
                                                    ["name" : "Norcinerie", "code": "norcinerie"],
                                                    ["name" : "Open Sandwiches", "code": "opensandwiches"],
                                                    ["name" : "Oriental", "code": "oriental"],
                                                    ["name" : "Pakistani", "code": "pakistani"],
                                                    ["name" : "Parent Cafes", "code": "eltern_cafes"],
                                                    ["name" : "Parma", "code": "parma"],
                                                    ["name" : "Persian/Iranian", "code": "persian"],
                                                    ["name" : "Peruvian", "code": "peruvian"],
                                                    ["name" : "Pita", "code": "pita"],
                                                    ["name" : "Pizza", "code": "pizza"],
                                                    ["name" : "Polish", "code": "polish"],
                                                    ["name" : "Portuguese", "code": "portuguese"],
                                                    ["name" : "Potatoes", "code": "potatoes"],
                                                    ["name" : "Poutineries", "code": "poutineries"],
                                                    ["name" : "Pub Food", "code": "pubfood"],
                                                    ["name" : "Rice", "code": "riceshop"],
                                                    ["name" : "Romanian", "code": "romanian"],
                                                    ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
                                                    ["name" : "Rumanian", "code": "rumanian"],
                                                    ["name" : "Russian", "code": "russian"],
                                                    ["name" : "Salad", "code": "salad"],
                                                    ["name" : "Sandwiches", "code": "sandwiches"],
                                                    ["name" : "Scandinavian", "code": "scandinavian"],
                                                    ["name" : "Scottish", "code": "scottish"],
                                                    ["name" : "Seafood", "code": "seafood"],
                                                    ["name" : "Serbo Croatian", "code": "serbocroatian"],
                                                    ["name" : "Signature Cuisine", "code": "signature_cuisine"],
                                                    ["name" : "Singaporean", "code": "singaporean"],
                                                    ["name" : "Slovakian", "code": "slovakian"],
                                                    ["name" : "Soul Food", "code": "soulfood"],
                                                    ["name" : "Soup", "code": "soup"],
                                                    ["name" : "Southern", "code": "southern"],
                                                    ["name" : "Spanish", "code": "spanish"],
                                                    ["name" : "Steakhouses", "code": "steak"],
                                                    ["name" : "Sushi Bars", "code": "sushi"],
                                                    ["name" : "Swabian", "code": "swabian"],
                                                    ["name" : "Swedish", "code": "swedish"],
                                                    ["name" : "Swiss Food", "code": "swissfood"],
                                                    ["name" : "Tabernas", "code": "tabernas"],
                                                    ["name" : "Taiwanese", "code": "taiwanese"],
                                                    ["name" : "Tapas Bars", "code": "tapas"],
                                                    ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
                                                    ["name" : "Tex-Mex", "code": "tex-mex"],
                                                    ["name" : "Thai", "code": "thai"],
                                                    ["name" : "Traditional Norwegian", "code": "norwegian"],
                                                    ["name" : "Traditional Swedish", "code": "traditional_swedish"],
                                                    ["name" : "Trattorie", "code": "trattorie"],
                                                    ["name" : "Turkish", "code": "turkish"],
                                                    ["name" : "Ukrainian", "code": "ukrainian"],
                                                    ["name" : "Uzbek", "code": "uzbek"],
                                                    ["name" : "Vegan", "code": "vegan"],
                                                    ["name" : "Vegetarian", "code": "vegetarian"],
                                                    ["name" : "Venison", "code": "venison"],
                                                    ["name" : "Vietnamese", "code": "vietnamese"],
                                                    ["name" : "Wok", "code": "wok"],
                                                    ["name" : "Wraps", "code": "wraps"],
                                                    ["name" : "Yugoslav", "code": "yugoslav"]]
        
    }
    
    
}
