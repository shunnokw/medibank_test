//
//  SourceCell.swift
//  newsApp
//
//  Created by Jason Wong on 21/1/2023.
//

import UIKit
import RxSwift
import RxCocoa

final class SourceCell: UICollectionViewCell {
    let input: SourceCellViewModel.Input
    
    private let nameLabel = UILabel()
    private let sourceSelectSwitch = UISwitch()
    private let separationLine = UIView()
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        input = .init(
            isSwitchSelectedSignal: sourceSelectSwitch.rx.controlEvent(.valueChanged)
                .withLatestFrom(sourceSelectSwitch.rx.value)
                .asSignal(onErrorSignalWith: .empty())
        )
        
        super.init(frame: frame)
        
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.5
        nameLabel.numberOfLines = 0
        
        separationLine.backgroundColor = .lightGray
        
        self.addSubview(nameLabel)
        self.addSubview(sourceSelectSwitch)
        self.addSubview(separationLine)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        
        sourceSelectSwitch.translatesAutoresizingMaskIntoConstraints = false
        sourceSelectSwitch.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        sourceSelectSwitch.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        
        separationLine.translatesAutoresizingMaskIntoConstraints = false
        separationLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separationLine.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        separationLine.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        separationLine.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    func configure(output: SourceCellViewModel.Output) {
        output.nameTextDriver.drive(nameLabel.rx.attributedText).disposed(by: disposeBag)
        output.isSelectedDriver.drive(sourceSelectSwitch.rx.value).disposed(by: disposeBag)
        output.otherSignal.emit().disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
