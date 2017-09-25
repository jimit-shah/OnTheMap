//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Jimit Shah on 7/30/17.
//  Copyright © 2017 Jimit Shah. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
  
  // MARK: Properties
  
  // the data for the table
  var students = [ParseStudent]()
  var firstName = "No First Name"
  var lastName = "No Last Name"
  
  // MARK: Outlets
  @IBOutlet weak var studentsTableView: UITableView!
  
  // MARK: Life cycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    studentsTableView.reloadData()
  }
  
}

// MARK: - ListViewController: UITableViewDataSource, UITableViewDelegate

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cellReuseIdentifier = "LocationCell"
    let student = students[(indexPath as NSIndexPath).row]
    let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
    
    if let studentFirstName = student.firstName {
      firstName = studentFirstName
    }
    
    if let studentLastName = student.lastName {
      lastName = studentLastName
    }
    
    cell?.textLabel!.text = "\(firstName) \(lastName)"
    cell?.detailTextLabel!.text = student.mediaURL
    
    return cell!
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return students.count
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let student = students[(indexPath as NSIndexPath).row]
    
    if let urlString = student.mediaURL {
      if let url = URL(string: urlString) {
        
        if UIApplication.shared.canOpenURL(url) {
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
          notifyUser(nil, message: "Invalid Link")
        }
        
      }
      
    }
  }
  
}

// MARK: - ListViewController (Configure UI)

private extension ListViewController {
  
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
  

