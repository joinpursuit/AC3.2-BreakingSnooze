//
//  SourceArticles.swift
//  UppermostNews
//
//  Created by Cris on 12/5/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import Foundation

class SourceArticles {
    
    let author: String
    let title: String
    let description: String
    let articleURL: String
    let imageURL: String
    let publishedDate: String
    
    init(author: String, title: String, description: String, articleURL: String, imageURL: String, publishedDate: String) {
        self.author = author
        self.title = title
        self.description = description
        self.articleURL = articleURL
        self.imageURL = imageURL
        self.publishedDate = publishedDate
    }
    
    convenience init?(from articleObject: [String : Any]) {
        guard let author = articleObject["author"] as? String,
            let title = articleObject["title"] as? String,
            let description = articleObject["description"] as? String,
            let articleURL = articleObject["url"] as? String
            else { return nil}
        let publishedDate = articleObject["publishedAt"] as? String ?? ""
        
        let imageURL = articleObject["urlToImage"] as? String ?? ""
        
        self.init(author: author, title: title, description: description, articleURL: articleURL, imageURL: imageURL, publishedDate: publishedDate)
    }
    
    static func parseArticles(from data: Data) -> [SourceArticles]? {
        var articleDetails = [SourceArticles]()
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            guard let JSONDict = json as? [String : Any],
                let articles = JSONDict["articles"] as? [[String : Any]] else { return nil }
            
            articles.forEach({ (articleObject) in
                if let  articlesDeets = SourceArticles(from: articleObject) {
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

/*
 "author": "TNW Deals",
 "title": "Easily create and edit documents with PDFpenPro 8 for Mac (50% off)",
 "description": "PDFs are one of the most prevalent document types online, but creating and editing them is a big pain. Luckily, there’s PDFpenPro, which lets you handle the biggest problem most PDF users inevitably face. Right now, you can get it get it for only $62 (usually $124.95) from TNW Deals. PDFpenPro makes creating all the …",
 "url": "http://thenextweb.com/offers/2016/12/05/easily-create-edit-documents-pdfpenpro-8-mac-50-off/",
 "urlToImage": "https://cdn1.tnwcdn.com/wp-content/blogs.dir/1/files/2016/12/L1gcm8K.jpg",
 "publishedAt": "2016-12-05T09:34:15Z"
 
 */
