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

  override func viewDidLoad() {
    super.viewDidLoad()
    
  }

  @IBAction func loginPressed(_ sender: Any) {
    completeLogin()
  }
  
  
  
  private func completeLogin() {
    let controller = storyboard!.instantiateViewController(withIdentifier: "MasterNavigationController") as! UINavigationController
    present(controller, animated: true, completion: nil)
  }
}

