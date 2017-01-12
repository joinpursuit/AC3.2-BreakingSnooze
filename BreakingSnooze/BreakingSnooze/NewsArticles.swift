//
//  NewsArticles.swift
//  BreakingSnooze
//
//  Created by Kadell on 1/11/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

enum ParsingErrors: Error {
    case articles, source, author, title, description, url,image,publishedAt
}

class NewsArticles {
    
    
    let source: String
    let author: String
    let title: String
    let description: String
    let url: String
    let image: String
    let publishedDate: String
    
    init( source:String, author: String, title: String, description: String, url: String, image: String, publishedDate: String) {
        self.source = source
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.image = image
        self.publishedDate = publishedDate
    }
    
    
    static func getData(from data: Data) -> [NewsArticles]? {
        do{
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            guard let dict = jsonData as? [String: Any] else {return nil }
            guard let articles = dict["articles"] as? [[String:String]] else {throw ParsingErrors.articles}
            
            var allArticles = [NewsArticles]()
            
            for article in articles {
                guard let source = dict["source"] as? String else {throw ParsingErrors.source}
                guard let author = article["author"] else {throw ParsingErrors.author}
                guard let title = article["title"] else {throw ParsingErrors.title}
                guard let description = article["description"] else {throw ParsingErrors.description}
                guard let url = article["url"] else {throw ParsingErrors.url}
                guard let image = article["urlToImage"] else {throw ParsingErrors.image}
                guard let publishedDate = article["publishedAt"] else {throw ParsingErrors.publishedAt}
                
                let articleOf = NewsArticles(source: source, author: author, title: title, description: description, url: url, image: image, publishedDate: publishedDate)
                allArticles.append(articleOf)
            }
        return allArticles
        }
        catch ParsingErrors.articles{
            print("An Error I See \n -Articles")
        }
        catch ParsingErrors.source{
            print("An Error I See \n -Sources")
        }
        catch ParsingErrors.author{
            print("An Error I See \n -Author")
        }
        catch ParsingErrors.title{
            print("An Error I See \n -Title")
        }
        catch ParsingErrors.description{
            print("An Error I See \n -Description")
        }
        catch ParsingErrors.url{
            print("An Error I See \n -URL")
        }
        catch ParsingErrors.image{
            print("An Error I See \n -Image")
        }
        catch ParsingErrors.publishedAt{
            print("An Error I See \n -published")
        }
        catch {
            print("Unknown Error")
        }
        
    return nil
    }
}
