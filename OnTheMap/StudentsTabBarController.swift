//
//  StudentsTabBarController.swift
//  OnTheMap
//
//  Created by Jimit Shah on 8/5/17.
//  Copyright © 2017 Jimit Shah. All rights reserved.
//

import UIKit

var studentLocations = [ParseStudent]()

class StudentsTabBarController: UITabBarController {
  
  
  @IBAction func logout(_ sender: Any) {
    
    UdacityClient.sharedInstance().sessionLogout{ (success, errorString) in
      performUIUpdatesOnMain {
        if success {
          print("Logout Successfully.")
          self.completeLogout()
        } else {
          self.displayError(errorString)
        }
      }
    }
    
  }
  
  func completeLogout() {
    self.dismiss(animated: true, completion: nil)
  }
  
  func displayError(_ errorString: String?) {
    if let errorString = errorString {
      print(errorString)
    }
  }
  
//  func save(locations: [ParseStudent]) {
//    //print("Student: \(locations)")
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    appDelegate.locations = locations
//    print("\nAll students are saved in global locations: \(appDelegate.locations)\n")
  
//  }
  

}
