//
//  PlaylistTracksViewModel.swift
//  DeezerPOC
//
//  Created by Jerome Ceccato on 15/02/2018.
//  Copyright © 2018 Jerome Ceccato. All rights reserved.
//

import UIKit
import RxSwift

protocol PlaylistTracksViewModelType {
    var tracks: Variable<[TrackViewModelType]> { get }
    var isLoading: Variable<Bool> { get }
    
    var hasMore: Variable<Bool> { get }
    func loadMore() -> Observable<[TrackViewModelType]>
}

final class PlaylistTracksViewModel: PlaylistTracksViewModelType {
    private let service: PlaylistTracksServiceType
    private let disposeBag = DisposeBag()
    
    var tracks = Variable<[TrackViewModelType]>([])
    var isLoading = Variable(false)
    var hasMore = Variable(true)
    
    init(service: PlaylistTracksServiceType) {
        self.service = service
        
        service.hasMore.asObservable()
            .subscribe(onNext: { [unowned self] hasMore in
                self.hasMore.value = hasMore
            })
            .disposed(by: disposeBag)
    }
    
    func loadMore() -> Observable<[TrackViewModelType]> {
        let subject = PublishSubject<[TrackViewModelType]>()
        
        isLoading.value = true
        service.fetch()
            .subscribe(onNext: { [unowned self] newItems in
                let newViewModels: [TrackViewModelType] = newItems.map { TrackViewModel(track: $0) }
                
                var items = self.tracks.value
                items.append(contentsOf: newViewModels)
                self.tracks.value = items;
                
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
