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
  //var latitude: CLLocationDegrees?
  //var longitude: CLLocationDegrees?
  var userLocation: String?
  var address: String?
  
  @IBOutlet weak var mapView: MKMapView!
  
  
  // MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    //mapView.delegate = self
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
        
        var annotations = [MKPointAnnotation]()
        self.reverseGeocoding(latitude: lat, longitude: long)
        
        let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        
        
        if let address = self.address {
        annotation.title = address
        }
    
        annotations.append(annotation)
        
        performUIUpdatesOnMain {
          self.mapView.addAnnotations(annotations)
          self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(lat, long), 250, 250), animated: true)
        }
        
      }
    })
  }
  
  
  func reverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
  
    let location = CLLocation(latitude: latitude, longitude: longitude)
    geocoder?.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
      let placemark = placemarks?.first
      let streetNumber = placemark?.subThoroughfare
      let street = placemark?.thoroughfare
      let city = placemark?.locality
      let state = placemark?.administrativeArea
      let zip = placemark?.postalCode
      
      var address: String? = ""
      if let streetNumber = streetNumber {
        address?.append(streetNumber)
      }
      if let street = street {
        address?.append(street)
      }
      
      if let city = city {
        address?.append(city)
      }
      
      if let state = state {
        address?.append(state)
      }
      
      if let zip = zip {
        address?.append(zip)
      }
      if let address = address {
        print("address: \(address)")
        self.address = address
        //let address = "\(streetNumber!) \(street!) \(city!) \(state!) \(zip!)"
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
      pinAnnotationView!.canShowCallout = true
      pinAnnotationView!.pinTintColor = .red
      pinAnnotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    } else {
      pinAnnotationView?.annotation = annotation
    }
    return pinAnnotationView
  }
  

  
}
