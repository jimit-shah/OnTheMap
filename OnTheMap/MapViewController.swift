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
  
  //var studentLocations = [ParseStudent]()
  var annotations = [MKPointAnnotation]()
  
  
  @IBOutlet weak var mapView: MKMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //TODO: HOW TO MOVE THIS CODE IN StudentsTabBarController and access here????
    
    ParseClient.sharedInstance().getStudentLocations{ (students, error) in
      
      if let students = students {
        // self.studentLocations = students
        
        for location in students {
          
          // Make sure latitude and longitude values are not nil.
          guard let latitude = location.latitude else {
            print("No Latitude Data found.")
            return // IT SEEMS WHEN THERE IS NO LAT/LONG DATA IT WILL SKIP ENTIRE DATASET TO PROCESS AND AS RESULT WE WILL HAVE NO PINS AT ALL. HOW SHOULD WE HANDLE THIS???
          }
          
          guard let longitude = location.longitude else {
            print("No Longitude found.")
            return
          }
          
          // Notice that the float values are being used to create CLLocationDegree values.
          // This is a version of the Double type.
          let lat = CLLocationDegrees(latitude)
          let long = CLLocationDegrees(longitude)
          
          
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
          
          // Finally we place the annotation in an array of annotations.
          self.annotations.append(annotation)
        }
        // performUIUpdatesOnMain {
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(self.annotations)
        //}
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


