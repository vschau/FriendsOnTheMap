//
//  MapClient.swift
//  FriendsOnTheMap
//
//  Created by Vanessa on 5/24/20.
//  Copyright © 2020 Vanessa. All rights reserved.
//

import Foundation

class MapClient {
    struct Auth {
      static var sessionId = ""
      static var userId = ""
      static var expiration = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case session
        case studentLocation(Int)
        case user
        case createStudentLocation
        
        var stringValue: String {
            switch self {
                case .session:
                    return Endpoints.base + "/session"
                case .studentLocation(let limit):
                    return Endpoints.base + "/StudentLocation?limit=\(limit)&&order=-updatedAt"
                case .user:
                    return Endpoints.base + "/users/\(Auth.userId)"
                case .createStudentLocation:
                    return Endpoints.base + "/StudentLocation"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                print(" - GET URL: \(url.absoluteString)")
                print(String(data: cleanResponse(data), encoding: .utf8)!)
                let responseObject = try decoder.decode(ResponseType.self, from: cleanResponse(data))
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: cleanResponse(data)) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        return task
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, deleteExtra: Bool, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        print(" - BODY", body)

        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()

            do {
                print(" - POST URL: \(url.absoluteString)")
                print(String(data: cleanResponse(data), encoding: .utf8)!)
                let responseObject = try decoder.decode(ResponseType.self, from: cleanResponse(data))
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: cleanResponse(data)) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = LoginRequest(udacity: LoginInfo(username: username, password: password))

        taskForPOSTRequest(url: Endpoints.session.url, responseType: LoginResponse.self, deleteExtra: true, body: body) { response, error in
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.expiration = response.session.expiration
                Auth.userId = response.account.key
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion()
        }
        task.resume()
    }
    
    class func getStudentLocationList(completion: @escaping ([StudentInformation], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.studentLocation(100).url, responseType: StudentLocationResponse.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func getUser(completion: @escaping (UserResponse?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.user.url, responseType: UserResponse.self) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func createStudentLocation(locationRequest body: LocationRequest, completion: @escaping (Bool, Error?) -> Void) {
        taskForPOSTRequest(url: Endpoints.createStudentLocation.url, responseType: LocationResponse.self, deleteExtra:false, body: body) { response, error in
            if response != nil {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func cleanResponse(_ data: Data) -> Data {
        let str = String(data: data, encoding: .utf8)!
        return str.hasPrefix("{") ? data : data.subdata(in: 5..<data.count)
    }
}
