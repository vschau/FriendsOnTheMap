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
        case studentList
        case student
        
        var stringValue: String {
            switch self {
                case .session:
                    return Endpoints.base + "/session"
                case .studentList:
//                    return Endpoints.base + "StudentLocation?limit=100"
                    return Endpoints.base + "/StudentLocation?limit=10"
                case .student:
                    return Endpoints.base + "/users/\(Auth.userId)"
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
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data) as! Error
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
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)

        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let decoder = JSONDecoder()
            
            // Check if the response has an error
            if error != nil {
                print("Error \(String(describing: error))")
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data!) as! Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }

            if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode == 200 {
                    let decoder = JSONDecoder()
                    do {
                        let newData = data!.subdata(in: 5..<data!.count)
                        print(String(data: newData, encoding: .utf8)!)
                        let responseObject = try decoder.decode(ResponseType.self, from: newData)
                        DispatchQueue.main.async {
                            completion(responseObject, nil)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(nil, error)
                        }
                    }
                } else {
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

        taskForPOSTRequest(url: Endpoints.session.url, responseType: LoginResponse.self, body: body) { response, error in
            if let response = response {
                print(response)
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
    
    class func getStudentLocationList(completion: @escaping ([StudentLocation], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.studentList.url, responseType: StudentLocationResponse.self) { response, error in
            print(response!.results)
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
//    class func getStudent(completion: @escaping (User, Error?) -> Void) {
//        taskForGETRequest(url: Endpoints.studentList.url, responseType: StudentLocationResponse.self) { response, error in
//            print(response!.results)
//            if let response = response {
//                completion(response.results, nil)
//            } else {
//                completion([], error)
//            }
//        }
//    }
}
