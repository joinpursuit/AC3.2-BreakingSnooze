//
//  Favorite+Extension.swift
//  BreakingSnooze
//
//  Created by C4Q on 1/11/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

extension Favorite {
    func populate(article: SourceArticles) {
        self.author = article.author
        self.title = article.title
        self.descript = article.description
        self.url = article.articleURL
        self.imageURL = article.imageURL
        self.publishDate = article.publishedDate
    }
}
