//
//  UdacityStudent.swift
//  OnTheMap
//
//  Created by Jimit Shah on 9/18/17.
//  Copyright © 2017 Jimit Shah. All rights reserved.
//

import Foundation

struct UdacityStudent {
  
  let userID: String
  let firstName: String
  let lastName: String
  
  // MARK: Initializers
  init(dictionary: [String:AnyObject]) {
    userID = dictionary[UdacityClient.JSONResponseKeys.UniqueKey] as! String
    firstName = dictionary[UdacityClient.JSONResponseKeys.FirstName] as! String
    lastName = dictionary[UdacityClient.JSONResponseKeys.LastName] as! String
  }
  // Method to initialize and return data.
  static func studentInfoFromResults(_ result: [String:AnyObject]) -> UdacityStudent {
    let student: UdacityStudent
    student = UdacityStudent(dictionary: result)
    return student
  }
  
}
