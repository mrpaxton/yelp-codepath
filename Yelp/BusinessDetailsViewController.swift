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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("business: \(business.name)")
        print("coordinate: \(business.coordinate)")
        print(business)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
