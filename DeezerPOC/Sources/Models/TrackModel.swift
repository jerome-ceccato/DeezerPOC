//
//  TrackModel.swift
//  DeezerPOC
//
//  Created by Jerome Ceccato on 15/02/2018.
//  Copyright © 2018 Jerome Ceccato. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol TrackModelType {
    var title: String { get }
    var artistName: String { get }
    var duration: TimeInterval { get }
}

struct TrackModel: TrackModelType {
    var title: String
    var artistName: String
    var duration: TimeInterval
    
    init?(json: JSON) {
        guard
            let title = json["title"].string,
            let artistName = json["artist"]["name"].string,
            let duration = json["duration"].double.flatMap(TimeInterval.init)
            else {
                return nil
        }
        
        self.title = title
        self.artistName = artistName
        self.duration = duration
    }
}
