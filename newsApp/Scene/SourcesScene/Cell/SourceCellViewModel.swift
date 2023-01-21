//
//  SourceCellViewModel.swift
//  newsApp
//
//  Created by Jason Wong on 21/1/2023.
//

import UIKit
import RxCocoa
import RxSwift

final class SourceCellViewModel: ViewModelType {
    struct Input {
        let isSwitchSelectedSignal: Signal<Bool>
    }
    
    struct Output {
        let nameTextDriver: Driver<NSAttributedString>
        let descriptionTextDriver: Driver<NSAttributedString>
        let isSelectedDriver: Driver<Bool>
        let otherSignal: Signal<Void>
    }
    
    private let source: Source
    private let isSelectedRelay: BehaviorRelay<Bool>
    private let userDefaultService: UserDefaultServiceType
    
    init(source: Source, isSelected: Bool, userDefaultService: UserDefaultServiceType) {
        self.source = source
        self.isSelectedRelay = BehaviorRelay(value: isSelected)
        self.userDefaultService = userDefaultService
    }
    
    func transform(input: Input) -> Output {
        
        let otherSignal = input.isSwitchSelectedSignal.map { [self]
            selected in
            if selected {
                userDefaultService.addSelectedSource(source: source)
            } else {
                userDefaultService.removeSelectedSource(source: source)
            }
            isSelectedRelay.accept(selected)
        }
        
        let nameTextDriver: Driver<NSAttributedString> = Driver.of(source.name ?? "").map {
            let font = UIFont.systemFont(ofSize: 14)
            let attributes = [NSAttributedString.Key.font: font]
            return NSAttributedString(string: $0, attributes: attributes)
        }
        
        let descriptionTextDriver: Driver<NSAttributedString> = Driver.of(source.description ?? "").map {
            let font = UIFont.systemFont(ofSize: 12)
            let attributes = [NSAttributedString.Key.font: font]
            return NSAttributedString(string: $0, attributes: attributes)
        }
        
        return Output(
            nameTextDriver: nameTextDriver,
            descriptionTextDriver: descriptionTextDriver,
            isSelectedDriver: isSelectedRelay.asDriver(),
            otherSignal: otherSignal
        )
    }
}
