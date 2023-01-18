//
//  MockNetworkManager.swift
//  newsAppTests
//
//  Created by Jason Wong on 19/1/2023.
//

import Foundation
import RxSwift
@testable import newsApp

class MockNewsAPIManger: NewsApiManagerType {
    var stubArticlesObservable: Observable<[Article]>!
    
    func getHeadlines() -> Observable<[Article]> {
        return stubArticlesObservable
    }
}
