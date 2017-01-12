//
//  OAuthManager.swift
//  BreakingSnooze
//
//  Created by C4Q on 1/11/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation
import UIKit

enum SlackScope: String {
    case user, public_repo
}

class OAuthManager {
    static let authorizationURl = URL(string:"https://slack.com/oauth/authorize")!
    static let redirectURI = URL(string: "breakingsnooze://auth.url")!
    
    private var clientID: String?
    private var clientSecret: String?
    private var clientCode: String?
    private var clientToken: String?
    let defaults = UserDefaults.standard
    
    static let shared = OAuthManager()
    private init () {}
    
    internal class func configure(clientID: String, clientSecret: String) {
        shared.clientID = clientID
        shared.clientSecret = clientSecret
    }
    
    func requestAuthToken(url: URL) {
        var codeComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        self.clientCode = codeComponents?.queryItems?[0].value
        
        let clientIDQuery = URLQueryItem(name: "client_id", value: self.clientID!)
        let redirectURLQuery = URLQueryItem(name: "redirect_uri", value: OAuthManager.redirectURI.absoluteString)
        let clientSecretQuery = URLQueryItem(name: "client_secret", value: self.clientSecret!)
        let accessCodeQuery = URLQueryItem(name: "code", value: self.clientCode!)
        var requestComponents = URLComponents(url: URL(string: "https://slack.com/api/oauth.access  ")!, resolvingAgainstBaseURL: true)
        requestComponents?.queryItems = [clientIDQuery, redirectURLQuery, clientSecretQuery, accessCodeQuery]
        
        var request = URLRequest(url: (requestComponents?.url)!)
        request.httpMethod = "POST"
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) {(data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print(error!.localizedDescription)
            }
            if data != nil {
                // let string = String(data: data!, encoding: String.Encoding.utf8)
                if let validDataAsURL = URL(dataRepresentation: data!, relativeTo: nil) {
                    let tokens = validDataAsURL.absoluteString.components(separatedBy: CharacterSet(charactersIn: "=&"))
                    for i in 0..<tokens.count {
                        if tokens[i] == "access_token" {
                            self.clientToken = tokens[i + 1]
                            break
                        }
                    }
                    let breakingSnoozeDefaultsDict: [String: String] = [
                        "clientID" : self.clientID!,
                        "clientSecret" : self.clientSecret!,
                        "accessToken" : self.clientToken!
                    ]
                    self.defaults.set(breakingSnoozeDefaultsDict, forKey: "BreakingSnooze")
                }
            }
            if response != nil {
                let httpResponse = response as! HTTPURLResponse
                print(httpResponse.statusCode)
            }
            }.resume()
    }
    
    func requestAuthorization(scopes: [SlackScope]) throws {
        guard let clientID = self.clientID,
            let clientSecret = self.clientSecret
            else {
                throw NSError(domain: "ClientID/Client Secret not set", code: 1, userInfo: nil)
        }
        
        let clientIDQuery = URLQueryItem(name: "client_id", value: clientID)
        let redirectURLQuery = URLQueryItem(name: "redirect_uri", value: OAuthManager.redirectURI.absoluteString)
        let scope = URLQueryItem(name: "scope", value: scopes.flatMap{ $0.rawValue }.joined(separator: " "))
        
        var components = URLComponents(url: OAuthManager.authorizationURl, resolvingAgainstBaseURL: true)
        components?.queryItems = [clientIDQuery, redirectURLQuery, scope]
        
        UIApplication.shared.open(components!.url!, options: [:], completionHandler: nil)
        
    }
    
    func setAccessToken () {
        self.clientToken = defaults.dictionary(forKey: "BreakingSnooze")!["accessToken"] as? String
        self.clientID = defaults.dictionary(forKey: "BreakingSnooze")!["clientID"] as? String
        self.clientSecret = defaults.dictionary(forKey: "BreakingSnooze")!["clientSecret"] as? String
    }
    
    func getStarredRepos () {
        let accessQuery = URLQueryItem(name: "access_token", value: self.clientToken!)
        var components = URLComponents(url: URL(string: "https://api.github.com/user/starred")!, resolvingAgainstBaseURL: true)
        components?.queryItems = [accessQuery]
        var request = URLRequest(url: (components?.url)!)
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print(error!.localizedDescription)
            }
            if response != nil {
                let httpResponse = response as! HTTPURLResponse
                print(httpResponse.statusCode)
            }
            if data != nil {
                print(data!)
            }
        }.resume()
    }
}
