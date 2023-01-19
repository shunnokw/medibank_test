//
//  ArticleCell.swift
//  newsApp
//
//  Created by Jason Wong on 18/1/2023.
//

import UIKit
import RxSwift

class ArticleCell: UICollectionViewCell {
    let containerView = UIView()
    let titleLable = UILabel()
    let descriptionLable = UILabel()
    let authorLable = UILabel()
    let thumbnailImageView = UIImageView()
    var disposeBag = DisposeBag()
    let tapGesture = UITapGestureRecognizer()
    let input: ArticleCellViewModel.Input
    
    override init(frame: CGRect) {
        input = .init(
            clickOnCardSignal: tapGesture.rx.event.map { _ in }.asSignal(onErrorSignalWith: .empty())
        )
        
        super.init(frame: frame)
        
        self.addSubview(containerView)
        
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = .white
        
        containerView.addGestureRecognizer(tapGesture)
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 0.5
        
        titleLable.adjustsFontSizeToFitWidth = true
        titleLable.minimumScaleFactor = 0.5
        titleLable.numberOfLines = 0
        
        authorLable.adjustsFontSizeToFitWidth = true
        authorLable.minimumScaleFactor = 0.5
        authorLable.numberOfLines = 0
        
        containerView.addSubview(titleLable)
        containerView.addSubview(descriptionLable)
        containerView.addSubview(authorLable)
        containerView.addSubview(thumbnailImageView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        containerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        titleLable.bottomAnchor.constraint(equalTo: authorLable.topAnchor, constant: -8).isActive = true
        titleLable.rightAnchor.constraint(lessThanOrEqualTo: containerView.rightAnchor, constant: -8).isActive = true
        
        authorLable.translatesAutoresizingMaskIntoConstraints = false
        authorLable.leftAnchor.constraint(greaterThanOrEqualTo: containerView.leftAnchor, constant: 8).isActive = true
        authorLable.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
        authorLable.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
        
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        thumbnailImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        thumbnailImageView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        thumbnailImageView.bottomAnchor.constraint(equalTo: titleLable.topAnchor, constant: -8).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(output: ArticleCellViewModel.Output) {
        output.titleTextDriver.drive(titleLable.rx.attributedText).disposed(by: disposeBag)
        output.authorTextDriver.drive(authorLable.rx.attributedText).disposed(by: disposeBag)
        output.thumbnailUIImageDriver.drive(thumbnailImageView.rx.image).disposed(by: disposeBag)
        output.otherSignal.emit().disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        disposeBag = DisposeBag()
    }
}
