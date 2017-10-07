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
  @IBOutlet weak var loginButton: UIButton!
  
  var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
  
  // MARK: Text Field Delegate object
  let textFieldDelegate = TextFieldDelegate()
  
  // MARK: Actions
  
  // Facebook login
  @IBAction func loginWithFacebook(_ sender: Any) {
    let readPermissions = ["public_profile"]
    let loginManager = FBSDKLoginManager()
    loginManager.logIn(withReadPermissions: readPermissions, from: self) { (result, error) in
      if ((error) != nil){
        self.showAlert("Login Failed", message: "Error: \(String(describing: error))")
      } else if (result?.isCancelled)! {
        self.showAlert("Login Canceled", message: "Login with Facebook Canceled.")
      } else {
        //present the next view controller
        //self.presentWithSegueIdentifier("showAccount",animated: true)
        self.completeLogin()
      }
    }
  }
  
  // Udacity Login
  @IBAction func loginPressed(_ sender: Any) {
    startGrayAcitivtyIndicator(activityIndicator, for: self)
    if checkTextfieldsEmpty() {
      showAlert(nil, message: "Email or Password Empty.")
    } else {
      UdacityClient.sharedInstance().authenticateWithLogin(usernameTextField.text!, passwordTextField.text!) { (success, errorString) in
        performUIUpdatesOnMain {
          if success {
            self.completeLogin()
            self.stopGrayActivityIndicator(self.activityIndicator, for: self)
            // reset textfields after successfully login.
            self.resetControls()
            
          } else {
            self.showAlert(nil, message: "Invalid Email or Password.")
            self.stopGrayActivityIndicator(self.activityIndicator, for: self)
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
    configureTextFields()
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
  
  // MARK: configure
  func configureTextFields() {
    usernameTextField.delegate = textFieldDelegate
    passwordTextField.delegate = textFieldDelegate
  }
  
}

// MARK: - LoginViewController: FBSDKLoginButtonDelegate
extension LoginViewController: FBSDKLoginButtonDelegate {
  
  public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith
    result: FBSDKLoginManagerLoginResult!, error: Error!) {
    if let error = error {
      showAlert("Login with Facebook Failed", message: "Error: \(error)")
    }
    // The FBSDKAccessToken is expected to be available, so we can let the user in.
    if result.token != nil {
      
      //user name password token -> UDacity API
      completeLogin()
      //presentWithSegueIdentifier("MasterNavigationController", animated: true)
    }
  }
  
  public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    // On logout, we just remain on the login view controller
  }
}
