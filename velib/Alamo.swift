//
//  Alamo.swift
//  velib
//
//  Created by Corentin Fouré on 12/04/16.
//  Copyright © 2016 Corentin Fouré. All rights reserved.
//

import Foundation


//
//  Alamo.swift
//  Deawit
//
//  Created by Corentin Fouré on 02/05/15.
//  Copyright (c) 2015 Deawit. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

func == (left: HttpStatusCode, right: HttpStatusCode) -> Bool {
    return left.rawValue == right.rawValue
}

func != (left: HttpStatusCode, right: HttpStatusCode) -> Bool {
    return left.rawValue != right.rawValue
}

func > (left: HttpStatusCode, right: HttpStatusCode) -> Bool {
    return left.rawValue > right.rawValue
}

func >= (left: HttpStatusCode, right: HttpStatusCode) -> Bool {
    return left.rawValue >= right.rawValue
}

func <= (left: HttpStatusCode, right: HttpStatusCode) -> Bool {
    return left.rawValue <= right.rawValue
}

func < (left: HttpStatusCode, right: HttpStatusCode) -> Bool {
    return left.rawValue < right.rawValue
}




enum HttpStatusCode: Int{
    case Informational = 100
    case Success = 200
    case Redirection = 300
    case ErrorClient = 400
    case ErrorServer = 500
    
}

class AlamoClass {
    
    var headers = [String: String]()
    
    func request (method: Alamofire.Method, nocache: Bool = false, URLString: Alamofire.URLStringConvertible, parameters: [String: AnyObject]? = nil, encoding: Alamofire.ParameterEncoding = .URL, success : (AnyObject?)->(), error : (AnyObject?) -> ()) {
        
        
        if (nocache == false) {
            Alamofire.request(method, URLString, parameters: parameters, encoding: encoding, headers: self.headers)
                .responseJSON { response in
                    #if DEBUG
                        print("ALAMO DEBUG")
                        print("\tresponse \(response)")
                        print("\tresponse.request?.allHTTPHeaderFields \(response.request?.allHTTPHeaderFields)")
                        if let body = response.request?.HTTPBody {
                            print("\tresponse.request?.HTTPBody \(String(data:body, encoding: NSUTF8StringEncoding))")
                        }
                        print("\trequest : \(response.request)")  // original URL request
                        print("\tparameters : \(parameters)")  // original URL request
                        print("\tresponse.response \(response.response)") // URL response
                        print("\tdata \(nsdataToJSON(response.data!))")     // server data
                        print("\tresult \(response.result)")   // result of response serialization
                        print("_________________________")
                    #endif
                    switch response.result {
                    case .Success(let JSON):
                        if let hStatusCode = response.response?.statusCode {
                            #if DEBUG
                                print("STATUSCODE : \(hStatusCode)")
                            #endif
                            switch hStatusCode {
                            case 100..<200:break
                            case 200..<300:
                                success(JSON)
                            case 300..<400:break
                            case 400..<500:
                                error(JSON)
                            case 500...599:
                                error(JSON)
                            default:break
                            }
                        }
                    case .Failure(let e):
                        #if DEBUG
                            print("error in alamo : \(e)")
                        #endif
                        error(e)
                    }
                    
            }
        }
        else {
            AlamoNoCache.manager?.request(method, URLString, parameters: parameters, encoding: encoding, headers: self.headers)
                .responseJSON { response in
                    #if DEBUG
                        print("ALAMO DEBUG")
                        print("\tresponse \(response)")
                        print("\tresponse.request?.allHTTPHeaderFields \(response.request?.allHTTPHeaderFields)")
                        if let body = response.request?.HTTPBody {
                            print("\tresponse.request?.HTTPBody \(String(data:body, encoding: NSUTF8StringEncoding))")
                        }
                        print("\trequest : \(response.request)")  // original URL request
                        print("\tparameters : \(parameters)")  // original URL request
                        print("\tresponse.response \(response.response)") // URL response
                        print("\tdata \(nsdataToJSON(response.data!))")     // server data
                        print("\tresult \(response.result)")   // result of response serialization
                        print("_________________________")
                    #endif
                    switch response.result {
                    case .Success(let JSON):
                        if let hStatusCode = response.response?.statusCode {
                            #if DEBUG
                                print("STATUSCODE : \(hStatusCode)")
                            #endif
                            switch hStatusCode {
                            case 100..<200:break
                            case 200..<300:
                                success(JSON)
                            case 300..<400:break
                            case 400..<500:
                                error(JSON)
                            case 500...599:
                                error(JSON)
                            default:break
                            }
                        }
                    case .Failure(let e):
                        #if DEBUG
                            print("error in alamo : \(e)")
                        #endif
                        error(e)
                    }
            }
        }
    }
    
    func setAuthorizationToken(token: String) {
        self.headers["Authorization"] = token
    }
    
    func postImage(url: (URLRequestConvertible, NSData), success: ((AnyObject?) -> ())? = nil, error: ((AnyObject?) -> ())? = nil, progress: ((totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) -> ())? = nil) {
        Alamofire.upload(url.0, data: url.1)
            .progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                if let p = progress {
                    p(totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
                }
            }
            .responseJSON { response  in
                #if DEBUG
                    print("ALAMO DEBUG")
                    print("\tresponse \(response)")
                    print("\tresponse.request?.allHTTPHeaderFields \(response.request?.allHTTPHeaderFields)")
                    if let body = response.request?.HTTPBody {
                        print("\tresponse.request?.HTTPBody \(String(data:body, encoding: NSUTF8StringEncoding))")
                    }
                    print("\trequest : \(response.request)")  // original URL request
                    print("\tresponse.response \(response.response)") // URL response
                    print("\tdata \(nsdataToJSON(response.data!))")     // server data
                    print("\tresult \(response.result)")   // result of response serialization
                    print("_________________________")
                #endif
                switch response.result {
                case .Success(let JSON):
                    if let hStatusCode = response.response?.statusCode {
                        #if DEBUG
                            print("STATUSCODE : \(hStatusCode)")
                        #endif
                        switch hStatusCode {
                        case 100..<200:
                            error?(JSON)
                        case 200..<300:
                            success?(JSON)
                        case 300..<400:
                            error?(JSON)
                        case 400..<500:
                            error?(JSON)
                        case 500...599:
                            error?(JSON)
                        default:
                            error?(JSON)
                        }
                    }
                case .Failure(let e):
                    error?(e)
                }
        }
    }
}

let Alamo = AlamoClass()



class AlamoNoCacheClass {
    var manager: Manager?
    
    init() {
        self.manager = {
            let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            configuration.requestCachePolicy = .ReloadIgnoringLocalCacheData
            return Manager(configuration: configuration)
            }()
    }
}
let AlamoNoCache = AlamoNoCacheClass()