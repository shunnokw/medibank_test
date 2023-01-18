//
//  newsAppTests.swift
//  newsAppTests
//
//  Created by Jason Wong on 18/1/2023.
//

import XCTest
import RxTest
import RxSwift

@testable import newsApp

final class HeadlinesSceneViewModelTests: XCTestCase {
    typealias ViewModel = HeadlinesSceneViewModel
    typealias Section = ViewModel.Section
    
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    private var mockNetworkManager: MockNewsAPIManger!

    override func setUpWithError() throws {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        mockNetworkManager = MockNewsAPIManger()
    }

    func testDataSource() throws {
        mockNetworkManager.stubArticlesObservable = scheduler.createColdObservable([
            .next(0, [
                
            ])
        ])
        .asObservable()
        
        let viewModel = ViewModel.init(navigator: .init(), networkManager: mockNetworkManager)
        let output = viewModel.transform(input: .init())
        
        let dataSourceObserver: TestableObserver = scheduler.createObserver([Section].self)
        output.dateSourceDriver.asObservable().bind(to: dataSourceObserver).disposed(by: disposeBag)
        
        scheduler.start()
        
//        XCTAssertEqual(dataSourceObserver.events, [
//            .next(0, [])
//        ])
    }
}
