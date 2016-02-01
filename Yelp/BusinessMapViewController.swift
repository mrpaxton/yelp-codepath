//
//  BusinessMapViewController.swift
//  Yelp
//
//  Created by Sarn Wattanasri on 1/27/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class BusinessMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var business: Business?
    
    func addPin(latitude latitude: Double, longitude: Double, title: String) {
        
        let annotation = MKPointAnnotation()
        let locationCoordinate = CLLocationCoordinate2DMake(latitude, longitude)
        annotation.coordinate = locationCoordinate
        annotation.title = title
        
        mapView.addAnnotation(annotation)
        
        //set additional annotation
        /*let annotation2 = MKPointAnnotation()
        let locationCoordinate2 = CLLocationCoordinate2DMake(latitude + 0.02, longitude + 0.02)
        annotation2.coordinate = locationCoordinate2
        annotation2.title = "Foo"
        mapView.addAnnotation(annotation2)*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        //add circle overlay
        let coordinate = CLLocationCoordinate2D(latitude: (business?.coordinate.0)!, longitude: (business?.coordinate.1)!)
        let circleOverlay: MKCircle = MKCircle(centerCoordinate:coordinate, radius: 1000)
        mapView.addOverlay(circleOverlay)
        
        //addAnnotationAtCoordinate(coordinate)
        
        // set the region to display, this also sets a correct zoom level
        // set starting center location in San Francisco
        let centerLocation = CLLocation(latitude: (business?.coordinate.0)!, longitude: (business?.coordinate.1)!)
        goToLocation(centerLocation)
        addPin(latitude: (business?.coordinate.0)!, longitude: (business?.coordinate.1)!, title: business!.name! )
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.08, 0.08)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: false)
    }
    
        func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
            let circleView = MKCircleRenderer(overlay: overlay)
            circleView.strokeColor = UIColor.brownColor()
            circleView.lineWidth = 1
            return circleView
        }
    
//        func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//            let reuseID = "myAnnotationView"
//            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
//            if (annotationView == nil) {
//                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
//            }
//    
//            annotationView!.image = UIImage(named: "FilterImage")
//            return annotationView
//        }
    
   
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
