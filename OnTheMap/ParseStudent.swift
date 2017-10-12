//
//  ParseStudent.swift
//  OnTheMap
//
//  Created by Jimit Shah on 8/5/17.
//  Copyright © 2017 Jimit Shah. All rights reserved.
//

import Foundation

// MARK: ParseStudent

struct ParseStudent {
  
  // MARK: Properties
  let userID: String?
  let firstName: String?
  let lastName: String?
  let mediaURL: String?
  let latitude: Double
  let longitude: Double
  let mapString: String?
  let objectID: String?
  
  // MARK: Initializers
  init(dictionary: [String:AnyObject]) {
    userID = dictionary[ParseClient.JSONResponseKeys.StudentUniqueKey] as? String
    firstName = dictionary[ParseClient.JSONResponseKeys.StudentFirstName] as? String
    lastName = dictionary[ParseClient.JSONResponseKeys.StudentLastName] as? String
    mediaURL = dictionary[ParseClient.JSONResponseKeys.StudentMediaURL] as? String
    latitude = dictionary[ParseClient.JSONResponseKeys.StudentLatitude] as! Double
    longitude = dictionary[ParseClient.JSONResponseKeys.StudentLongitude] as! Double
    mapString = dictionary[ParseClient.JSONResponseKeys.StudentMapString] as? String
    objectID = dictionary[ParseClient.JSONResponseKeys.StudentObjectId] as? String
  }
  
  // function to get and set result in ParseStudent array
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
  
  // function to get and store result for only one student
  static func studentFromResults(_ results: [String:AnyObject]) -> ParseStudent {
    return ParseStudent(dictionary: results)
  }
  
}
