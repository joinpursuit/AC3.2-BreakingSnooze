//
//  APIManager.swift
//  UppermostNews
//
//  Created by Cris on 12/4/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import Foundation
import CoreData
import p2_OAuth2

enum getSourcesErrorHandler: Error {
    case failedToLoadData
}

class APIManager {
    static let shared: APIManager = APIManager()
    private init() {}
    
    let oauth2 = OAuth2CodeGrant(settings: [
        "client_id": "69312262336.125802163008",
        "client_secret": "02c187210ea50bb0aac9d93df5f0c9cc",
        "authorize_uri": "https://slack.com/oauth/authorize",
        "token_uri": "https://slack.com/api/oauth.access",
        "redirect_uri": "breakingsnooze://auth.url",
        "scope": "chat:write:user",
        "keychain": false,
        "channel": "#random"
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
    
    func postToSlack (message: String) {
        do {
           oauth2.accessToken = try oauth2.accessTokenRequest(with: "https://slack.com/api/oauth.access").asURL().absoluteString
        } catch {
            print("access token error ", error.asOAuth2Error)
        }
        let url = URL(string: "https://slack.com/oauth/authorize")!
        var req = oauth2.request(forURL: url)
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.setValue(message, forHTTPHeaderField: "message")
        oauth2.authConfig.authorizeEmbedded = true
        oauth2.authorize() { authParameters, error in
            if let params = authParameters {
                print("Authorized! Access token is in `oauth2.accessToken`")
                print("Authorized! Additional parameters: \(params)")
            }
            else {
                print("Authorization was cancelled or went wrong: \(error)")   // error will not be nil
            }
        }

        self.loader = OAuth2DataLoader(oauth2: oauth2)
        
        loader.perform(request: req) { response in
            do {
                let dict = try response.responseJSON()
                DispatchQueue.main.async {
                    dump(dict)
                }
            }
            catch let error {
                DispatchQueue.main.async {
                    print(error.asOAuth2Error)
                }
            }
        }
    }
}
