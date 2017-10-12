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
  var objectID: String?
  
  var userLocationString: String?
  var mediaURL: String?
  var lat: CLLocationDegrees?
  var long: CLLocationDegrees?
  var message: String?
  
  var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
  
  // MARK: Messages
  struct Messages {
    // Messages to Display Alert on API completion.
    static let PutSuccess = "Your Location Updated Successfully!"
    static let PostSuccess = "Your Location Added Successfully!"
    static let PutError = "Error - Location Update Failed."
    static let PostError = "Error - Didn't Save Location."
  }
  
  // MARK: Outlets
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var finishButton: BorderedButton!
  
  // MARK: Actions
  @IBAction func finishPressed(_ sender: Any) {
    
    finishButton.isEnabled = false
    // show an activity indicator
    startActivityIndicator(for: self, activityIndicator, .whiteLarge)
    
    // Get Student's Public Data
    UdacityClient.sharedInstance().getUserInfo { (student, error) in
    
      if let student = student {
        
        let studentDict: [String:AnyObject] = [
          "uniqueKey": student.userID as AnyObject,
          "firstName": student.firstName as AnyObject,
          "lastName": student.lastName as AnyObject,
          "mapString": self.userLocationString as AnyObject,
          "mediaURL": self.mediaURL as AnyObject,
          "latitude": self.lat as AnyObject,
          "longitude": self.long as AnyObject
        ]
        
        if let objectID = self.objectID, !objectID.isEmpty {
          // PUT to existing record
          self.putToExistingLocation(objectID: objectID, dictionary: studentDict)
          
        } else {
          // POST a new location
          self.postNewLocation(dictionary: studentDict)
        }
        
      } else if let error = error {
        self.updateUI("Error Retrieving User Info: \(error)")
      }
    }
    
  }
  
  // Function to Update an Existing Location
  func putToExistingLocation(objectID: String, dictionary: [String:AnyObject]) {
    ParseClient.sharedInstance().putToStudentLocation(objectID, dictionary, { (success, error) in
      if success {
        self.message = Messages.PutSuccess
      } else {
        self.message = Messages.PutError
      }
      self.updateUI(self.message!)
    })
  }
  
  // Function to Post a New Location
  func postNewLocation(dictionary: [String:AnyObject]) {
    ParseClient.sharedInstance().postToStudentLocation(dictionary, { (success, error) in
      if success {
        self.message = Messages.PostSuccess
      } else {
        self.message = Messages.PostError
      }
      self.updateUI(self.message!)
    })
  }
 
  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.delegate = self
    
    // Do not show finish button until location lat and long are verfied.
    finishButton.isHidden = true
    
    // Call to Geacoding function
    lookupGeocoding()
  }
  
  // MARK: Forward Geocoding to get latitude and longitude based on user entry.
  func lookupGeocoding() {
    if geocoder == nil {
      geocoder = CLGeocoder()
    }
    
    geocoder?.geocodeAddressString(userLocationString!, completionHandler: { (placemarks, error) in
      let placemark = placemarks?.first
      let lat = placemark?.location?.coordinate.latitude
      let long = placemark?.location?.coordinate.longitude
      
      if let lat =  lat, let long = long {
        self.lat = lat
        self.long = long
        self.finishButton.isHidden = false
        self.reverseGeocoding(latitude: lat, longitude: long)
      }
    })
    
  }
  
  // MARK: reverseGeocoding for accurate Pin info.
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
  // MARK: startOver()
  func startOver() {
    self.navigationController?.dismiss(animated: true, completion: nil)
    finishButton.isEnabled = true
  }
}

// MARK: Update UI
private extension LocationViewController {
  
  // Update UI with Alert message, stop indicator and startover
  func updateUI(_ message: String) {
    performUIUpdatesOnMain {
      self.stopActivityIndicator(for: self, self.activityIndicator)
      self.showAlert(nil, message: self.message!, handler: {
        self.startOver()
      })
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


