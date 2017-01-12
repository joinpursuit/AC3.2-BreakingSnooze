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
}
