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
    func addBookmark(article: Article) {
        
    }
    
    func removeBookmark(article: Article) {
        
    }
    
    func getBookmarks() -> [Article] {
        return []
    }
    
    func checkIsBookmarked(article: Article) -> Bool {
        return false
    }
    
    
}
