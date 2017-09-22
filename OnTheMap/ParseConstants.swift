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
    
    // MARK: API Keys
    static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    
    // MARK: URLs
    static let ApiScheme = "https"
    static let ApiHost = "parse.udacity.com"
    static let ApiPath = "/parse/classes"
    
  }
  
  // MARK: Methods
  struct Methods {
    
    // MARK: Student Location
    static let StudentLocation = "/StudentLocation"
    //static let StudentLocationForStudent =  "/StudentLocation?where={\"uniqueKey\":value}" /* NOTE SURE ABOUT THIS */
    
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
    static let Where = "where"
    static let Query = "query"
    static let Limit = "limit"
    static let Order = "order"
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
