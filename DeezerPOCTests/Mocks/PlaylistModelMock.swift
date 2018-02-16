//
//  PlaylistModelMock.swift
//  DeezerPOCTests
//
//  Created by Jerome Ceccato on 16/02/2018.
//  Copyright © 2018 Jerome Ceccato. All rights reserved.
//

import Foundation
@testable import DeezerPOC

class PlaylistModelMock: PlaylistModelType {
    var title: String
    var duration: TimeInterval = 100
    var author: String = "author"
    var pictureURL: URL = URL(string: "https://www.betclic.fr/")!
    var tracklistURL: URL = URL(string: "https://www.betclic.fr/")!
    
    init(identifier: Int) {
        title = "\(identifier)"
    }
}
