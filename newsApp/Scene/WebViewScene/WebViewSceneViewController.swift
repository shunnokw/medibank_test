//
//  WebViewSceneViewController.swift
//  newsApp
//
//  Created by Jason Wong on 19/1/2023.
//

import UIKit

class WebViewSceneViewController: UIViewController {
    
    let webViewSceneViewModel: WebViewSceneViewModel

    init(webViewSceneViewModel: WebViewSceneViewModel) {
        self.webViewSceneViewModel = webViewSceneViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = webViewSceneViewModel.title ?? ""
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBlue
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.tintColor = .black
        
        let webViewSceneView = WebViewSceneView()
        let output = webViewSceneViewModel.transform(input: webViewSceneView.input)
        webViewSceneView.configure(output: output)
        self.view = webViewSceneView
        
        self.navigationItem.rightBarButtonItem = webViewSceneView.add
    }
}
