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
  var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
  
  // MARK: Actions
  
  @IBAction func refreshPressed(_ sender: Any) {
    refreshData()
  }
  
  @IBAction func addLocationPressed(_ sender: Any) {
    
    if let studentLocation = studentLocation {
      
      // if location exist ask to continue
      askToContinueAlert(nil, message: "User \"\(studentLocation.firstName!) \(studentLocation.lastName!)\" Has Already Posted a Location. Would you like to Overwrite Their Location?", { (overwrite) in
        if overwrite {
          self.performSegue(withIdentifier: "infoPostingSegue", sender: sender)
        }
      })
      
    } else {
      // if location doesn't exist perform segue
      performSegue(withIdentifier: "infoPostingSegue", sender: sender)
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
          self.notify(nil, message: "Invalid Link")
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
    let userID = ParseClient.sharedInstance().userID!
    
    ParseClient.sharedInstance().getStudentLocation(userID, { (studentLocation, error) in
      
      if let studentLocation = studentLocation {
        self.studentLocation = studentLocation
      }
    })
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    startAcitivtyIndicator(activityIndicator, for: self)
    refreshData()
  }
  
  func refreshData() {
    
    startAcitivtyIndicator(activityIndicator, for: self)
    
    let mapViewController = self.viewControllers?[0] as! MapViewController
    let listViewController = self.viewControllers?[1] as! ListViewController
    
    ParseClient.sharedInstance().getStudentLocations{ (students, error) in
      
      if let students = students {
        listViewController.students = students
        
        performUIUpdatesOnMain {
          
          // Add Annotations to MapView
          mapViewController.addAnnotationsToMapView(locations: students)
          listViewController.refreshTableView()
          //call the reload data
//          if let studentsTableView = listViewController.studentsTableView {
//            studentsTableView.reloadData()
//          }
          
          self.stopActivityIndicator(self.activityIndicator, for: self)
        }
      } else {
        //print(error ?? "Could not find any Student Locations.")
        self.notify("No Data Found", message: (error?.localizedDescription)!)
      }
    }
    
  }
  
  // MARK: prepareForSegue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //var overwriteLocation = false
    if segue.identifier == "infoPostingSegue" {
      if let studentLocation = studentLocation {
        let navController = segue.destination as! UINavigationController
        let controller = navController.viewControllers.first as! InfoPostingViewController
        controller.student = studentLocation
      }
    }
  }
  
}
