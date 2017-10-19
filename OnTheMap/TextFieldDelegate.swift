//
//  TextFieldDelegate.swift
//  OnTheMap
//
//  Created by Jimit Shah on 9/11/17.
//  Copyright © 2017 Jimit Shah. All rights reserved.
//

import UIKit

// MARK: TextFieldDelegate: UIViewController, UITextFieldDelegate
class TextFieldDelegate: UIViewController, UITextFieldDelegate {
  
  // Hide keyboard on pressing return
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField.accessibilityIdentifier == "pwdTextField" {
      print("Password textfield begin editing")
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField.accessibilityIdentifier == "pwdTextField" {
      print("Password textfield editing ended.")
    }
  }

}
