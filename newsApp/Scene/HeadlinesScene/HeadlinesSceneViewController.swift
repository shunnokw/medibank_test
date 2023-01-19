//
//  HeadlinesSceneViewController.swift
//  newsApp
//
//  Created by Jason Wong on 18/1/2023.
//

import UIKit

class HeadlinesSceneViewController: UIViewController {
    
    let headlinesSceneViewModel: HeadlinesSceneViewModel

    init(headlinesSceneViewModel: HeadlinesSceneViewModel) {
        self.headlinesSceneViewModel = headlinesSceneViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    // TODO: Should not have so many setting code in viewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Headlines"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBlue
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.standardAppearance = appearance
        
        let headlinesSceneView = HeadlinesSceneView()
        let output = headlinesSceneViewModel.transform(input: headlinesSceneView.input)
        headlinesSceneView.configure(output: output)
        self.view = headlinesSceneView
    }
}
