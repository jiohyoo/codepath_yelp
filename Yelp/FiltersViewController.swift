//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Ji Oh Yoo on 2/13/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: SearchSettings)
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate {
    @IBOutlet weak var tableView: UITableView!

    var switchStates = [Int: [Int: Bool]]()
    var searchSettings: SearchSettings! {
        didSet {
            switchStates[0] = [Int: Bool]()
            for i in 0..<SearchSettings.SORT.count {
                self.switchStates[0]![i] = (self.searchSettings.sort == SearchSettings.SORT[i].1)
            }
            
            switchStates[1] = [Int: Bool]()
            for i in 0..<SearchSettings.DISTANCES.count {
                self.switchStates[1]![i] = (self.searchSettings.distance == SearchSettings.DISTANCES[i].1)
            }

            switchStates[2] = [Int: Bool]()
            switchStates[2]![0] = searchSettings.deals

            switchStates[3] = [Int: Bool]()
            for i in 0..<SearchSettings.CATEGORIES.count {
                self.switchStates[3]![i] = self.searchSettings.categories.contains(SearchSettings.CATEGORIES[i]["code"]!)
            }            
        }
    }
    
    weak var delegate: FiltersViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self        
        // Do any additional setup after loading the view.
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSearchButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)

        if switchStates[0] != nil {
            for i in 0..<self.switchStates[0]!.count {
                if self.switchStates[0]![i] == true {
                    self.searchSettings.sort = SearchSettings.SORT[i].1
                    break
                }
            }
        } else {
            self.searchSettings.sort = YelpSortMode.BestMatched
        }

        if switchStates[1] != nil {
            for i in 0..<self.switchStates[1]!.count {
                if self.switchStates[1]![i] == true {
                    self.searchSettings.distance = SearchSettings.DISTANCES[i].1
                    break
                }
            }
        } else {
            self.searchSettings.distance = nil
        }
        
        self.searchSettings.deals = switchStates[2]?[0] ?? false
        
        self.searchSettings.categories = []
        if switchStates[3] != nil {
            for i in 0..<self.switchStates[3]!.count {
                if self.switchStates[3]![i] == true {
                    self.searchSettings.categories.append(SearchSettings.CATEGORIES[i]["code"]!)
                }
            }
        }
        
        delegate?.filtersViewController!(self, didUpdateFilters: self.searchSettings)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    var TABLE_STRUCTURE : [(String, Bool, [String])] = [
        ("Sort", false,[
            "Best Match",
            "Distance",
            "Rating"
        ]),
        ("Distance", false, [
            "Best Match",
            "1 mile",
            "2 miles",
            "5 miles",
            "10 miles",
            "25 miles",
        ]),
        ("Deals", true, [
            "Deals",
        ]),
        ("Categories", true,[
            "American, Traditional",
            "Cafes",
            "Chicken Wings",
            "Chinese",
            "French",
            "Italian",
            "Japanese",
            "Korean",
            "Pizza",
        ]),
    ]
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return TABLE_STRUCTURE.count
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return TABLE_STRUCTURE[section].0
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TABLE_STRUCTURE[section].2.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
        cell.switchLabel.text = TABLE_STRUCTURE[indexPath.section].2[indexPath.row]
        cell.delegate = self
        cell.onSwitch.on = switchStates[indexPath.section]?[indexPath.row] ?? false
        return cell
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = self.tableView.indexPathForCell(switchCell)!
        let section = indexPath.section
        let row = indexPath.row
        
        if switchStates[section] == nil {
            switchStates[section] = [Int:Bool]()
        }

        // change on forms if non-multiple selection
        if TABLE_STRUCTURE[section].1 == false {
            if value == true {
                for i in 0..<TABLE_STRUCTURE[section].2.count {
                    if i == row {
                        switchStates[section]![i] = true
                    } else {
                        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: section)) as! SwitchCell
                        cell.onSwitch.on = false
                        switchStates[section]![i] = false
                    }
                }
            } else {
                let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: section)) as! SwitchCell
                cell.onSwitch.on = true
                switchStates[section]![0] = true
            }
        } else {
            switchStates[section]![row] = value
        }
    }
}
