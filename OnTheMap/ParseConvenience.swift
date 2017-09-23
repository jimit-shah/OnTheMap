//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Jimit Shah on 8/13/17.
//  Copyright © 2017 Jimit Shah. All rights reserved.
//

import Foundation


extension ParseClient {
  
  func getStudentLocations(_ completionHandlerForStudentLocations: @escaping (_ result: [ParseStudent]?, _ error: NSError?) -> Void) {
    
    var parametersWithKeys = [String:AnyObject]()
    parametersWithKeys[ParameterKeys.Limit] = "100" as AnyObject?
    parametersWithKeys[ParameterKeys.Order] = "-updatedAt" as AnyObject?
    
    let _ = taskForGETMethod(Methods.StudentLocation, parameters: parametersWithKeys) { (results, error) in
      
      if let error = error {
        completionHandlerForStudentLocations(nil, error)
      } else {
        
        if let results = results?[ParseClient.JSONResponseKeys.StudentResults] as? [[String:AnyObject]] {
          
          let students = ParseStudent.studentsFromResults(results)
          completionHandlerForStudentLocations(students, nil)
        } else {
          completionHandlerForStudentLocations(nil, NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
        }
      }
    }
    
  }
  
  func getStudentLocation(_ userID: String, _ completionHandlerForStudentLocation: @escaping (_ result: ParseStudent?, _ error: NSError?) -> Void) {
    
    var parametersWithKeys = [String:AnyObject]()
    parametersWithKeys[ParameterKeys.Where] = "{\"uniqueKey\":\"\(userID)\"}" as AnyObject?
    //"{\"uniqueKey\":\"\(User.sharedUser().uniqueKey)\"}"
    
    let _ = taskForGETMethod(Methods.StudentLocation, parameters: parametersWithKeys) { (results, error) in
      
      if let error = error {
        completionHandlerForStudentLocation(nil, error)
      } else {
        
        if let results = results?[ParseClient.JSONResponseKeys.StudentResults] as? [[String:AnyObject]] {
          
          // only select first location if multiple records are found for a user.
          if results.isEmpty {
            print("No Location Data found for user!")
            completionHandlerForStudentLocation(nil, nil)
          } else if let result = results.first {
            let student = ParseStudent.studentFromResults(result)
            completionHandlerForStudentLocation(student, nil)
          }
        } else {
          completionHandlerForStudentLocation(nil, NSError(domain: "getStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocation"]))
        }
      }
    }
  }
  
  // MARK: POST Convenience Methods
  
  func postToStudentLocation(_ student: ParseStudent, _ completionHandlerForLocationPost: @escaping (_ result: Int?, _ error: NSError?) -> Void) {
    let parameters = [String:AnyObject]()
    
//    let userID = ParseClient.sharedInstance().userID as! String
//    let dictionary: [String:AnyObject] = [
//      "\(ParseClient.JSONBodyKeys.UniqueKey)": userID,
//      "\(ParseClient.JSONBodyKeys.FirstName)": student.firstName,
//      "\(ParseClient.JSONBodyKeys.LastName)": student.lastName,
//      "\(ParseClient.JSONBodyKeys.MapString)": student.mapString,
//      "\(ParseClient.JSONBodyKeys.MediaURL)": student.mediaURL,
//      "\(ParseClient.JSONBodyKeys.Latitude)": student.latitude,
//      "\(ParseClient.JSONBodyKeys.Longitude)": student.longitude
//    ]

    let jsonBody = "{\"\(ParseClient.JSONBodyKeys.UniqueKey)\": \"\(userID)\", \"\(ParseClient.JSONBodyKeys.FirstName)\": \"\(student.firstName)\", \"\(ParseClient.JSONBodyKeys.LastName)\": \(student.lastName)\", \"\(ParseClient.JSONBodyKeys.MapString)\": \"\(student.mapString)\", \"\(ParseClient.JSONBodyKeys.MediaURL)\": \(student.mediaURL)\", \"\(ParseClient.JSONBodyKeys.Latitude)\": \"\(student.latitude)\", \"\(ParseClient.JSONBodyKeys.Longitude)\": \(student.longitude)}"


    // Make the request
    let _ = taskForPOSTMethod(Methods.StudentLocation, parameters: parameters, jsonBody: jsonBody) { (results, error) in
      
      if let error = error {
        completionHandlerForLocationPost(nil, error)
      } else {
        if let results = results?[ParseClient.JSONResponseKeys.StatusCode] as? Int {
          completionHandlerForLocationPost(results, nil)
        } else {
          completionHandlerForLocationPost(nil, NSError(domain: "postToStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postToStudentLocation"]))
        }
      }
    }
  }
  
  
}
