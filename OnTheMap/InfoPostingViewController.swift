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
  
  
  // MARK: Outlets
  
  @IBOutlet weak var locationTextField: UITextField!
  @IBOutlet weak var websiteTextField: UITextField!
  
  // Text Field Delegate
  let textFieldDelegate = TextFieldDelegate()
  
  // MARK: Actions
  @IBAction func cancelButton(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    locationTextField.delegate = textFieldDelegate
    websiteTextField.delegate = textFieldDelegate
    
  }
  
  // MARK: Prepare for Segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "mapViewSegue" {
      let controller = segue.destination as! LocationViewController
      controller.userLocationString = locationTextField.text
      controller.mediaURL = websiteTextField.text
    }
    
  }
  
  // MARK: Shoud Perform Sqgue with Identifier on conditions
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    if identifier == "mapViewSegue" {
      guard let locationString = locationTextField.text, !locationString.isEmpty  else {
        notify("Location Not Found", message: "Must Enter a Location.")
        return false
      }
      guard let url = websiteTextField.text, !url.isEmpty else {
        notify("Location Not Found", message: "Must Enter a Website.")
        return false
      }
      if (!url.contains("https://")) {
        notify("Location Not Found", message: "Website must include \"https://\"")
        return false
      }
    }
    return true
  }
}
