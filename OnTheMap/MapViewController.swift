//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Jimit Shah on 7/30/17.
//  Copyright © 2017 Jimit Shah. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
  
  var locations = [ParseStudent]()
  
  @IBOutlet weak var mapView: MKMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    ParseClient.sharedInstance().getStudentLocations{ (students, error) in
      
      var annotations = [MKPointAnnotation]()
      
      if let students = students {
        
        for location in students {
          
          let lat = CLLocationDegrees(location.latitude)
          let long = CLLocationDegrees(location.longitude)
          
          // The lat and long are used to create a CLLocationCoordinates2D instance.
          let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
          
          let first = location.firstName!
          let last = location.lastName!
          let mediaURL = location.mediaURL
          
          // Here we create the annotation and set its coordiate, title, and subtitle properties
          let annotation = MKPointAnnotation()
          annotation.coordinate = coordinate
          annotation.title = "\(first) \(last)"
          annotation.subtitle = mediaURL
          
          annotations.append(annotation)
        }
        
        performUIUpdatesOnMain {
          // Finally we place the annotation in an array of annotations.
          self.mapView.addAnnotations(annotations)
        }
      } else {
        print(error ?? "empty error")
      }
    }
    
  }
  
}



extension MapViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
    let reuseId = "pin"
    
    var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
    
    if pinView == nil {
      pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
      pinView!.canShowCallout = true
      pinView!.pinTintColor = .red
      pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    } else {
      pinView!.annotation = annotation
    }
    return pinView
  }
  
}


