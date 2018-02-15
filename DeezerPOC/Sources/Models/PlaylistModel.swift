//
//  PlaylistModel.swift
//  DeezerPOC
//
//  Created by Jerome Ceccato on 15/02/2018.
//  Copyright © 2018 Jerome Ceccato. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol PlaylistModelType {
    var title: String { get }
    var duration: TimeInterval { get }
    var author: String { get }
    var pictureURL: URL { get }
    
    var tracklistURL: URL { get }
}

struct PlaylistModel: PlaylistModelType {
    var title: String
    var duration: TimeInterval
    var author: String
    var pictureURL: URL
    var tracklistURL: URL
    
    init?(json: JSON) {
        guard
            let title = json["title"].string,
            let duration = json["duration"].double.flatMap(TimeInterval.init),
            let author = json["creator"]["name"].string,
            let pictureURL = json["picture_medium"].url,
            let tracklistURL = json["tracklist"].url
            else {
                return nil
        }
        
        self.title = title
        self.duration = duration
        self.author = author
        self.pictureURL = pictureURL
        self.tracklistURL = tracklistURL
    }
}
