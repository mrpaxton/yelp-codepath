//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate {
    
    
    @IBOutlet weak var bizSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var searchButtonItem: UIBarButtonItem!

    var businesses: [Business]!
    var filteredBusinesses: [Business]!
    
    //flag for infinite scroll
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    var selectedCategories: [String]?
    
    var loadMoreOffset = 0
    
    func didTapSearchButton(sender: AnyObject?) {
        showSearchBar()
    }
    
    func showSearchBar() {
        //show search bar
        bizSearchBar.hidden = true
        bizSearchBar.alpha = 0.3
        navigationItem.titleView = bizSearchBar
        navigationItem.setRightBarButtonItem(nil , animated: true)
        UIView.animateWithDuration(0.2,
            animations: { Void in
                self.bizSearchBar.hidden = false
                self.bizSearchBar.alpha = 1
            }, completion: { finished in
                self.bizSearchBar.setShowsCancelButton(true, animated: false)
                self.bizSearchBar.becomeFirstResponder()
            }
        )
    }
    
    func didTapFilterButton(sender: AnyObject?) {
        performSegueWithIdentifier("FilterSegue", sender: self)
    }
    
    func customizeNavigationBar() {
        self.navigationItem.title = "Yelp Me"
        
        //setup for search bar
        bizSearchBar.hidden = true
        searchButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: "didTapSearchButton:")
        navigationItem.rightBarButtonItem = searchButtonItem
        
        //preare button for the left navigationitem's bar item button and add negative spacer
        let filterIcon = UIImage(named: "FilterIcon")
        let filterButton = UIButton(type: UIButtonType.Custom)
        filterButton.addTarget(self,
            action: "didTapFilterButton:", forControlEvents: .TouchUpInside)
        filterButton.frame = CGRectMake(0, 0, 44, 44)
        filterButton.setImage(filterIcon , forState: UIControlState.Normal)
        let yelpBarItemButton = UIBarButtonItem(customView: filterButton)
        let negativeSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil , action: nil )
        negativeSpacer.width = -15
        navigationItem.leftBarButtonItems = [negativeSpacer, yelpBarItemButton]
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.tintColor = UIColor.blackColor()
        }
    }
    
    //infinite scroll
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if !isMoreDataLoading {
            //calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            //when the user has scrolled past the threshold, start requesting
            if scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging {
                isMoreDataLoading = true
                
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                //load more data
                loadMoreData()
            }
        }
    }
    
    func loadMoreData() {
        Business.searchWithTerm("Restaurants", offset: loadMoreOffset, sort: nil, categories: selectedCategories, deals: nil, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            if error != nil {
                self.delay(2.0, closure: {
                    self.loadingMoreView?.stopAnimating()
                    //TODO: show network error
                })
            } else {
                self.delay(0.5, closure: { Void in
                    self.loadMoreOffset += 20
                    self.filteredBusinesses.appendContentsOf(businesses)
                    self.tableView.reloadData()
                    self.loadingMoreView?.stopAnimating()
                    self.isMoreDataLoading = false
                })
            }
        })
    }
    
    func setupInfiniteScrollView() {
        let frame = CGRectMake(0, tableView.contentSize.height,
            tableView.bounds.size.width,
            InfiniteScrollActivityView.defaultHeight
        )
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview( loadingMoreView! )
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
    }
    
    //pull to refresh
    func pullToRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    func onRefresh() {
        delay(2, closure: {
            self.refreshControl.endRefreshing()
        })
    }
    
    func delay(delay: Double, closure: () -> () ) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure
        )
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBusinesses?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        cell.business = filteredBusinesses[indexPath.row]
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "BusinessDetailsSegue" {
            let chosenIndex = self.tableView.indexPathForCell(sender as! BusinessCell)?.row
            
            if let  businessDetailsVC = segue.destinationViewController as? BusinessDetailsViewController {
                businessDetailsVC.business = filteredBusinesses[chosenIndex!]
            }
        }
        
        if let navigationController = segue.destinationViewController as? UINavigationController {
            let filtersViewController = navigationController.topViewController as! FiltersViewController
            filtersViewController.delegate = self
        }
        
    }
    
    func filtersViewController(filtersViewController: FiltersViewController,
        didUpdateFilters filters: [String : AnyObject]) {
            
        //categories from the passed back object filters
        let categories = filters["categories"] as? [String]
        //save the selectedCategories state to be used with infinite scrolling
        selectedCategories = categories
        //reset the business array
        self.filteredBusinesses = []
        //retrigger the data call with categories
        Business.searchWithTerm("Restaurants", sort: nil, categories: categories, deals: nil) {
            (businesses: [Business]!, error: NSError!) -> Void in
            self.filteredBusinesses = businesses
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        bizSearchBar.delegate = self
        
        //use whatever autolayout automatic rule told you to do
        tableView.rowHeight = UITableViewAutomaticDimension
        //to prevent runtime calculation of scroll row height of large number of rows,use this for autolayout
        tableView.estimatedRowHeight = 120
        
        customizeNavigationBar()
        pullToRefreshControl()
        setupInfiniteScrollView()
        
        Business.searchWithTerm("Restaurants", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredBusinesses = businesses
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BusinessesViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.setShowsCancelButton(true, animated: true)
        
        filteredBusinesses = searchText.isEmpty ? businesses : businesses.filter({
            $0.name!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        (filteredBusinesses, searchBar.text) = (businesses, "")
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
}
