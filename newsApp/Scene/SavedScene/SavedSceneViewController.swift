//
//  SavedSceneViewController.swift
//  newsApp
//
//  Created by Jason Wong on 18/1/2023.
//

import UIKit

final class SavedSceneViewController: UIViewController {
    
    private let savedSceneViewModel: SavedSceneViewModel
    
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
        
        let articleView = ArticleView()
        let output = savedSceneViewModel.transform(input: articleView.input)
        articleView.configure(output: output)
        self.view = articleView
    }
}
