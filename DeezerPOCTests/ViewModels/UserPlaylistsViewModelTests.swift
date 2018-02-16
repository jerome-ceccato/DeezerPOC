//
//  UserPlaylistsViewModelTests.swift
//  DeezerPOCTests
//
//  Created by Jerome Ceccato on 16/02/2018.
//  Copyright © 2018 Jerome Ceccato. All rights reserved.
//

import XCTest
import RxSwift
import SwiftyJSON
@testable import DeezerPOC

class UserPlaylistsViewModelTests: XCTestCase {
    
    private var disposeBag: DisposeBag!
    private var viewModel: UserPlaylistsViewModelType!
    
    override func setUp() {
        super.setUp()

        disposeBag = DisposeBag()
        
        let data = [
            createPlaylistModels(amount: 5),
            createPlaylistModels(amount: 10),
            createPlaylistModels(amount: 1)
        ]
        
        let serviceMock = UserPlaylistServiceMock(withData: data)
        viewModel = UserPlaylistsViewModel(service: serviceMock)
    }
    
    private func createPlaylistModels(amount: Int) -> [PlaylistModelType] {
        return (0 ..< amount).flatMap { identifier in
            return PlaylistModelMock(identifier: identifier)
        }
    }
    
    override func tearDown() {
        disposeBag = nil
        viewModel = nil
        
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertTrue(viewModel.playlists.value.isEmpty)
        XCTAssertTrue(viewModel.hasMore.value)
    }
    
    func testSingleLoad() {
        let serviceLoadedData = expectation(description: "service loaded data")
        
        viewModel.loadMore()
            .subscribe(onNext: { [unowned self] newItems in
                
                XCTAssertEqual(newItems.count, 5)
                XCTAssertEqual(self.viewModel.playlists.value.count, 5)
                XCTAssertEqual(self.viewModel.playlists.value[2].title.value, "2")
                
                XCTAssertTrue(self.viewModel.hasMore.value)
                
            }, onCompleted: {
                serviceLoadedData.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1) { error in
            XCTAssertNil(error)
        }
    }
    
    func testLoadMore() {
        let serviceFirstLoad = expectation(description: "first load")
        let serviceLoadMore = expectation(description: "load more")
        
        viewModel.loadMore()
            .subscribe(onNext: { [unowned self] newItems in
                
                XCTAssertEqual(newItems.count, 5)
                XCTAssertEqual(self.viewModel.playlists.value.count, 5)
                
                }, onCompleted: {
                    serviceFirstLoad.fulfill()
                    
                    self.viewModel.loadMore()
                        .subscribe(onNext: { [unowned self] newItems in
                            
                            XCTAssertEqual(newItems.count, 10)
                            XCTAssertEqual(self.viewModel.playlists.value.count, 15)
                            
                            XCTAssertEqual(self.viewModel.playlists.value[1].title.value, "1")
                            XCTAssertEqual(self.viewModel.playlists.value[5 + 1].title.value, newItems[1].title.value)
                            
                        }, onCompleted: {
                            serviceLoadMore.fulfill()
                        })
                        .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1) { error in
            XCTAssertNil(error)
        }
    }
    
    func testConsumeAllData() {
        let hasFinishedConsumingData = expectation(description: "has finished consuming data")
        
        viewModel.hasMore.asObservable()
            .subscribe(onNext: { [unowned self] hasMore in
                if hasMore {
                    self.viewModel.loadMore().subscribe().disposed(by: self.disposeBag)
                }
                else {
                    hasFinishedConsumingData.fulfill()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.loadMore().subscribe().disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1) { error in
            XCTAssertNil(error)
        }
    }
}
