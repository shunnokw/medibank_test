//
//  MockStuff.swift
//  newsAppTests
//
//  Created by Jason Wong on 19/1/2023.
//

import Foundation
@testable import newsApp

final class MockStuff {
    static let MockArticle =  Article(source: .init(id: "", name: "", description: "", url: "", category: "", language: "", country: ""), author: "jason", title: "test", description: "", url: "https://google.com", urlToImage: "", publishedAt: "", content: "")
    
    static let MockSource = Source(id: "test", name: "test", description: "", url: "", category: "", language: "", country: "")
}
