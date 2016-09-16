//
//  StoreLocatorVieViewController.swift
//  NeoSTORE
//
//  Created by webwerks1 on 9/7/16.
//  Copyright © 2016 webwerks1. All rights reserved.
//

import UIKit
import MapKit

class StoreLocatorViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.mapView.delegate = self
        
        let artwork = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 19.0244, longitude: 72.8444),title: "NeoSoft technologies",
                                       subtitle: "The Ruby Tower")

        mapView.addAnnotation(artwork)
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu_icon"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SSASideMenu.presentLeftMenuViewController))
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? CustomAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                var zoomRect = MKMapRectNull
                for annotation: MKAnnotation in mapView.annotations {
                    let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
                    let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1)
                    zoomRect = MKMapRectUnion(zoomRect, pointRect)
                }
                mapView.setVisibleMapRect(zoomRect, animated: true)
                
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
            }
            return view
        }
        return nil
    }
}
