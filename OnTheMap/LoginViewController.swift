//
//  ViewController.swift
//  OnTheMap
//
//  Created by Jimit Shah on 7/30/17.
//  Copyright © 2017 Jimit Shah. All rights reserved.
//

import UIKit

// MARK: - LoginViewController: UIViewController

class LoginViewController: UIViewController {
  
  // MARK: Properties
  
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  // MARK: Actions
  
  @IBAction func loginPressed(_ sender: Any) {
    
    if checkTextfieldsEmpty() {
      notifyUser(nil, message: "Email or Password Empty.")
    } else {
      UdacityClient.sharedInstance().authenticateWithLogin(usernameTextField.text!, passwordTextField.text!) { (success, errorString) in
        performUIUpdatesOnMain {
          if success {
            self.completeLogin()
            print("Login Success!")
            
            // reset textfields after successfully login.
            self.resetControls()
            
          } else {
            //self.displayError(errorString)
            self.notifyUser(nil, message: "Invalid Email or Password.")
          }
        }
      }
    }
  }
  
  // Open Sign up page in Safari
  @IBAction func signupPressed(_ sender: Any) {
    let urlString = UdacityClient.Constants.SignupPath
    let url = URL(string: urlString)
    
    if UIApplication.shared.canOpenURL(url!) {
      UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
  }
  
  
  // MARK: Login
  
  private func completeLogin() {
    let controller = storyboard!.instantiateViewController(withIdentifier: "MasterNavigationController") as! UINavigationController
    present(controller, animated: true, completion: nil)
  }
  
  private func checkTextfieldsEmpty() -> Bool {
    if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
      return true
    } else {
      return false
    }
  }
  
  private func resetControls() {
    usernameTextField.text = nil
    passwordTextField.text = nil
  }
}

// MARK: - LoginViewController (Configure UI)

private extension LoginViewController {
  
  func displayError(_ errorString: String?) {
    if let errorString = errorString {
      print(errorString)
    }
  }
  
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
