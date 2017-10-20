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
  var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
  let lighterBlue = UIColor(red: 0.012, green: 0.706, blue: 0.898, alpha: 1.0)
  let fbColor = UIColor(red: 0.229, green: 0.345, blue: 0.595, alpha: 1.0)
  
  // MARK: Outlets
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loginButton: BorderedButton!
  @IBOutlet weak var fbLoginButton: BorderedButton!
  
  @IBOutlet weak var scrollView: UIScrollView!
  
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    //subscribeToKeyboardNotifications()
  }
  
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    //unsubscribeFromKeyboardNotifications()
  }
  
  // MARK: Complete Login
  
  private func completeLogin() {
    let controller = storyboard!.instantiateViewController(withIdentifier: "MasterNavigationController") as! UINavigationController
    present(controller, animated: true, completion: nil)
  }
  
  // TextField validation
  private func checkTextfieldsEmpty() -> Bool {
    if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
      return true
    } else {
      return false
    }
  }
  
  
  // Keyboard hide or show
  
  @objc func keyboardWillShow(_ notification:Notification) {
    if passwordTextField.isFirstResponder{
      if (UIDeviceOrientation.landscapeLeft.isLandscape || UIDeviceOrientation.landscapeRight.isLandscape) {
      view.frame.origin.y = -getKeyboardHeight(notification)
    }
    }
  }
  
  @objc func keyboardWillHide(_ notification:Notification) {
    view.frame.origin.y = 0
  }
  
  // MARK: Get Keyboard Height
  func getKeyboardHeight(_ notification:Notification) -> CGFloat {
    let userInfo = notification.userInfo
    let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
    return keyboardSize.cgRectValue.height * 0.25
  }
  
  // MARK: Subscribe to Keyboard Notifications
  func subscribeToKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
  }
  // MARK: Unsubscribe to Keyboard Notifications
  func unsubscribeFromKeyboardNotifications() {
    NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
  }
  
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField == passwordTextField {
      print("Password textfield begin editing")
      scrollView.setContentOffset(CGPoint(x:0,y:250), animated: true)
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField == passwordTextField {
      print("Password textfield editing ended.")
      scrollView.setContentOffset(CGPoint(x:0,y:0), animated: true)
    }
  }

}

// MARK: - LoginViewController (Configure UI)

extension LoginViewController {
  
  // MARK: configure
  func configure() {
    usernameTextField.delegate = self
    passwordTextField.delegate = self
    fbLoginButton.setBackingColor(fbColor)
  }
  
  // Reset UIView
  private func resetControls() {
    if activityIndicator.isAnimating {
      stopActivityIndicator(for: self, activityIndicator)
    }
    usernameTextField.text = nil
    passwordTextField.text = nil
    loginButton.setBackingColor(lighterBlue)
  }
  
  // display error
  func displayError(_ errorString: String?) {
    if let errorString = errorString {
      showAlert("Error", message: errorString)
    }
  }
}

// MARK: - FBSDKLoginButtonDelegate

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
