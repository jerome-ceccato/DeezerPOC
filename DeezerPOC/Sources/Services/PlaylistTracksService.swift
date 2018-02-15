//
//  PlaylistTracksService.swift
//  DeezerPOC
//
//  Created by Jerome Ceccato on 15/02/2018.
//  Copyright © 2018 Jerome Ceccato. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import SwiftyJSON

protocol PlaylistTracksServiceType {
    var hasMore: Variable<Bool> { get }
    
    func fetch() -> Observable<[TrackModelType]>
}

final class PlaylistTracksService: PlaylistTracksServiceType {
    private var nextURL: URL?
    
    let hasMore = Variable(true)
    
    enum FetchError: Error {
        case invalidData
    }
    
    init(playlist: PlaylistModelType) {
        self.nextURL = playlist.tracklistURL
    }
    
    func fetch() -> Observable<[TrackModelType]> {
        let subject = PublishSubject<[TrackModelType]>()
        
        guard let url = nextURL else {
            subject.onCompleted()
            return subject
        }
        
        Alamofire.request(url).responseJSON { [weak self] response in
            if let error = response.error {
                subject.onError(error)
                return
            }
            
            guard let json = response.value.flatMap(JSON.init) else {
                subject.onError(FetchError.invalidData)
                return
            }
            
            self?.nextURL = json["next"].url
            self?.hasMore.value = json["next"].url != nil
            
            let items = json["data"].array?.flatMap(TrackModel.init) ?? []
            
            subject.onNext(items)
            subject.onCompleted()
        }
        
        return subject
    }
}
