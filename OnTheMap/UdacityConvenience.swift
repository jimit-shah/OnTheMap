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
    self.postSessionId(username, password) { (success, sessionID, errorString) in
      
      if success {
        self.sessionID = sessionID
        print("SessionID: \(sessionID!)")
        completionHandlerForAuth(success, nil)
      } else {
        completionHandlerForAuth(success, errorString)
      }
      
    }
  }
  
  func postSessionId(_ username: String, _ password: String, _ completionHandlerForSession: @escaping (_ success: Bool, _ sessionID: String?, _ errorString: String?) -> Void) {
    
    
    let parameters = [String:AnyObject]()
    
    let jsonBody = "{\"udacity\": {\"\(UdacityClient.JSONBodyKeys.Username)\": \"\(username)\", \"\(UdacityClient.JSONBodyKeys.Password)\": \"\(password)\"}}"
    
    let _ = taskForPOSTMethod(Methods.Session, parameters: parameters as [String:AnyObject], jsonBody: jsonBody) { (results, error) in
      
      if let error = error {
        print(error)
        completionHandlerForSession(false, nil, "Login Failed (Session ID).")
      } else if let session = results?[UdacityClient.JSONResponseKeys.Session] as? [String:AnyObject] {
        let sessionID = session[UdacityClient.JSONResponseKeys.SessionID] as? String
        completionHandlerForSession(true, sessionID, nil)
      } else {
        print("Could not find \(UdacityClient.JSONResponseKeys.SessionID) in \(results!)")
        completionHandlerForSession(false, nil, "Login Failed (Session ID).")
      }
    }
  }
  
  // MARK: Logout (DELETE) Method
  
  func sessionLogout(_ completionHandlerForLogout: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
    self.deleteSessionId { (success, sessionID, errorString) in
      
      if success {
        print("Logout Success for SessionID: \(sessionID!)")
        self.sessionID = nil
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
