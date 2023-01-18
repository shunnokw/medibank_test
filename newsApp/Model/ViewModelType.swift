//
//  ViewModelType.swift
//  newsApp
//
//  Created by Jason Wong on 18/1/2023.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
