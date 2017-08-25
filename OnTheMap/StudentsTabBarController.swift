//
//  StudentsTabBarController.swift
//  OnTheMap
//
//  Created by Jimit Shah on 8/5/17.
//  Copyright © 2017 Jimit Shah. All rights reserved.
//

import UIKit

class StudentsTabBarController: UITabBarController {

  // MARK: Properties
  
  // the data for the table
  var students = [ParseStudent]()
  var firstName = "No First Name"
  var lastName = "No Last Name"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    ParseClient.sharedInstance().getStudentLocations{ (students, error) in
      
      if let students = students {
        self.students = students
      } else {
        print(error ?? "empty error")
      }
    }
    
  }


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

}
