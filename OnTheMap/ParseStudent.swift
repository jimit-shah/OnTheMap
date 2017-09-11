//
//  ParseStudent.swift
//  OnTheMap
//
//  Created by Jimit Shah on 8/5/17.
//  Copyright © 2017 Jimit Shah. All rights reserved.
//

import Foundation


struct ParseStudent {
  
  // MARK: Properties
  
  let firstName: String?
  let lastName: String?
  let mediaURL: String?
  let latitude: Double
  let longitude: Double
  
  // MARK: Initializers
  init(dictionary: [String:AnyObject]) {
    firstName = dictionary[ParseClient.JSONResponseKeys.StudentFirstName] as? String
    lastName = dictionary[ParseClient.JSONResponseKeys.StudentLastName] as? String
    mediaURL = dictionary[ParseClient.JSONResponseKeys.StudentMediaURL] as? String
    latitude = dictionary[ParseClient.JSONResponseKeys.StudentLatitude] as! Double
    longitude = dictionary[ParseClient.JSONResponseKeys.StudentLongitude] as! Double
  }
  
  static func studentsFromResults(_ results: [[String:AnyObject]]) -> [ParseStudent] {
    var students = [ParseStudent]()
    
    // iterate through array of dictionaries, each Student is a dictionary
    
    for result in results {
      
      // check if lat or long are provided otherwise do not add student.
      if let _ = result["latitude"] as? Double, let _ = result["longitude"] as? Double {
        students.append(ParseStudent(dictionary: result))
      }
      
    }
    
    return students
  }
  
}
