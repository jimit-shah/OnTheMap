//
//  TextFieldDelegate.swift
//  OnTheMap
//
//  Created by Jimit Shah on 9/11/17.
//  Copyright © 2017 Jimit Shah. All rights reserved.
//

import UIKit

// MARK: TextFieldDelegate: NSObject, UITextFieldDelegate
class TextFieldDelegate: NSObject, UITextFieldDelegate {
  
  // Hide keyboard on pressing return
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
}
