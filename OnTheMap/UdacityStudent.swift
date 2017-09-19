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
    
    //mapString = dictionary[UdacityClient.JSONResponseKeys.mapString] as? String
    //mediaURL = dictionary[UdacityClient.JSONResponseKeys.Url] as? String
    //latitude = dictionary[UdacityClient.JSONResponseKeys.Latitude] as? Double
    //longitude = dictionary[UdacityClient.JSONResponseKeys.Longitude] as? Double
  }
  
  func studentInformation(_ result: [String:AnyObject]) -> UdacityStudent {
    var student: UdacityStudent
    student = UdacityStudent(dictionary: result)
    return student
  }
  
}
