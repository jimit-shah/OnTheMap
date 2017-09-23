//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Jimit Shah on 8/5/17.
//  Copyright © 2017 Jimit Shah. All rights reserved.
//

import UIKit


// MARK: - ParseClient: NSObject

class ParseClient: NSObject {
  
  // MARK: - Properties
  
  // shared session
  var session = URLSession.shared
  
  // configuration object
  var config = ParseConfig()
  
  // authentication state
  var requestToken: String? = nil
  var sessionID: String? = nil
  var userID: String? = nil
  
  // MARK: - Initializers
  
  override init() {
    super.init()
  }
  
  // MARK: GET
  
  func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
    
    // 1. Set the parameters
    var parametersWithKeys = parameters
    
    // 2/3. Build the URL, Configure the request
    let request = NSMutableURLRequest(url: parseURLFromParameters(parametersWithKeys, withPathExtension: method))
    request.addValue(Constants.ApiKey, forHTTPHeaderField: ParameterKeys.ApiKey)
    request.addValue(Constants.ApplicationID, forHTTPHeaderField: ParameterKeys.ApplicationID)
    
    // 4. Make the requeset
    let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
      
      func sendError(_ error: String) {
        print(error)
        let userInfo = [NSLocalizedDescriptionKey : error]
        completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
      }
      
      // GUARD: Was there an error?
      guard (error == nil) else {
        sendError("There was an error with your request: \(error!)")
        return
      }
      
      // GUARD: Did we get a successful 2XX response?
      guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
        sendError("Your request returned a status code other than 2xx!")
        return
      }
      
      // GUARD: Was there any data returned?
      guard let data = data else {
        sendError("No data was returned by the GET request!")
        return
      }
      
      // 5/6. Parse the data and use the data (happens in completion handler)
      self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
      
    }
    
    // 7. Start the request
    task.resume()
    
    return task
    
  }
  
  // MARK: POST
  
  func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?)-> Void) -> URLSessionDataTask {
    
    var parametersWithApiKey = parameters
    
    // Build URL (configure request)
    let request = NSMutableURLRequest(url: parseURLFromParameters(parametersWithApiKey, withPathExtension: method))
    request.httpMethod = "POST"
    request.addValue(Constants.ApiKey, forHTTPHeaderField: ParameterKeys.ApiKey)
    request.addValue(Constants.ApplicationID, forHTTPHeaderField: ParameterKeys.ApplicationID)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonBody.data(using: String.Encoding.utf8)
    
    // Make the request
    let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
      
      func sendError(_ error: String) {
        print(error)
        let userInfo = [NSLocalizedDescriptionKey : error]
        completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
      }
      guard error == nil else {
        sendError("There was an error with your request: \(error!)")
        return
      }
      
      guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
        sendError("Your request returned a status code other than 2xx!")
        return
      }
      
      guard let data = data else {
        sendError("No data was returned by the request!")
        return
      }
      
      self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
    }
    
    // start the request
    task.resume()
    
    return task
  }
  
  // MARK: Helpers
  
  // substitue the key for the value that is contained within the method name
  func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
    if method.range(of: "{\(key)}") != nil {
      return method.replacingOccurrences(of: "{\(key)}", with: value)
    } else {
      return nil
    }
  }
  
  // given raw JSON, return a usable Foundation object
  private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
    
    var parsedResult: AnyObject! = nil
    do {
      parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
    } catch {
      let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: '\(data)'"]
      completionHandlerForConvertData(nil, NSError(domain: "converDataWithCompletionHandler", code: 1, userInfo: userInfo))
    }
    
    completionHandlerForConvertData(parsedResult, nil)
    
  }
  
  // create a URL from parameters
  private func parseURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
    var components = URLComponents()
    components.scheme = ParseClient.Constants.ApiScheme
    components.host = ParseClient.Constants.ApiHost
    components.path = ParseClient.Constants.ApiPath + (withPathExtension ?? "")
    components.queryItems = [URLQueryItem]()
    
    for (key, value) in parameters {
      let queryItem = URLQueryItem(name: key, value: "\(value)")
      components.queryItems!.append(queryItem)
    }
    
    // print url for the request
    print("url: \(String(describing: components.url))")
    
    return components.url!
    
  }
  
  // MARK: Shared Instance
  
  class func sharedInstance() -> ParseClient {
    struct Singleton {
      static var sharedInstance = ParseClient()
    }
    return Singleton.sharedInstance
  }
  
}
