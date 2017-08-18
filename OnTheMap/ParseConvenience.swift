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
    
    let parameters = [String:AnyObject]()
    
    let _ = taskForGETMethod(Methods.StudentLocation, parameters: parameters) { (results, error) in
      
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
  
  
  
}
