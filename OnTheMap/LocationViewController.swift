//
//  LocationController.swift
//  OnTheMap
//
//  Created by Jimit Shah on 9/13/17.
//  Copyright © 2017 Jimit Shah. All rights reserved.
//

import UIKit
import MapKit


// MARK: LocationViewController: UIViewController

class LocationViewController: UIViewController {
  
  // MARK: Properties
  var geocoder: CLGeocoder?
  var userLocation: String?
  var student: ParseStudent?
  
  // MARK: Outlets
  @IBOutlet weak var mapView: MKMapView!
  
  // MARK: Actions
  @IBAction func finishPressed(_ sender: Any) {
    
    // Get Student's Public Data
    UdacityClient.sharedInstance().getUserInfo { (student, error) in
      
      if let student = student {
        //self.student = student
        
        print("Student First: \(student.firstName) LastName: \(student.lastName)")
        print("Student Info: \(student)")
        ParseClient.sharedInstance().getStudentLocation(student.userID, { (result, error) in
          /*
           "objectId": "pIA79QIzdX",
           "mapString": "Mountain View, CA",
           "updatedAt": "2016-06-29T23:12:10.552Z",
           "mediaURL": "www.facebook.com",
           "createdAt": "2016-06-29T23:12:10.552Z",
           "lastName": "1234",
           "uniqueKey": "1234",
           "firstName": "Test",
           "latitude": 37.39008,
           "longitude": -122.0813919
 */
          if let result = result {
            self.student = result
            print("Location Detail Found: \(result)")
          } else {
            print("No location Data found")
          }
          
        })
        
      } else {
        print(error ?? "empty error")
      }
    }
    
  }
  
  
  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.delegate = self
    
    // Call Geacoding function
    lookupGeocoding()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    
  }
  
  
  // MARK: Forward Geocoding to get latitude and longitude based on user entry.
  func lookupGeocoding() {
    if geocoder == nil {
      geocoder = CLGeocoder()
    }
    
    geocoder?.geocodeAddressString(userLocation!, completionHandler: { (placemarks, error) in
      let placemark = placemarks?.first
      let lat = placemark?.location?.coordinate.latitude
      let long = placemark?.location?.coordinate.longitude
      
      if let lat =  lat, let long = long {
        self.reverseGeocoding(latitude: lat, longitude: long)
      }
    })
    
  }
  
  // MARK: reverseGeocoding for accuracy to save location.
  func reverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
    
    let location = CLLocation(latitude: latitude, longitude: longitude)
    geocoder?.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
      
      let placemark = placemarks?.first
      let city = placemark?.locality
      let state = placemark?.administrativeArea
      let zip = placemark?.postalCode
      let country = placemark?.isoCountryCode
      
      var address: String? = ""
      let comma: String = ", "
      let space: String = " "
      
      func appendAddress(_ optionalString: String?, _ seprator: String) {
        if let optionalString = optionalString {
          address?.append("\(optionalString)\(seprator)")
        }
      }
      
      appendAddress(city, comma)
      appendAddress(state, space)
      appendAddress(zip, comma )
      appendAddress(country, "")
      
      // Pass values to generate MapView
      self.renderMapWithPinView(latitude: latitude, longitude: longitude, title: address!)
    })
    
  }
  
  
  // MARK: renderMapWithPinView
  func renderMapWithPinView(latitude: CLLocationDegrees, longitude: CLLocationDegrees, title: String) {
    let annotation = MKPointAnnotation()
    let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
    let regionRadius: CLLocationDistance  = 250
    
    annotation.coordinate = coordinate
    annotation.title = title
    
    performUIUpdatesOnMain {
      self.mapView.addAnnotation(annotation)
      self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(coordinate, regionRadius, regionRadius), animated: true)
    }
  }
  
}

// MARK: MKMapViewDelegate

extension LocationViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
    let reuseId = "pin"
    
    var pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
    
    if pinAnnotationView == nil {
      pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
      pinAnnotationView!.canShowCallout = true
      pinAnnotationView!.pinTintColor = .red
    } else {
      pinAnnotationView?.annotation = annotation
    }
    return pinAnnotationView
  }
  
}


