//
//  HeadlinesSceneNavigator.swift
//  newsApp
//
//  Created by Jason Wong on 18/1/2023.
//

import Foundation
import UIKit

final class HeadlinesSceneNavigator {
    
    let navigator: UINavigationController
    
    init(navigator: UINavigationController) {
        self.navigator = navigator
    }
    
    func toWebViewScene(article: Article, userDefaultService: UserDefaultServiceType) {
        navigator.pushViewController(WebViewSceneViewController(webViewSceneViewModel: .init(article: article, userDefaultService: userDefaultService)), animated: true)
    }
}
