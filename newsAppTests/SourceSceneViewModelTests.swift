//
//  SourceSceneViewModelTests.swift
//  newsAppTests
//
//  Created by Jason Wong on 22/1/2023.
//

import XCTest
import RxTest
import RxSwift
import RxCocoa

@testable import newsApp

final class SourceSceneViewModelTests: XCTestCase {
    typealias ViewModel = SourceSceneViewModel
    typealias Section = ViewModel.Section
    
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    private var mockNewsApiService: MockNewsApiService!
    private var mockUserDefaultService: MockUserDefaultService!
    
    override func setUpWithError() throws {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        mockNewsApiService = MockNewsApiService()
        mockUserDefaultService = MockUserDefaultService()
    }
    
    func testDataSource() throws {
        mockNewsApiService.stubSourceObservable = scheduler.createColdObservable([
            .next(0, [MockStuff.MockSource])
        ]).asObservable()
        
        let viewModel = ViewModel.init(
            newsApiService: mockNewsApiService,
            userDefaultService: mockUserDefaultService
        )
        let output = viewModel.transform(input: .init(refreshControlSignal: .empty()))
        
        let dataSourceObserver = scheduler.createObserver([Section].self)
        output.dateSourceDriver.drive(dataSourceObserver).disposed(by: disposeBag)
        output.otherSignal.emit().disposed(by: disposeBag)
        
        scheduler.start()
        
        let cellViewModel = try extractCellViewModel(
            dataSourceObserver: dataSourceObserver,
            event: 1,
            row: 0
        )
        
        scheduler.stop()
        scheduler = TestScheduler(initialClock: 0)

        let cellViewModelOutput = cellViewModel.transform(input: .init(isSwitchSelectedSignal: .empty()))
        let titleTextObserver = scheduler.createObserver(NSAttributedString.self)
        cellViewModelOutput.nameTextDriver.drive(titleTextObserver).disposed(by: disposeBag)
        
        scheduler.start()
        
        let font = UIFont.systemFont(ofSize: 14)
        let attributes = [NSAttributedString.Key.font: font]
        let expectedText = NSAttributedString(string: "test", attributes: attributes)
        
        XCTAssertEqual(titleTextObserver.events, [
            .next(0, expectedText)
        ])
    }
    
    func testSelectionSwitch() throws {
        mockNewsApiService.stubSourceObservable = scheduler.createColdObservable([
            .next(0, [MockStuff.MockSource])
        ]).asObservable()
        
        let viewModel = ViewModel.init(
            newsApiService: mockNewsApiService,
            userDefaultService: mockUserDefaultService
        )
        let output = viewModel.transform(input: .init(refreshControlSignal: .empty()))
        
        let dataSourceObserver = scheduler.createObserver([Section].self)
        output.dateSourceDriver.drive(dataSourceObserver).disposed(by: disposeBag)
        output.otherSignal.emit().disposed(by: disposeBag)
        
        scheduler.start()
        
        let cellViewModel = try extractCellViewModel(
            dataSourceObserver: dataSourceObserver,
            event: 1,
            row: 0
        )
        
        scheduler.stop()
        scheduler = TestScheduler(initialClock: 0)
        
        let selectSignal: Signal<Bool> = scheduler.createHotObservable([
            .next(0, false),
            .next(10, true)
        ]).asSignal(onErrorSignalWith: .empty())

        let cellViewModelOutput = cellViewModel.transform(input: .init(isSwitchSelectedSignal: selectSignal))
        let isSelectedObserver = scheduler.createObserver(Bool.self)
        cellViewModelOutput.isSelectedDriver.drive(isSelectedObserver).disposed(by: disposeBag)
        cellViewModelOutput.otherSignal.emit().disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(isSelectedObserver.events, [
            .next(0, false),
            .next(0, false),
            .next(10, true)
        ])
    }
}

extension SourceSceneViewModelTests {
    func extractCellViewModel(
        dataSourceObserver: TestableObserver<[Section]>,
        event: Int,
        row: Int
    ) throws -> SourceCellViewModel {
        guard let cellViewModel = dataSourceObserver.events[try: event]?.value.element?[try: 0]?.items[try: row]
        else { throw "Failed to extract view model" }
        
        switch cellViewModel {
        case .ArticleListSectionItem:
            throw "Extracted wrong view model"
        case .SourceListSectionItem(let viewModel):
            return viewModel
        }
    }
}
