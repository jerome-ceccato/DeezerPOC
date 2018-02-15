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
    var formattedDuration: Variable<String> { get }
    var author: Variable<String> { get }
    var pictureURL: Variable<URL> { get }
}

final class PlaylistViewModel: PlaylistViewModelType {
    var title: Variable<String>
    var formattedDuration: Variable<String>
    var author: Variable<String>
    var pictureURL: Variable<URL>
    
    init(playlist: PlaylistModelType, durationFormatter: DurationFormatterType = DurationFormatter.shared) {
        self.title = Variable(playlist.title)
        self.author = Variable(playlist.author)
        self.pictureURL = Variable(playlist.pictureURL)
        self.formattedDuration = Variable(durationFormatter.string(from: playlist.duration))
    }
}
