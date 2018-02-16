//
//  UserPlaylistServiceMock.swift
//  DeezerPOCTests
//
//  Created by Jerome Ceccato on 16/02/2018.
//  Copyright © 2018 Jerome Ceccato. All rights reserved.
//

import Foundation
import RxSwift
@testable import DeezerPOC

class UserPlaylistServiceMock: UserPlaylistsServiceType {
    var hasMore: Variable<Bool>
    
    private var data: [[PlaylistModelType]]

    init(withData data: [[PlaylistModelType]]) {
        self.data = data
        self.hasMore = Variable(!data.isEmpty)
    }
    
    func fetch() -> Observable<[PlaylistModelType]> {
        let subject = PublishSubject<[PlaylistModelType]>()
        
        if data.isEmpty {
            subject.onCompleted()
            return subject
        }

        let currentData = data.removeFirst()

        hasMore.value = !data.isEmpty
        subject.onNext(currentData)
        subject.onCompleted()
        return subject
    }
}
