//
//  APIManager.swift
//  UppermostNews
//
//  Created by Cris on 12/4/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import Foundation
import CoreData
//import p2_OAuth2

enum getSourcesErrorHandler: Error {
    case failedToLoadData
}

class APIManager{
    static let shared: APIManager = APIManager()
    private init() {
        oauth2.logger = OAuth2DebugLogger(.debug)
    }
    
    let oauth2 = OAuth2CodeGrant(settings: [
        "client_id": "69312262336.125802163008",
        "client_secret": "02c187210ea50bb0aac9d93df5f0c9cc",
        "authorize_uri": "https://slack.com/oauth/authorize",
        "token_uri": "https://slack.com/api/oauth.access",
        "redirect_uri": ["breakingsnooze://auth.url"],
        "scope": "chat:write:user",
        "keychain": false,
        "channel": "#random",
        "headers" : ["Accept": "application/json", "Content-Type" : "application/json"]
        ] as OAuth2JSON)
    
    var loader: OAuth2DataLoader!
    
    func getSources(from: String, completion: @escaping (Data?) -> Void) {
        guard let url: URL = URL(string: from) else { return }
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("ERROR: \(getSourcesErrorHandler.failedToLoadData)")
            }
            
            if let responseCode = response as? HTTPURLResponse {
                print("getSources: \(responseCode.statusCode)")
            }
            guard let validData = data else { return }
            completion(validData)
            }.resume()
    }
    
    func getData(urlString: String, completion: @escaping (Data?) -> Void) {
        guard let url: URL = URL(string: urlString) else { return }
        let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("ERROR: \(error?.localizedDescription)")
            }
            
            if let validData = data {
                completion(validData)
            }
        }.resume()
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        oauth2.handleRedirectURL(url)
        return true
    }
    
//    func postToSlack (message: String) {
//        APIManager.shared.oauth2.authConfig.authorizeEmbedded = true
//        do{
//            let authorizedURL = try APIManager.shared.oauth2.authorizeURL(withRedirect: "breakingsnooze://auth.url", scope: "chat:write:user", params: APIManager.shared.oauth2.authParameters)
//            print("WOOO")
//            print(authorizedURL)
//            
//            var request = URLRequest(url: authorizedURL)
//            request.addValue("application/json", forHTTPHeaderField: "Accept")
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            do {
//                try APIManager.shared.oauth2.authorizer.openAuthorizeURLInBrowser(request.url!)
//            } catch {
//                print(error.asOAuth2Error)
//            }
//            APIManager.shared.oauth2.afterAuthorizeOrFail = { authParameters, error in
//            }
//            APIManager.shared.loader = OAuth2DataLoader.(oauth2: oauth2)
//            APIManager.shared.loader
//            APIManager.shared.loader.perform(request: request) { response in
//                do {
//                    print(response.response)
//                    
//                    if response.data != nil {
//                        do {
////                            let data = try JSONSerialization.jsonObject(with: response.data!, options: )
//                            if let data = String.init(data: response.data!, encoding: String.Encoding.utf8) {
//                            //let url = try oath
//                            }
//                            
//                            
//                            
//                        }
//                        catch {
//                            print("errot")
//                        }
//                    }
//                    
//                    DispatchQueue.main.async {
//                        //APIManager.shared.oauth2.parseAccessTokenResponse(data: response.data!)
//                        //let decodedData =
//                        //let decodedString = NSString(data: response.data!, encoding: NSUTF8StringEncoding)
//                    }
//                }
//                catch let error {
//                    DispatchQueue.main.async {
//                        print(error.asOAuth2Error)
//                    }
//                }
//            }
//        } catch {
//            print(error.asOAuth2Error)
//        }
//    }
}
