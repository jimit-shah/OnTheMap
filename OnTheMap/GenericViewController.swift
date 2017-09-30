//
//  GenericViewController.swift
//  OnTheMap
//
//  Created by Jimit Shah on 9/29/17.
//  Copyright © 2017 Jimit Shah. All rights reserved.
//

import UIKit

extension UIViewController {
  
  func notify( _ title: String?, message: String) -> Void
  {
    let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: UIAlertControllerStyle.alert)
    let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
    alert.addAction(action)
    self.present(alert, animated: true, completion: nil)
  }
  
  
  func askToContinueAlert(_ title: String?, message: String, _ completionHandler: @escaping (_ : Bool) -> Void) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    
    let overwriteAction = UIAlertAction(title: "Overwrite", style: .default, handler: { (action) -> Void in
      completionHandler(true)
    })
    
    // Create Cancel button with action handlder
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
      completionHandler(false)
    })
    
    //Add OK and Cancel button to dialog message
    alert.addAction(overwriteAction)
    alert.addAction(cancelAction)
    
    // Present dialog message to user
    self.present(alert, animated: true, completion: nil)
  }
  
  func dismissAlert(_ title: String?, message: String, _ completionHandler: @escaping (_ : Bool) -> Void) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: { (action) -> Void in
      completionHandler(true)
    })
    alert.addAction(dismissAction)
    self.present(alert, animated: true, completion: nil)
  }
  
}
