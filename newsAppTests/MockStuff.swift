//
//  MockStuff.swift
//  newsAppTests
//
//  Created by Jason Wong on 19/1/2023.
//

import Foundation
@testable import newsApp

final class MockStuff {
    static let MockArticle =  Article(source: .init(id: "", name: "", description: "", url: "", category: "", language: "", country: ""), author: "", title: "test", description: "", url: "", urlToImage: "", publishedAt: "", content: "")
}
