//
//  SavedSceneViewController.swift
//  newsApp
//
//  Created by Jason Wong on 18/1/2023.
//

import UIKit

class SavedSceneViewController: UIViewController {
    
    let savedSceneViewModel: SavedSceneViewModel
    
    init(savedSceneViewModel: SavedSceneViewModel) {
        self.savedSceneViewModel = savedSceneViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Saved"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBlue
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.standardAppearance = appearance
        
        let headlinesSceneView = ArticleView()
        let output = savedSceneViewModel.transform(input: headlinesSceneView.input)
        headlinesSceneView.configure(output: output)
        self.view = headlinesSceneView
    }
}
