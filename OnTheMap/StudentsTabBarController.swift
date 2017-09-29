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
  
  
  // MARK: Properties
  
  var studentLocation: ParseStudent?
  
  // MARK: Actions
  
  @IBAction func refreshPressed(_ sender: Any) {
    refreshData()
  }
  
  @IBAction func logout(_ sender: Any) {
    
    UdacityClient.sharedInstance().sessionLogout{ (success, errorString) in
      performUIUpdatesOnMain {
        if success {
          print("Logout Successfully.")
          self.completeLogout()
        } else {
          self.displayError(errorString)
          self.notify(nil, message: "Invalid Link")
        }
      }
    }
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "infoPostingSegue" {
      let navController = segue.destination as! UINavigationController
      let controller = navController.viewControllers.first as! InfoPostingViewController
      controller.student = studentLocation
    }
  }
  
  
  // MARK: shouldPerformSegue 
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    
    if identifier == "infoPostingSegue" {
      if let studentLocation = studentLocation {
        
//        askToContinueAlert(nil, message: "User \"\(studentLocation.firstName!) \(studentLocation.lastName!)\" Has Already Posted a Location. Would you like to Overwrite Their Location?", { (continue) in
//          if continue {
//            return true
//          } else {
//            return false
//          }
//        })
        
        let alert = UIAlertController(title: nil, message: "User \"\(studentLocation.firstName!) \(studentLocation.lastName!)\" Has Already Posted a Location. Would you like to Overwrite Their Location?", preferredStyle:.alert)

        let overwriteAction = UIAlertAction(title: "Overwrite", style: .default, handler: { action in
          self.performSegue(withIdentifier: "infoPostingSegue", sender: sender)
        })

        // Create Cancel button with action handlder
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
        })

        //Add OK and Cancel button to dialog message
        alert.addAction(overwriteAction)
        alert.addAction(cancelAction)

        // Present dialog message to user
        self.present(alert, animated: true, completion: nil)
      }
    }
    return true
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
    let userID = ParseClient.sharedInstance().userID!
    
    ParseClient.sharedInstance().getStudentLocation(userID, { (studentLocation, error) in
      
      if let studentLocation = studentLocation {
        self.studentLocation = studentLocation
        print("StudentLocation is retrieved by getStudentLocation.")
        print("Student Info: \(studentLocation)")
      }
    })
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    refreshData()
  }
  
  func refreshData() {
    let mapViewController = self.viewControllers?[0] as! MapViewController
    let listViewController = self.viewControllers?[1] as! ListViewController
    
    
    ParseClient.sharedInstance().getStudentLocations{ (students, error) in
      
      if let students = students {
        listViewController.students = students
        
        performUIUpdatesOnMain {
          // first remove all annotations (if already added before)
          mapViewController.removeAnnotations()
          
          // now add all annotations to mapview
          mapViewController.addAnnotationsToMapView(locations: students)
          //listViewController.re
          //call the reload data
          if let studentsTableView = listViewController.studentsTableView {
            studentsTableView.reloadData()
          }
          
        }
      } else {
        //print(error ?? "Could not find any Student Locations.")
        self.notify("No Data Found", message: (error?.localizedDescription)!)
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
