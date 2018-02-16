//
//  TrackModelMock.swift
//  DeezerPOCTests
//
//  Created by Jerome Ceccato on 16/02/2018.
//  Copyright © 2018 Jerome Ceccato. All rights reserved.
//

import Foundation
@testable import DeezerPOC

class TrackModelMock: TrackModelType {
    var title: String
    var artistName: String = "artist"
    var duration: TimeInterval = 100
    
    init(identifier: Int) {
        title = "\(identifier)"
    }
}
