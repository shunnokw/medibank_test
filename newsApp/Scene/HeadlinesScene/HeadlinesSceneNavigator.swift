//
//  HeadlinesSceneNavigator.swift
//  newsApp
//
//  Created by Jason Wong on 18/1/2023.
//

import Foundation
import UIKit

enum Event {
    case toWebViewScene(Article, UserDefaultServiceType)
}

protocol HeadlinesSceneNavigatorType {
    func eventOccurred(with type: Event)
}

final class HeadlinesSceneNavigator: HeadlinesSceneNavigatorType {
    
    let navigator: UINavigationController
    
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
