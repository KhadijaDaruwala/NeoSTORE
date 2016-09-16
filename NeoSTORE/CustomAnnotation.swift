//
//  CustomAnnotation.swift
//  MapExampleiOS8
//

import UIKit
import MapKit

class CustomAnnotation : NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
    
    func annotationView() -> MKAnnotationView {
        let view = MKAnnotationView(annotation: self, reuseIdentifier: "CustomAnnotation")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.enabled = true
        view.canShowCallout = true
        view.image = UIImage(named: "location-4")
        view.rightCalloutAccessoryView = UIButton(type: UIButtonType.Custom)
        view.centerOffset = CGPointMake(0, -32)
        return view
    }
}