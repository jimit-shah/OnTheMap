//
//  StudentsTabBarController.swift
//  OnTheMap
//
//  Created by Jimit Shah on 8/5/17.
//  Copyright © 2017 Jimit Shah. All rights reserved.
//

import UIKit
import FBSDKLoginKit

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
    
    let alertController = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
    
    let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) -> Void in
      
      // Logout from Facebook if login method is Facebook login
      if self.isFacebookLogin {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
      }
      // then logout from Udacity
      self.completeLogout()
    })
    
    let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
    alertController.addAction(yesAction)
    alertController.addAction(noAction)
    present(alertController, animated: true, completion: nil)
  }
  
  // MARK: Helpers
  
  // MARK: completeLogout()
  fileprivate func completeLogout() {
    // logout from Udacity and dismiss view
    UdacityClient.sharedInstance().sessionLogout{ (success, errorString) in
      performUIUpdatesOnMain {
        if success {
          self.dismiss(animated: true, completion: nil)
        } else {
          self.showAlert("Logout Failed", message: "\(errorString!)")
        }
      }
    }
  }
  
  // Display error
  func displayError(_ errorString: String?) {
    if let errorString = errorString {
      print(errorString)
    }
  }
  
  // A flag indicating the presence of an Facebook SDK access token
  fileprivate let isFacebookLogin: Bool = {
    return FBSDKAccessToken.current() != nil
  }()
  
  // MARK : Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let userID = ParseClient.sharedInstance().userID!
    
    // Get a aStudent Location
    ParseClient.sharedInstance().getStudentLocation(userID, { (studentLocation, error) in
      if let studentLocation = studentLocation {
        self.studentLocation = studentLocation
      }
    })
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    refreshData()
  }
  
  // MARK: refreshData()
  // load or refresh data and pass it to view controllers
  
  func refreshData() {
    
    // get activity indicator
    startActivityIndicator(for: self, activityIndicator, .whiteLarge)
    
    let mapViewController = self.viewControllers?[0] as! MapViewController
    let listViewController = self.viewControllers?[1] as! ListViewController
    
    ParseClient.sharedInstance().getStudentLocations{ (students, error) in
      if let students = students {
        listViewController.students = students
        
        performUIUpdatesOnMain {
          // Add Annotations to MapView and refresh data
          mapViewController.addAnnotationsToMapView(locations: students)
          listViewController.refreshTableView()
          
          // stop activity indicator
          self.stopActivityIndicator(for: self, self.activityIndicator)
        }
      } else {
        performUIUpdatesOnMain {
          // show alert and stop activity indicator
          self.showAlert("No Data Found", message: (error?.localizedDescription)!)
          self.stopActivityIndicator(for: self, self.activityIndicator)
        }
        
      }
    }
  }
  
  // MARK:- prepareForSegue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "infoPostingSegue" {
      if let studentLocation = studentLocation {
        let navController = segue.destination as! UINavigationController
        let controller = navController.viewControllers.first as! InfoPostingViewController
        // pass student data to InfoPostingViewController
        controller.student = studentLocation
      }
    }
  }
  
}
