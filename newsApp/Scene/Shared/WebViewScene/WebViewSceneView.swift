//
//  WebViewSceneView.swift
//  newsApp
//
//  Created by Jason Wong on 19/1/2023.
//

import UIKit
import WebKit
import RxSwift

final class WebViewSceneView: UIView {
    let input: WebViewSceneViewModel.Input!
    let addBarButtonItem = UIBarButtonItem()

    private let webView = WKWebView()
    private let disposeBag = DisposeBag()    

    override init(frame: CGRect) {
        self.input = WebViewSceneViewModel.Input(
            bookmarkBtnTapEvent: addBarButtonItem.rx.tap.asSignal()
        )
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.addSubview(webView)
        
        addBarButtonItem.style = .plain

        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func configure(output: WebViewSceneViewModel.Output) {
        output.urlDriver.drive(onNext: {
            url in
            guard let url = url else { return }
            let request = URLRequest(url: url)
            self.webView.load(request)
        }).disposed(by: disposeBag)
        
        output.isBookmarkedDriver.drive(onNext: {
            isBookmarked in
            if isBookmarked {
                self.addBarButtonItem.image = UIImage(systemName: "bookmark.fill")
            } else {
                self.addBarButtonItem.image = UIImage(systemName: "bookmark")
            }
        }).disposed(by: disposeBag)
        
        output.otherSignal.emit().disposed(by: disposeBag)
    }
}
