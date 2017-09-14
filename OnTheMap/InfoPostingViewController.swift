//
//  InfoDetailViewController.swift
//  OnTheMap
//
//  Created by Jimit Shah on 8/5/17.
//  Copyright © 2017 Jimit Shah. All rights reserved.
//

import UIKit
import CoreLocation

class InfoPostingViewController: UIViewController {
  
  // MARK: Properties
  var geocoder: CLGeocoder?
  
  
  @IBOutlet weak var locationTextField: UITextField!
  @IBOutlet weak var websiteTextField: UITextField!
  
  // Text Field Delegate
  let textFieldDelegate = TextFieldDelegate()
  
  // MARK: Actions
  @IBAction func cancelButton(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  @IBAction func findOnMapPressed(_ sender: Any) {
    lookupGeocoding()
  }
  
  func lookupGeocoding() {
    if geocoder == nil {
      geocoder = CLGeocoder()
    }
    
    geocoder?.geocodeAddressString(locationTextField.text!, completionHandler: { (placemarks, error) in
      let placemark = placemarks?.first
      let latitude = placemark?.location?.coordinate.latitude
      let longitude = placemark?.location?.coordinate.longitude
      if let latitude =  latitude, let longitude = longitude {
        let coordinates = "\(latitude) \(longitude)"
        self.locationTextField.text = coordinates
        print("Coordinates are \(coordinates)")
      }
      
    })
  }
  
  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    locationTextField.delegate = textFieldDelegate
    websiteTextField.delegate = textFieldDelegate
    
  }
  
}
