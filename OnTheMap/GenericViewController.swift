//
//  GenericViewController.swift
//  OnTheMap
//
//  Created by Jimit Shah on 9/29/17.
//  Copyright © 2017 Jimit Shah. All rights reserved.
//

import UIKit

extension UIViewController {
  
  
  // Alert Views
  
  func showAlert( _ title: String?, message: String) -> Void
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
  
  // generic alert that allow to dismiss with closure.
  func dismissAlert(_ title: String?, message: String, handler: @escaping () -> Void) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: { (action) -> Void in
      handler()
    })
    alert.addAction(dismissAction)
    self.present(alert, animated: true, completion: nil)
  }
  
  // Activity Indicators
  
  // MARK: startWhiteAcitivityIndicator
  func startWhiteAcitivtyIndicator(_ activityIndicator: UIActivityIndicatorView, for controller: UIViewController) {
    activityIndicator.center = controller.view.center
    activityIndicator.hidesWhenStopped = true
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
    
    for subview in controller.view.subviews {
      subview.alpha = 0.6
    }
    
    controller.view.backgroundColor = UIColor.darkGray
    controller.view.addSubview(activityIndicator)
    activityIndicator.alpha = 1.0
    activityIndicator.startAnimating()
    
  }
  
  // MARK: stopWhiteAcitivityIndicator
  func stopWhiteActivityIndicator(_ activityIndicator: UIActivityIndicatorView, for controller: UIViewController) {
    controller.view.backgroundColor = UIColor.white
    for subview in controller.view.subviews {
      subview.alpha = 1.0
    }
    activityIndicator.stopAnimating()
  }
  
  // MARK: startGrayAcitivityIndicator
  func startGrayAcitivtyIndicator(_ activityIndicator: UIActivityIndicatorView, for controller: UIViewController) {
    activityIndicator.center = controller.view.center
    activityIndicator.hidesWhenStopped = true
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
    controller.view.addSubview(activityIndicator)
    activityIndicator.startAnimating()
  }
  
  // MARK: stopGrayAcitivityIndicator
  func stopGrayActivityIndicator(_ activityIndicator: UIActivityIndicatorView, for controller: UIViewController) {
    activityIndicator.stopAnimating()
  }
  
}
