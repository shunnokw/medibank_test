//
//  HeadlinesSceneViewController.swift
//  newsApp
//
//  Created by Jason Wong on 18/1/2023.
//

import UIKit

class HeadlinesSceneViewController: UIViewController {
    
    let navigator: HeadlinesSceneNavigator
    let networkManager: NewsApiManagerType

    init(navigator: HeadlinesSceneNavigator, networkManager: NewsApiManagerType) {
        self.navigator = navigator
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Headlines"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBlue
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.standardAppearance = appearance
        
        let headlinesSceneView = HeadlinesSceneView()
        let headlinesSceneViewModel = HeadlinesSceneViewModel(navigator: .init(), networkManager: networkManager)
        let output = headlinesSceneViewModel.transform(input: headlinesSceneView.input)
        headlinesSceneView.transform(output: output)
        self.view = headlinesSceneView
    }
}
