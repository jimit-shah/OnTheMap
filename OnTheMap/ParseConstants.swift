//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Jimit Shah on 8/5/17.
//  Copyright © 2017 Jimit Shah. All rights reserved.
//

import Foundation


extension ParseClient {
  
  // MARK: Constants
  struct Constants {
    
    // MARK: API Key
    static let ApiKey = "API Key Here"
    static let ApplicationID = "Application ID here"
    
    // MARK: URLs
    static let ApiScheme = "https"
    static let ApiHost = "parse.udacity.com"
    static let ApiPath = "/parse/classes/StudentLocation"
    
  }
  
  // MARK: Methods
  struct Methods {
    
    // MARK: Student Locations
    static let StudentLocations = "/StudentLocation"
    static let StudentLocation =  "/StudentLocation?where={\"uniqueKey\":value}"
  }
  
  // MARK: URL Keys
  struct URLKeys {
    static let UniqueKey = "uniqueKey"
  }
  
  // MARK: Parameter Keys
  struct ParameterKeys {
    static let ApiKey = "X-Parse-REST-API-Key"
    static let ApplicationID = "X-Parse-Application-Id"
    static let SessionID = "session_id"
    static let RequestToken = "request_token"
    static let Query = "query"
  }
  
  // MARK: JSON Body Keys
  struct JSONBodyKeys {
    
  }
  
  // MARK: JSON Response Keys
  struct JSONResponseKeys {
    
    // MARK: General
    static let StatusMessage = "status_message"
    static let StatusCode = "status_code"
    
    // MARK: UniqueKey
    static let UniqueKey = "uniqueKey"
    
    // MARK: Students
    static let StudentMediaURL = "mediaURL"
    static let StudentObjectId = "objectId"
    static let StudentMapString = "mapString"
    static let StudentFirstName = "firstName"
    static let StudentLastName = "lastName"
    static let StudentUniqueKey = "uniqueKey"
    static let StudentLatitude = "latitude"
    static let StudentLongitude = "longitude"
    static let StudentResults = "results"
  }
  
  
  
  
  
}
