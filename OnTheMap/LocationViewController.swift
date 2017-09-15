//
//  LocationController.swift
//  OnTheMap
//
//  Created by Jimit Shah on 9/13/17.
//  Copyright © 2017 Jimit Shah. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController {
  
  var geocoder: CLGeocoder?
  var userLocation: String?
  
  @IBOutlet weak var mapView: MKMapView!
  
  // MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    lookupGeocoding()
    
  }
  
  // MARK: Geocoding Function
  func lookupGeocoding() {
    if geocoder == nil {
      geocoder = CLGeocoder()
    }
    
    geocoder?.geocodeAddressString(userLocation!, completionHandler: { (placemarks, error) in
      let placemark = placemarks?.first
      let lat = placemark?.location?.coordinate.latitude
      let long = placemark?.location?.coordinate.longitude
      
      if let lat =  lat, let long = long {
        let coord = "\(lat) \(long)"
        
        //self.locationTextField.text = coordinates
        var annotations = [MKPointAnnotation]()
        
        let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        
        annotations.append(annotation)
        
        print("Coordinates are \(coord)")
        
        performUIUpdatesOnMain {
          self.mapView.addAnnotations(annotations)
          self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(lat, long), 250, 250), animated: true)
          
          
        }
        
        
      }
      
    })
  }
  
  
  
}


extension LocationViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let reuseId = "pin"
    var pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
    if pinAnnotationView == nil {
      pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
      pinAnnotationView?.canShowCallout = true
      pinAnnotationView?.pinTintColor = .red
      pinAnnotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    } else {
      pinAnnotationView?.annotation = annotation
    }
    return pinAnnotationView
  }
  
}
