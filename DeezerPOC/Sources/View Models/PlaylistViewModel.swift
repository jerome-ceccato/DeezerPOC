//
//  PlaylistViewModel.swift
//  DeezerPOC
//
//  Created by Jerome Ceccato on 15/02/2018.
//  Copyright © 2018 Jerome Ceccato. All rights reserved.
//

import UIKit
import RxSwift

protocol PlaylistViewModelType {
    var title: Variable<String> { get }
    var subtitle: Variable<String> { get }
    var pictureURL: Variable<URL> { get }
    
    var trackList: PlaylistTracksViewModelType { get }
}

final class PlaylistViewModel: PlaylistViewModelType {
    var title: Variable<String>
    var subtitle: Variable<String>
    var pictureURL: Variable<URL>
    
    var trackList: PlaylistTracksViewModelType
    
    init(playlist: PlaylistModelType, durationFormatter: DurationFormatterType = DurationFormatter.shared) {
        self.title = Variable(playlist.title)
        self.pictureURL = Variable(playlist.pictureURL)
        
        let author = playlist.author
        let formattedDuration = durationFormatter.string(from: playlist.duration)
        self.subtitle = Variable("\(author) - \(formattedDuration)")
        
        trackList = PlaylistTracksViewModel(service: PlaylistTracksService(playlist: playlist))
    }
}
