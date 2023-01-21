//
//  SourceSceneViewController.swift
//  newsApp
//
//  Created by Jason Wong on 18/1/2023.
//

import UIKit

final class SourceSceneViewController: UIViewController {
    
    private let sourceSceneViewModel: SourceSceneViewModel
    
    init(sourceSceneViewModel: SourceSceneViewModel) {
        self.sourceSceneViewModel = sourceSceneViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Sources"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBlue
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.standardAppearance = appearance
        
        let articleView = ArticleView()
        let output = sourceSceneViewModel.transform(input: articleView.input)
        articleView.configure(output: output)
        self.view = articleView
    }
}
