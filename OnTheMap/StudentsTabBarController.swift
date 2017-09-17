//
//  StudentsTabBarController.swift
//  OnTheMap
//
//  Created by Jimit Shah on 8/5/17.
//  Copyright © 2017 Jimit Shah. All rights reserved.
//

import UIKit

// MARK: - StudentsTabBarController

class StudentsTabBarController: UITabBarController {
  

  // MARK: Actions
  @IBAction func logout(_ sender: Any) {
    
    UdacityClient.sharedInstance().sessionLogout{ (success, errorString) in
      performUIUpdatesOnMain {
        if success {
          print("Logout Successfully.")
          self.completeLogout()
        } else {
          self.displayError(errorString)
          self.notifyUser(nil, message: "Invalid Link")
        }
      }
    }
    
  }
  
  // Dismiss View Function
  func completeLogout() {
    self.dismiss(animated: true, completion: nil)
  }
  
  // Display error
  func displayError(_ errorString: String?) {
    if let errorString = errorString {
      print(errorString)
    }
  }
  
  // MARK : Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let mapViewController = self.viewControllers?[0] as! MapViewController
    let listViewController = self.viewControllers?[1] as! ListViewController
    
    ParseClient.sharedInstance().getStudentLocations{ (students, error) in
      
      if let students = students {
        
        performUIUpdatesOnMain {
          mapViewController.addAnnotationsToMapView(locations: students)
          //listViewController.loadDataInTableView(locations: students)
          listViewController.students = students
        }
      } else {
        print(error ?? "Could not find any Student Locations.")
      }
      
    }
  }
  
  
}

// MARK: - ListViewController (Configure UI)

private extension StudentsTabBarController {
  
  func notifyUser(_ title: String?, message: String) -> Void
  {
    let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: UIAlertControllerStyle.alert)
    let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
    alert.addAction(action)
    self.present(alert, animated: true, completion: nil)
}

}
