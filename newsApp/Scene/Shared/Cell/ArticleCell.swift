//
//  ArticleCell.swift
//  newsApp
//
//  Created by Jason Wong on 18/1/2023.
//

import UIKit
import RxSwift

final class ArticleCell: UICollectionViewCell {
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let authorLabel = UILabel()
    private let thumbnailImageView = UIImageView()
    private var disposeBag = DisposeBag()
    private let tapGesture = UITapGestureRecognizer()
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
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 0
        
        authorLabel.adjustsFontSizeToFitWidth = true
        authorLabel.minimumScaleFactor = 0.5
        authorLabel.numberOfLines = 0
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(authorLabel)
        containerView.addSubview(thumbnailImageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        containerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: authorLabel.topAnchor, constant: -8).isActive = true
        titleLabel.rightAnchor.constraint(lessThanOrEqualTo: containerView.rightAnchor, constant: -8).isActive = true
        
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.leftAnchor.constraint(greaterThanOrEqualTo: containerView.leftAnchor, constant: 8).isActive = true
        authorLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
        authorLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
        
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        thumbnailImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        thumbnailImageView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        thumbnailImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -8).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(output: ArticleCellViewModel.Output) {
        output.titleTextDriver.drive(titleLabel.rx.attributedText).disposed(by: disposeBag)
        output.authorTextDriver.drive(authorLabel.rx.attributedText).disposed(by: disposeBag)
        output.thumbnailUIImageDriver.drive(thumbnailImageView.rx.image).disposed(by: disposeBag)
        output.otherSignal.emit().disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        disposeBag = DisposeBag()
    }
}
