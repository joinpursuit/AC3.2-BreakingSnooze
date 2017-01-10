//
//  APIRequestManager.swift
//  BreakingSnooze
//
//  Created by Kadell on 1/10/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation


class APIRequestManager {
    
    static let manager: APIRequestManager = APIRequestManager()
    private init() {}
    
    func getPOD(endPoint: String, callback: @escaping(Data?) -> Void) {
        guard let myURL = URL(string: endPoint) else { return }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: myURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error durring session: \(error)")
            }
            guard let validData = data else { return }
            callback(validData)
            }.resume()
    }
    
}
