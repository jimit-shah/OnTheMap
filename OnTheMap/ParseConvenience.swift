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
  
  func postToStudentLocation(_ student: ParseStudent, _ completionHandlerForLocationPost: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
    let parameters = [String:AnyObject]()
    
    let userID = ParseClient.sharedInstance().userID!
    
    let dictionary: [String:AnyObject] = [
      ParseClient.JSONBodyKeys.UniqueKey: userID as AnyObject,
      "\(ParseClient.JSONBodyKeys.FirstName)": student.firstName as AnyObject,
      "\(ParseClient.JSONBodyKeys.LastName)": student.lastName as AnyObject,
      "\(ParseClient.JSONBodyKeys.MapString)": student.mapString as AnyObject,
      "\(ParseClient.JSONBodyKeys.MediaURL)": student.mediaURL as AnyObject,
      "\(ParseClient.JSONBodyKeys.Latitude)": student.latitude as AnyObject,
      "\(ParseClient.JSONBodyKeys.Longitude)": student.longitude as AnyObject
    ]
    
    let jsonBody = convertDictionaryToJSONString(dictionary: dictionary)!
    
    // Make the request
    let _ = taskForPOSTMethod(Methods.StudentLocation, parameters: parameters, jsonBody: jsonBody) { (results, error) in
      
      if let error = error {
        completionHandlerForLocationPost(false, error)
      } else {
        if let _ = results?[ParseClient.JSONResponseKeys.StudentObjectId] as? String {
          completionHandlerForLocationPost(true, nil)
        } else {
          completionHandlerForLocationPost(false, NSError(domain: "postToStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postToStudentLocation"]))
        }
      }
    }
  }
  
  
  // MARK: PUT Convenience Methods
  
  func putToStudentLocation(_ objectID: String, _ student: ParseStudent, _ completionHandlerForLocationPut: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
    
    let parameters = [String:AnyObject]()
    let dictionary: [String:AnyObject] = [
      ParseClient.JSONBodyKeys.UniqueKey: userID as AnyObject,
      "\(ParseClient.JSONBodyKeys.FirstName)": student.firstName as AnyObject,
      "\(ParseClient.JSONBodyKeys.LastName)": student.lastName as AnyObject,
      "\(ParseClient.JSONBodyKeys.MapString)": student.mapString as AnyObject,
      "\(ParseClient.JSONBodyKeys.MediaURL)": student.mediaURL as AnyObject,
      "\(ParseClient.JSONBodyKeys.Latitude)": student.latitude as AnyObject,
      "\(ParseClient.JSONBodyKeys.Longitude)": student.longitude as AnyObject
    ]
    
    let jsonBody = convertDictionaryToJSONString(dictionary: dictionary)!
    
    var mutableMethod: String = Methods.Put
    mutableMethod = substituteKeyInMethod(mutableMethod, key: ParseClient.URLKeys.ObjectID, value: objectID)!
    // Make the request
    let _ = taskForPOSTMethod(mutableMethod, parameters: parameters, jsonBody: jsonBody) { (results, error) in
      
      if let error = error {
        completionHandlerForLocationPut(false, error)
      } else {
        if let _ = results?[ParseClient.JSONResponseKeys.StudentObjectId] as? String {
          completionHandlerForLocationPut(true, nil)
        } else {
          completionHandlerForLocationPut(false, NSError(domain: "putToStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse putToStudentLocation"]))
        }
      }
    }
    
  }

}
