//
//  TrackViewModel.swift
//  DeezerPOC
//
//  Created by Jerome Ceccato on 15/02/2018.
//  Copyright © 2018 Jerome Ceccato. All rights reserved.
//

import UIKit
import RxSwift

protocol TrackViewModelType {
    var title: Variable<String> { get }
    var artistName: Variable<String> { get }
    var formattedDuration: Variable<String> { get }
}

final class TrackViewModel: TrackViewModelType {
    var title: Variable<String>
    var artistName: Variable<String>
    var formattedDuration: Variable<String>
    
    init(track: TrackModelType, durationFormatter: DurationFormatterType = DurationFormatter.shared) {
        self.title = Variable(track.title)
        self.artistName = Variable(track.artistName)
        self.formattedDuration = Variable(durationFormatter.string(from: track.duration))
    }
}
