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
  
  //let mapString: String?
  //let mediaURL: String?
  //let latitude: Double?
  //let longitude: Double?
  
  // MARK: Initializers
  init(dictionary: [String:AnyObject]) {
    userID = dictionary[UdacityClient.JSONResponseKeys.UniqueKey] as! String
    firstName = dictionary[UdacityClient.JSONResponseKeys.FirstName] as! String
    lastName = dictionary[UdacityClient.JSONResponseKeys.LastName] as! String
  }
  
  static func studentInfoFromResults(_ result: [String:AnyObject]) -> UdacityStudent {
    var student = UdacityStudent(dictionary: [:])
    student = UdacityStudent(dictionary: result)
    return student
  }
  
}
