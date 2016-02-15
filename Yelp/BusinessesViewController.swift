//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MBProgressHUD
import MapKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, FiltersViewControllerDelegate {

    var searchBar: UISearchBar!
    var searchSettings = SearchSettings()
    var businesses: [Business]!
    var isViewModeList: Bool = true
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var viewModeButton: UIBarButtonItem!
    
    @IBAction func onviewModeButtonClick(sender: UIBarButtonItem) {
        if self.isViewModeList {
            self.isViewModeList = false
            self.viewModeButton.title = "List"
            self.tableView.hidden = true
            self.mapView.hidden = false
        } else {
            self.isViewModeList = true
            self.viewModeButton.title = "Map"
            self.tableView.hidden = false
            self.mapView.hidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        

        mapView.delegate = self
        mapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.785771, -122.406165), MKCoordinateSpanMake(0.1, 0.1)), animated: false)

        searchBar = UISearchBar()
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar

        doSearch()
    }
    
    // Perform the search and populate the table
    private func doSearch() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        Business.searchWithTerm(
            searchSettings,
            completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            self.mapView.removeAnnotations(self.mapView.annotations)
                
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
                print(business.latitude!)
                print(business.longitude!)
                self.addPin(business)
            }
        })
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let businesses = self.businesses {
            return businesses.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusineessCell
        cell.business = self.businesses[indexPath.row]
        return cell
    }


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        filtersViewController.delegate = self
        filtersViewController.searchSettings = self.searchSettings
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters searchSettings: SearchSettings) {
        doSearch()
    }
    
    func addPin(business: Business) {
        let annotation = YelpPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(business.latitude!, business.longitude!)
        annotation.title = business.name
        annotation.imageUrl = business.imageURL
        mapView.addAnnotation(annotation)
    }
}



class YelpPointAnnotation: MKPointAnnotation {
    var imageUrl: NSURL?
}



// SearchBar methods
extension BusinessesViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchSettings.term = searchBar.text
        searchBar.resignFirstResponder()
        doSearch()
    }
}