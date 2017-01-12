//
//  ViewController.swift
//  BreakingSnooze
//
//  Created by C4Q on 1/9/17.
//  Copyright © 2017 C4Q. All rights reserved.

import Foundation

class SourceArticles {
    
    let source: String
    let author: String
    let title: String
    let description: String
    let articleURL: String
    let imageURL: String
    let publishedDate: String
    
    init(source: String, author: String, title: String, description: String, articleURL: String, imageURL: String, publishedDate: String) {
        self.source = source
        self.author = author
        self.title = title
        self.description = description
        self.articleURL = articleURL
        self.imageURL = imageURL
        self.publishedDate = publishedDate
    }
    
    convenience init?(from articleObject: [String : Any], source: String) {
        
        guard let author = articleObject["author"] as? String,
            let title = articleObject["title"] as? String,
            let description = articleObject["description"] as? String,
            let articleURL = articleObject["url"] as? String
            else { print("#######Didnt get in######"); return nil}
        let publishedDate = articleObject["publishedAt"] as? String ?? ""
        
        let imageURL = articleObject["urlToImage"] as? String ?? ""
        
        self.init(source: source, author: author, title: title, description: description, articleURL: articleURL, imageURL: imageURL, publishedDate: publishedDate)
    }
    
    convenience init(fromFavourite: Favorite) {
        self.init(source: "", author: fromFavourite.author!, title: fromFavourite.title!, description: fromFavourite.descript!, articleURL: fromFavourite.url!, imageURL: fromFavourite.imageURL!, publishedDate: fromFavourite.publishDate!)
    }
    
    static func parseArticles(from data: Data) -> [SourceArticles]? {
        var articleDetails = [SourceArticles]()
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            guard let JSONDict = json as? [String : Any],
                let source =  JSONDict["source"] as? String,
                let articles = JSONDict["articles"] as? [[String : Any]] else { return nil }
            
            articles.forEach({ (articleObject) in
                if let  articlesDeets = SourceArticles(from: articleObject, source: source) {
                    articleDetails.append(articlesDeets)
                }
            })
        }
        catch {
            print("ERROR")
        }
        return articleDetails
    }
}
