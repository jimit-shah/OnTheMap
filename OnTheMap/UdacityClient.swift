//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Jimit Shah on 8/9/17.
//  Copyright © 2017 Jimit Shah. All rights reserved.
//

import Foundation

import Foundation

// MARK: - TMDBClient: NSObject

class UdacityClient : NSObject {
  
  // MARK: Properties
  
  // shared session
  var session = URLSession.shared
  
  // authentication state
 // var sessionID: String? = nil
  //var userID: String? = nil
  var udacityStudnet: UdacityStudent? = nil
  
  
  // MARK: Initializers
  
  override init() {
    super.init()
  }
  
  // MARK: GET
  func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
    
    
    let request = NSMutableURLRequest(url: URLFromParameters(parameters, withPathExtension: method))
    request.httpMethod = "GET"
    
    let task = session.dataTask(with: request as URLRequest) { data, response, error in
      
      guard (error == nil) else {
        print("Error: \(error!)")
        return
      }
      
      guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
        print("Your request returned a status code other than 2xx!")
        return
      }
      
      guard let data = data else {
        print("No data was returned by the request!")
        return
      }
      
      let range = Range(5..<data.count)
      
      let newData = data.subdata(in: range) /* subset response data! */
      
      /* 5/6. Parse the data and use the data (happens in completion handler) */
      self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForGET)
      
    }
    
    task.resume()
    
    return task
  }
  
  
  // MARK: POST
  
  func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
    
    /* 1. Set the parameters */
    var parametersWithApiKey = parameters
    //    parametersWithApiKey[ParameterKeys.ApiKey] = Constants.ApiKey as AnyObject?
    
    /* 2/3. Build the URL, Configure the request */
    let request = NSMutableURLRequest(url: URLFromParameters(parametersWithApiKey, withPathExtension: method))
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonBody.data(using: String.Encoding.utf8)
    
    /* 4. Make the request */
    let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
      
      func sendError(_ error: String) {
        print(error)
        let userInfo = [NSLocalizedDescriptionKey : error]
        completionHandlerForPOST(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
      }
      
      /* GUARD: Was there an error? */
      guard (error == nil) else {
        sendError("There was an error with your request: \(error!)")
        return
      }
      
      /* GUARD: Did we get a successful 2XX response? */
      guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
        sendError("Your request returned a status code other than 2xx!")
        return
      }
      
      /* GUARD: Was there any data returned? */
      guard let data = data else {
        sendError("No data was returned by the request!")
        return
      }
      let range = Range(5..<data.count)
      
      let newData = data.subdata(in: range) /* subset response data! */
      
      /* 5/6. Parse the data and use the data (happens in completion handler) */
      self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
    }
    
    /* 7. Start the request */
    task.resume()
    
    return task
  }
  
  // MARK: DELETE
  
  func taskForDELETEMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForDELETE: @escaping(_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
    
    let request = NSMutableURLRequest(url: URLFromParameters(parameters, withPathExtension: method))
    request.httpMethod = "DELETE"
    var xsrfCookie: HTTPCookie? = nil
    let sharedCookieStorage = HTTPCookieStorage.shared
    for cookie in sharedCookieStorage.cookies! {
      if cookie.name == "XSRF=TOKEN" { xsrfCookie = cookie }
    }
    if let xsrfCookie = xsrfCookie {
      request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
    }
    
    let task = session.dataTask(with: request as URLRequest) { data, response, error in
      
      func sendError(_ error: String) {
        print(error)
        let userInfo = [NSLocalizedDescriptionKey : error]
        completionHandlerForDELETE(nil, NSError(domain: "taskForDELETEMethod", code: 1, userInfo: userInfo))
      }
      
      guard (error == nil) else {
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
      
      let range = Range(5..<data.count)
      let newData = data.subdata(in: range)
      
      self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForDELETE)
    }
    
    task.resume()
    
    return task
    
  }
  
  // MARK: Helpers
  
  // substitute the key for the value that is contained within the method name
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
      let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
      completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
    }
    
    completionHandlerForConvertData(parsedResult, nil)
  }
  
  // create a URL from parameters
  private func URLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
    
    var components = URLComponents()
    components.scheme = UdacityClient.Constants.ApiScheme
    components.host = UdacityClient.Constants.ApiHost
    components.path = UdacityClient.Constants.ApiPath + (withPathExtension ?? "")
    components.queryItems = [URLQueryItem]()
    
    for (key, value) in parameters {
      let queryItem = URLQueryItem(name: key, value: "\(value)")
      components.queryItems!.append(queryItem)
    }
    
    // TESTING URL
    print("url: \(String(describing: components.url))")
    
    return components.url!
  }
  
  // MARK: Shared Instance
  
  class func sharedInstance() -> UdacityClient {
    struct Singleton {
      static var sharedInstance = UdacityClient()
    }
    return Singleton.sharedInstance
  }
  
}
