//
//  ViewController.swift
//  OnTheMap
//
//  Created by Jimit Shah on 7/30/17.
//  Copyright © 2017 Jimit Shah. All rights reserved.
//

import UIKit
import FBSDKLoginKit

// MARK: - LoginViewController: UIViewController

class LoginViewController: UIViewController {
  
  // MARK: Properties
  
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loginButton: BorderedButton!
  @IBOutlet weak var fbLoginButton: BorderedButton!
  
  var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
  let lighterBlue = UIColor(red: 0.012, green: 0.706, blue: 0.898, alpha: 1.0)
  let fbColor = UIColor(red: 0.229, green: 0.345, blue: 0.595, alpha: 1.0)
  
  // MARK: Text Field Delegate object
  let textFieldDelegate = TextFieldDelegate()
  
  // MARK: Actions
  
  // Facebook login
  @IBAction func loginWithFacebook(_ sender: Any) {
    startActivityIndicator(for: self, activityIndicator, .gray)
    let readPermissions = ["public_profile"]
    let loginManager = FBSDKLoginManager()
    loginManager.logIn(withReadPermissions: readPermissions, from: self) { (result, error) in
      if ((error) != nil){
        self.showAlert("Login Failed", message: "Error: \(String(describing: error))")
        self.stopActivityIndicator(for: self, self.activityIndicator)
      } else if (result?.isCancelled)! {
        self.showAlert("Login Canceled", message: "Login with Facebook Canceled.")
        self.stopActivityIndicator(for: self, self.activityIndicator)
      } else {
        guard let result = result else {
          return
        }
        UdacityClient.sharedInstance().authenticateWithFBLogin(result.token.tokenString) { (success, errorString) in
          if success {
            performUIUpdatesOnMain {
              self.stopActivityIndicator(for: self, self.activityIndicator)
              self.completeLogin()
            }
          } else {
            performUIUpdatesOnMain {
              self.stopActivityIndicator(for: self, self.activityIndicator)
              self.showAlert("Login Failed", message: "POST to Udacity Session with Facebook Failed: \(errorString!)")
            }
          }
        }
      }
    }
  }
  
  // Udacity Login
  @IBAction func loginPressed(_ sender: Any) {
    startActivityIndicator(for: self, activityIndicator, .gray)
    if checkTextfieldsEmpty() {
      showAlert(nil, message: "Email or Password Empty.")
      stopActivityIndicator(for: self, activityIndicator)
    } else {
      UdacityClient.sharedInstance().authenticateWithLogin(usernameTextField.text!, passwordTextField.text!) { (success, errorString) in
        performUIUpdatesOnMain {
          if success {
            self.completeLogin()
            self.resetControls()
          } else {
            self.showAlert(nil, message: "Invalid Email or Password.")
            self.resetControls()
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
  
  
  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
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
    if activityIndicator.isAnimating {
      stopActivityIndicator(for: self, activityIndicator)
    }
    usernameTextField.text = nil
    passwordTextField.text = nil
    loginButton.setBackingColor(lighterBlue)
  }
}

// MARK: - LoginViewController (Configure UI)

private extension LoginViewController {
  
  func displayError(_ errorString: String?) {
    if let errorString = errorString {
      print(errorString)
    }
  }
  
  // MARK: configure
  func configure() {
    usernameTextField.delegate = textFieldDelegate
    passwordTextField.delegate = textFieldDelegate
    fbLoginButton.setBackingColor(fbColor)
  }
  
}

// MARK: - LoginViewController: FBSDKLoginButtonDelegate
extension LoginViewController: FBSDKLoginButtonDelegate {
  
  public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith
    result: FBSDKLoginManagerLoginResult!, error: Error!) {
    guard error != nil else {
      showAlert("Login with Facebook Failed", message: "Error: \(error)")
      return
    }
  }
  
  
  public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    // On logout, we just remain on the login view controller
  }
}
