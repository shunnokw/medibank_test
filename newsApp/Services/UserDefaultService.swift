//
//  UserDefaultService.swift
//  newsApp
//
//  Created by Jason Wong on 18/1/2023.
//

import Foundation

protocol UserDefaultServiceType {
    func addBookmark(article: Article)
    func removeBookmark(article: Article)
    func getBookmarks() -> [Article]
    func checkIsBookmarked(article: Article) -> Bool
}

class UserDefaultService: UserDefaultServiceType {
    let userDefaults: UserDefaults
    
    init() {
        userDefaults = UserDefaults.standard
    }
    
    func addBookmark(article: Article) {
        var articles = getBookmarks()
        articles.append(article)
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(articles){
            userDefaults.set(encoded, forKey: "articles")
        }
    }
    
    func removeBookmark(article: Article) {
        var articles = getBookmarks()
        if let index = articles.firstIndex(of: article) {
            articles.remove(at: index)
        } else {
            return
        }
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(articles){
            userDefaults.set(encoded, forKey: "articles")
        }
    }
    
    func getBookmarks() -> [Article] {
        if let objects = userDefaults.value(forKey: "articles") as? Data {
            let decoder = JSONDecoder()
            if let articles = try? decoder.decode(Array.self, from: objects) as [Article] {
                return articles
            } else {
                return []
            }
        } else {
            return []
        }
    }
    
    func checkIsBookmarked(article: Article) -> Bool {
        let articles = getBookmarks()
        return articles.contains(article)
    }
}
