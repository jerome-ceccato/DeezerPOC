//
//  UserPlaylistsService.swift
//  DeezerPOC
//
//  Created by Jerome Ceccato on 15/02/2018.
//  Copyright © 2018 Jerome Ceccato. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import SwiftyJSON

protocol UserPlaylistsServiceType {
    var hasMore: Variable<Bool> { get }
    
    func fetch() -> Observable<[PlaylistModelType]>
}

final class UserPlaylistsService: UserPlaylistsServiceType {
    private var nextURL: URL?
    
    let hasMore = Variable(true)
    
    enum FetchError: Error {
        case invalidData
    }
    
    init(userID: String) {
        self.nextURL = UserPlaylistsService.fetcherURL(forUserID: userID)
    }
    
    func fetch() -> Observable<[PlaylistModelType]> {
        let subject = PublishSubject<[PlaylistModelType]>()
        
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
            
            let items = json["data"].array?.flatMap(PlaylistModel.init) ?? []
            
            subject.onNext(items)
            subject.onCompleted()
        }
        
        return subject
    }

    private static func fetcherURL(forUserID userID: String) -> URL? {
        return URL(string: "https://api.deezer.com/user/\(userID)/playlists")
    }
}
