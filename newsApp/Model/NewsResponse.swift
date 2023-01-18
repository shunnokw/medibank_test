//
//  News.swift
//  newsApp
//
//  Created by Jason Wong on 18/1/2023.
//

import Foundation

class NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}
