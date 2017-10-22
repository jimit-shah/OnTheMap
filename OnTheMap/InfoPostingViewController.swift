//
//  InfoDetailViewController.swift
//  OnTheMap
//
//  Created by Jimit Shah on 8/5/17.
//  Copyright © 2017 Jimit Shah. All rights reserved.
//

import UIKit

// MARK: InfoPostingViewController: UIViewController

class InfoPostingViewController: UIViewController {
  
  // Properties
  
  var student: ParseStudent?
    
  // MARK: Outlets
  
  @IBOutlet weak var locationTextField: UITextField!
  @IBOutlet weak var websiteTextField: UITextField!
  @IBOutlet weak var scrollView: UIScrollView!
  
  // MARK: Actions
  @IBAction func cancelButton(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    locationTextField.delegate = self
    websiteTextField.delegate = self
  }
  
  // MARK: Prepare for Segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "mapViewSegue" {
      let controller = segue.destination as! LocationViewController
      controller.userLocationString = locationTextField.text
      controller.mediaURL = websiteTextField.text
      
      // if student location exist
      if let student = student {
      controller.objectID = student.objectID
        print("ObjectID being passed to LocationViewController \(student.objectID!)")
      }
    }
  }
  
  // MARK: Shoud Perform Sqgue with Identifier on conditions
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    if identifier == "mapViewSegue" {
      guard let locationString = locationTextField.text, !locationString.isEmpty  else {
        showAlert("Location Not Found", message: "Must Enter a Location.")
        return false
      }
      guard let url = websiteTextField.text, !url.isEmpty else {
        showAlert("Location Not Found", message: "Must Enter a Website.")
        return false
      }
      if (!url.contains("https://")) {
        showAlert("Location Not Found", message: "Website must include \"https://\"")
        return false
      }
    }
    return true
  }
}

// MARK: - UITextFieldDelegate

extension InfoPostingViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    var y = 0
    if textField == websiteTextField {
      y = 120
    } else if textField == locationTextField {
      y = 60
    }
    
    if UIDevice.current.orientation.isLandscape {
      scrollView.setContentOffset(CGPoint(x:0,y:y), animated: true)
    }
    
    // Another option
    //let width = self.view.frame.width
    //let height = self.view.frame.height
    
    //if height < width {
    //    scrollView.setContentOffset(CGPoint(x:0,y:y), animated: true)
    //}
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if UIDevice.current.orientation.isLandscape {
      scrollView.setContentOffset(CGPoint(x:0,y:0), animated: true)
    }
  }
  
}

