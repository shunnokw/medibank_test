//
//  ArticleCell.swift
//  newsApp
//
//  Created by Jason Wong on 18/1/2023.
//

import UIKit
import RxSwift

class ArticleCell: UICollectionViewCell {
    
    let titleLable = UILabel()
    let descriptionLable = UILabel()
    let authorLable = UILabel()
    let thumbnailImageView = UIImageView()
    let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemMint
        
        self.addSubview(titleLable)
        self.addSubview(descriptionLable)
        self.addSubview(authorLable)
        self.addSubview(thumbnailImageView)
        
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLable.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func transform(output: ArticleCellViewModel.Output) {
        output.titleTextDriver.drive(titleLable.rx.text).disposed(by: disposeBag)
    }
}
