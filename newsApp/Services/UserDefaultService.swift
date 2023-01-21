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
    func getSelectedSources() -> [Source]
    func addSelectedSource(source: Source)
    func removeSelectedSource(source: Source)
}

class UserDefaultService: UserDefaultServiceType {
    private let userDefaults: UserDefaults
    
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
                return articles.reversed()
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
    
    func getSelectedSources() -> [Source] {
        if let objects = userDefaults.value(forKey: "sources") as? Data {
            let decoder = JSONDecoder()
            if let sources = try? decoder.decode(Array.self, from: objects) as [Source] {
                return sources
            } else {
                return []
            }
        } else {
            return []
        }
    }
    
    func addSelectedSource(source: Source) {
        var sources = getSelectedSources()
        sources.append(source)
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(sources){
            userDefaults.set(encoded, forKey: "sources")
        }
    }
    
    func removeSelectedSource(source: Source) {
        var sources = getSelectedSources()
        if let index = sources.firstIndex(of: source) {
            sources.remove(at: index)
        } else {
            return
        }
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(sources){
            userDefaults.set(encoded, forKey: "sources")
        }
    }
}
