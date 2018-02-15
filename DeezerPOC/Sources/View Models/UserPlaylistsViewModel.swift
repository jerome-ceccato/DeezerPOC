//
//  UserPlaylistsViewModel.swift
//  DeezerPOC
//
//  Created by Jerome Ceccato on 15/02/2018.
//  Copyright © 2018 Jerome Ceccato. All rights reserved.
//

import UIKit
import RxSwift

protocol UserPlaylistsViewModelType {
    var playlists: Variable<[PlaylistViewModelType]> { get }
    var isLoading: Variable<Bool> { get }
    
    var hasMore: Variable<Bool> { get }
    func loadMore() -> Observable<[PlaylistViewModelType]>
}

final class UserPlaylistsViewModel: UserPlaylistsViewModelType {
    private let service: UserPlaylistsServiceType
    private let disposeBag = DisposeBag()
    
    var playlists = Variable<[PlaylistViewModelType]>([])
    var isLoading = Variable(false)
    var hasMore = Variable(true)
    
    init(service: UserPlaylistsServiceType) {
        self.service = service
        
        service.hasMore.asObservable()
            .subscribe(onNext: { [unowned self] hasMore in
                self.hasMore.value = hasMore
            })
            .disposed(by: disposeBag)
    }
    
    func loadMore() -> Observable<[PlaylistViewModelType]> {
        let subject = PublishSubject<[PlaylistViewModelType]>()
        
        isLoading.value = true
        service.fetch()
            .subscribe(onNext: { [unowned self] newItems in
                let newViewModels: [PlaylistViewModelType] = newItems.map { PlaylistViewModel(playlist: $0) }
                
                var items = self.playlists.value
                items.append(contentsOf: newViewModels)
                self.playlists.value = items;
                
                subject.onNext(newViewModels)
                
            }, onError: { error in
                subject.onError(error)
                    
            }, onCompleted: { [unowned self] in
                self.isLoading.value = false
                subject.onCompleted()
                
            })
            .disposed(by: disposeBag)
        
        return subject
    }
}
