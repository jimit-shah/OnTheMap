//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Jimit Shah on 8/9/17.
//  Copyright © 2017 Jimit Shah. All rights reserved.
//

import Foundation


// MARK: - UdacityClient (Convenient Resource Methods)

extension UdacityClient {
  
  // MARK: Authentication (POST) Methods
  
  func authenticateWithLogin(_ username: String, _ password: String, _ completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?)-> Void) {
    self.postSessionId(username, password) { (success, sessionID, uniqueKey, errorString) in
      
      if success {
        ParseClient.sharedInstance().sessionID = sessionID
        ParseClient.sharedInstance().userID = uniqueKey
        
        
        print("SessionID: \(sessionID!)")
        print("UniqueKey(UserID): \(uniqueKey!)")
        
        completionHandlerForAuth(success, nil)
      } else {
        completionHandlerForAuth(success, errorString)
      }
      
    }
  }
  
  // MARK: Session (POST) Method
  
  func postSessionId(_ username: String, _ password: String, _ completionHandlerForSession: @escaping (_ success: Bool, _ sessionID: String?, _ uniqueKey: String?, _ errorString: String?) -> Void) {
    
    
    let parameters = [String:AnyObject]()
    
    let jsonBody = "{\"udacity\": {\"\(UdacityClient.JSONBodyKeys.Username)\": \"\(username)\", \"\(UdacityClient.JSONBodyKeys.Password)\": \"\(password)\"}}"
    
    let _ = taskForPOSTMethod(Methods.Session, parameters: parameters as [String:AnyObject], jsonBody: jsonBody) { (results, error) in
      
      if let error = error {
        print(error)
        completionHandlerForSession(false, nil, nil, "Login Failed (Session ID).")
      } else if let session = results?[UdacityClient.JSONResponseKeys.Session] as? [String:AnyObject], let account = results?[UdacityClient.JSONResponseKeys.Account] as? [String:AnyObject] {
        
        let sessionID = session[UdacityClient.JSONResponseKeys.SessionID] as? String
        let uniqueKey = account[UdacityClient.JSONResponseKeys.UniqueKey] as? String
        
        print("SessionID = \(sessionID!)")
        print("UniqueKey = \(uniqueKey!)")
        
        completionHandlerForSession(true, sessionID, uniqueKey, nil)
      } else {
        print("Could not find \(UdacityClient.JSONResponseKeys.SessionID) in \(results!)")
        completionHandlerForSession(false, nil, nil, "Login Failed (Session ID).")
      }
    }
  }
  
  // MARK: Udacity Public User Data (GET) Method 
  
  func getUserInfo(_ completionHandlerForGetUserInfo: @escaping (_ result: UdacityStudent?, _ errorString: NSError?) -> Void) {
    
    let parameters = [String:AnyObject]()
    
    var mutableMethod: String = Methods.Get
    mutableMethod = substituteKeyInMethod(mutableMethod, key: UdacityClient.URLKeys.UserID, value: ParseClient.sharedInstance().userID!)!
    
    let _ = taskForGETMethod(mutableMethod, parameters: parameters as [String:AnyObject]) { ( results, error) in
    
      if let error = error {
        print(error)
        completionHandlerForGetUserInfo(nil, error)
      } else {
        if let results = results?[UdacityClient.JSONResponseKeys.UserResult] as? [String:AnyObject] {
          print("Result: \(results)")
            let student = UdacityStudent.studentInfoFromResults(results)
          
          print("Student: \(student)")
                  completionHandlerForGetUserInfo(student, nil)
        } else {
          completionHandlerForGetUserInfo(nil, NSError(domain: "getUserInfo parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "could not parse getUserInfo"]))
        }
      }
    }
  }
  
  
  // MARK: Logout (DELETE) Method
  
  func sessionLogout(_ completionHandlerForLogout: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
    self.deleteSessionId { (success, sessionID, errorString) in
      
      if success {
        print("Logout Success for SessionID: \(sessionID!)")
        ParseClient.sharedInstance().sessionID = nil
        completionHandlerForLogout(success, errorString)
      } else {
        completionHandlerForLogout(success, errorString)
      }
    }
  }
  
  func deleteSessionId(_ completionHandlerForDELETESession: @escaping (_ success: Bool, _ sessionID: String?,_ errorString: String?) -> Void) {
    
    let parameters = [String:AnyObject]()
    
    let _ = taskForDELETEMethod(Methods.Session, parameters: parameters as [String:AnyObject]) { (results, error) in
      
      if let error = error {
        print(error)
        completionHandlerForDELETESession(false, nil, "Logout Failed (Session ID).")
      } else if let session = results?[UdacityClient.JSONResponseKeys.Session] as? [String:AnyObject] {
        let sessionID = session[UdacityClient.JSONResponseKeys.SessionID] as? String
        completionHandlerForDELETESession(true, sessionID, nil)
      } else {
        print("Could not find \(UdacityClient.JSONResponseKeys.SessionID) in \(results!)")
        completionHandlerForDELETESession(false, nil, "Logout Failed (Session ID).")
      }
      
    }
    
  }
  
  
}
