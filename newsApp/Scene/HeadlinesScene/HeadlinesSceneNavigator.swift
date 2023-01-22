//
//  HeadlinesSceneNavigator.swift
//  newsApp
//
//  Created by Jason Wong on 18/1/2023.
//

import Foundation
import UIKit

protocol HeadlinesSceneNavigatorType {
    func eventOccurred(with type: HeadlinesSceneNavigator.Event)
}

final class HeadlinesSceneNavigator: HeadlinesSceneNavigatorType {
    
    enum Event: Equatable {
        case toWebViewScene(article: Article, userDefaultServiceType: UserDefaultServiceType)
        
        static func == (lhs: HeadlinesSceneNavigator.Event, rhs: HeadlinesSceneNavigator.Event) -> Bool {
            switch (lhs, rhs) {
            case (toWebViewScene, toWebViewScene):
                return true
            }
        }
    }
    
    private let navigator: UINavigationController
    
    init(navigator: UINavigationController) {
        self.navigator = navigator
    }
    
    func eventOccurred(with type: Event) {
        switch type {
        case .toWebViewScene(let article, let userDefaultService):
            toWebViewScene(article: article, userDefaultService: userDefaultService)
        }
    }
    
    func toWebViewScene(article: Article, userDefaultService: UserDefaultServiceType) {
        navigator.pushViewController(WebViewSceneViewController(webViewSceneViewModel: .init(article: article, userDefaultService: userDefaultService)), animated: true)
    }
}
