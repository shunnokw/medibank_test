//
//  Article.swift
//  newsApp
//
//  Created by Jason Wong on 19/1/2023.
//

import Foundation

class Article: Codable {
    let source: Source
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}
