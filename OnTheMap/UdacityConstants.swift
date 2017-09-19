//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Jimit Shah on 8/8/17.
//  Copyright © 2017 Jimit Shah. All rights reserved.
//

import Foundation

extension UdacityClient {
  
  // MARK: Constants
  struct Constants {
    
    // MARK: URLs
    static let ApiScheme = "https"
    static let ApiHost = "www.udacity.com"
    static let ApiPath = "/api"
    static let SignupPath = "https://www.udacity.com/account/auth#!/signup"
    //https://www.udacity.com/api/users/
  }
  
  // MARK: Methods
  struct Methods {
    
    // MARK: Authentication
    static let Session = "/session"
    static let Get = "/users"
  }
  
  // MARK: Parameter Keys
  struct ParameterKeys {
    static let SessionID = "session_id"
  }
  
  // MARK: JSON Body Keys
  struct JSONBodyKeys {
    static let Username = "username"
    static let Password = "password"
  }
  
  // MARK: JSON Response Keys
  struct JSONResponseKeys {
    
    // MARK: General
    static let StatusMessage = "status_message"
    static let StatusCode = "status_code"
    
    // MARK: Authorization
    static let Account = "account"
    static let Session = "session"
    static let SessionID = "id"
    static let UniqueKey = "key"
    static let FirstName = "firstname"
    static let LastName = "lastname"
    //static let mapString = "location"
    //static let Latitude = "latitude"
    //static let Longitude = "longitude"
    //static let Url = "website_url"
    
    //Example post to the Udacity
      //{"uniqueKey": "1234", "firstName": "John", "lastName": "Doe","mapString": "Mountain View, CA", "mediaURL": "//https://udacity.com","latitude": 37.386052, "longitude": -122.083851}
    
  }
  
  
}
