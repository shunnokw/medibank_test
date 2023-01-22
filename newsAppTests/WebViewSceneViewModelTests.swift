//
//  WebViewSceneViewModelTests.swift
//  newsAppTests
//
//  Created by Jason Wong on 23/1/2023.
//

import XCTest
import RxTest
import RxSwift
import RxCocoa

@testable import newsApp

final class WebViewSceneViewModelTests: XCTestCase {
    typealias ViewModel = WebViewSceneViewModel
    
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    private var mockUserDefaultService: MockUserDefaultService!

    override func setUpWithError() throws {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        mockUserDefaultService = MockUserDefaultService()
    }
    
    func testUrlAndBookmark() {
        mockUserDefaultService.stubIsBookmarked = false
        
        let viewModel = ViewModel.init(
            article: MockStuff.MockArticle,
            userDefaultService: mockUserDefaultService
        )
        let output = viewModel.transform(input: .init(bookmarkBtnTapEvent: .empty()))
        
        let urlObserver = scheduler.createObserver(URL?.self)
        let isBookmarkedObserver = scheduler.createObserver(Bool.self)
        
        output.urlDriver.drive(urlObserver).disposed(by: disposeBag)
        output.isBookmarkedDriver.drive(isBookmarkedObserver).disposed(by: disposeBag)
        output.otherSignal.emit().disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(urlObserver.events, [
            .next(0, URL(string: "https://google.com"))
        ])
        
        XCTAssertEqual(isBookmarkedObserver.events, [
            .next(0, false)
        ])
    }
    
    func testAddBookmark() {
        mockUserDefaultService.stubIsBookmarked = false
        
        let viewModel = ViewModel.init(
            article: MockStuff.MockArticle,
            userDefaultService: mockUserDefaultService
        )
        
        let addBookmarkSignal: Signal<Void> = scheduler.createColdObservable([
            .next(10, ())
        ])
            .asSignal(onErrorSignalWith: .empty())
        
        let output = viewModel.transform(input: .init(bookmarkBtnTapEvent: addBookmarkSignal))
        
        let isBookmarkedObserver = scheduler.createObserver(Bool.self)
        
        output.isBookmarkedDriver.drive(isBookmarkedObserver).disposed(by: disposeBag)
        output.otherSignal.emit().disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(isBookmarkedObserver.events, [
            .next(0, false),
            .next(10, true)
        ])
    }
    
    func testRemoveBookmark() {
        mockUserDefaultService.stubIsBookmarked = true
        
        let viewModel = ViewModel.init(
            article: MockStuff.MockArticle,
            userDefaultService: mockUserDefaultService
        )
        
        let addBookmarkSignal: Signal<Void> = scheduler.createColdObservable([
            .next(10, ())
        ])
            .asSignal(onErrorSignalWith: .empty())
        
        let output = viewModel.transform(input: .init(bookmarkBtnTapEvent: addBookmarkSignal))
        
        let isBookmarkedObserver = scheduler.createObserver(Bool.self)
        
        output.isBookmarkedDriver.drive(isBookmarkedObserver).disposed(by: disposeBag)
        output.otherSignal.emit().disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(isBookmarkedObserver.events, [
            .next(0, true),
            .next(10, false)
        ])
    }
}
