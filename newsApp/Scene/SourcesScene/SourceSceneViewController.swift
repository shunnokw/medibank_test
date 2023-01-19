//
//  SourceSceneViewController.swift
//  newsApp
//
//  Created by Jason Wong on 18/1/2023.
//

import UIKit

class SourceSceneViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Sources"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBlue
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.standardAppearance = appearance
    }
}
