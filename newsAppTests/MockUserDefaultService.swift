//
//  MockUserDefaultService.swift
//  newsAppTests
//
//  Created by Jason Wong on 20/1/2023.
//

import Foundation
import RxSwift
@testable import newsApp

class MockUserDefaultService: UserDefaultServiceType {
    var stubBookmarks: [Article]!
    
    var stubIsBookmarked: Bool = false
    
    func getSelectedSources() -> [Source] {
        return []
    }
    
    func addSelectedSource(source: Source) {
        
    }
    
    func removeSelectedSource(source: Source) {
        
    }
    
    func addBookmark(article: Article) {
        
    }
    
    func removeBookmark(article: Article) {
        
    }
    
    func getBookmarks() -> [Article] {
        return stubBookmarks
    }
    
    func checkIsBookmarked(article: Article) -> Bool {
        return stubIsBookmarked
    }
}
