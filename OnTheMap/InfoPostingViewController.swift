//
//  InfoDetailViewController.swift
//  OnTheMap
//
//  Created by Jimit Shah on 8/5/17.
//  Copyright © 2017 Jimit Shah. All rights reserved.
//

import UIKit

class InfoPostingViewController: UIViewController {
  
  // MARK: Properties
  
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
  
}
