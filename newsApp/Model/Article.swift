//
//  Article.swift
//  newsApp
//
//  Created by Jason Wong on 19/1/2023.
//

import Foundation

class Article: Codable, Equatable {
    static func == (lhs: Article, rhs: Article) -> Bool {
        return (
            lhs.source == rhs.source &&
            lhs.author == rhs.author &&
            lhs.title == rhs.title &&
            lhs.description == rhs.description &&
            lhs.url == rhs.url &&
            lhs.urlToImage == rhs.urlToImage &&
            lhs.publishedAt == rhs.publishedAt &&
            lhs.content == rhs.content
        )
    }
    
    let source: Source
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    
    init(source: Source, author: String?, title: String?, description: String?, url: String?, urlToImage: String?, publishedAt: String?, content: String?) {
        self.source = source
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
}
