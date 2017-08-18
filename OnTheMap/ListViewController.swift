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
  
  @IBOutlet weak var studentsTableView: UITableView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    ParseClient.sharedInstance().getStudentLocations{(students, error) in
      
      if let students = students {
        self.students = students
        performUIUpdatesOnMain {
          self.studentsTableView.reloadData()
        }
      } else {
        print(error ?? "empty error")
      }
    }
    
  }
  
}

// MARK: - ListViewController: UITableViewDataSource
extension ListViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cellReuseIdentifier = "LocationCell"
    let student = students[(indexPath as NSIndexPath).row]
    let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
    
    cell?.textLabel!.text = "\(student.firstName) \(student.lastName)"
    cell?.detailTextLabel!.text = student.mediaURL
    
    return cell!
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return students.count
  }
}
