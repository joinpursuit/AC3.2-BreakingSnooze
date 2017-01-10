//
//  NewsSource+Extenstion.swift
//  BreakingSnooze
//
//  Created by C4Q on 1/9/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

extension NewsSource {
    private func populate(sourceID: String, sourceName: String, sourceDescription: String, category: String, sourceLogo: String) {
        self.sourceID = sourceID
        self.sourceName = sourceName
        self.sourceDescription = sourceDescription
        self.category = category
        self.sourceLogo = sourceLogo
    }
    func parseJson(from json: [String : Any]) {
        guard let id = json["id"] as? String,
        let name = json["name"] as? String,
        let category = json["category"] as? String,
        let logoDict = json["urlsToLogos"] as? [String : Any],
        let logo = logoDict["small"] as? String   else { return }
        
        let description = json["description"] as? String ?? ""
        
        self.populate(sourceID: id, sourceName: name, sourceDescription: description, category: category, sourceLogo: logo)
    }
}
