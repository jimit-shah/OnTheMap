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
        self.sessionID = sessionID
        self.userID = uniqueKey
        //get the public onformation -> first name and last name
        
        // object of uDacityStudent ->
        // .shared.udacitystudent = uDacityStudent
        print("SessionID: \(sessionID!)")
        print("UniqueKey(UserID): \(uniqueKey!)")
        completionHandlerForAuth(success, nil)
      } else {
        completionHandlerForAuth(success, errorString)
      }
      
    }
  }
  
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
        completionHandlerForSession(true, sessionID, uniqueKey, nil)
      } else {
        print("Could not find \(UdacityClient.JSONResponseKeys.SessionID) in \(results!)")
        completionHandlerForSession(false, nil, nil, "Login Failed (Session ID).")
      }
    }
  }
  
  // MAR: Public User Data (GET) Method
  func getUserInfo(_ userID: String, _ completionHandlerForGetUserInfo: @escaping (_ success: Bool, _ userData: UdacityStudent?, _ errorString: String?) -> Void) {
    let parameters = [String:AnyObject]()
    
    let _ = taskForGETMethod(Methods.Get, parameters: parameters as [String:AnyObject]) { ( results, error) in
    
      if let error = error {
        print(error)
        completionHandlerForGetUserInfo(false, nil, "Couldn't Get User Info.")
      }
    } //WORK...IN...Process...
  
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
