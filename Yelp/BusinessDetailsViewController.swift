//
//  BusinessDetailsViewController.swift
//  Yelp
//
//  Created by Sarn Wattanasri on 1/27/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessDetailsViewController: UIViewController {
    
    var business: Business!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    @IBOutlet weak var crossStreetLabel: UILabel!
    @IBOutlet weak var openCloseLabel: UILabel!
    @IBOutlet weak var photosWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = business.name!
        typesLabel.text = business.categories!
        crossStreetLabel.text = business.crossStreets
        openCloseLabel.text = business.isClosed == true ? "Permanently Closed" : ""
        
        let url = "http://www.yelp.com/biz_photos/\(business.id!)"
        let requestURL = NSURL(string: url)
        let request = NSURLRequest(URL: requestURL!)
        photosWebView.loadRequest(request)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "BusinessMapSegue" {
            if let businessMapVC = segue.destinationViewController as? BusinessMapViewController {
                businessMapVC.business = self.business
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
