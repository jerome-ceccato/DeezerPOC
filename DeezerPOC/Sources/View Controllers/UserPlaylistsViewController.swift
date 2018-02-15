//
//  UserPlaylistsViewController.swift
//  DeezerPOC
//
//  Created by Jerome Ceccato on 15/02/2018.
//  Copyright © 2018 Jerome Ceccato. All rights reserved.
//

import UIKit
import RxSwift

class UserPlaylistsViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var viewModel: UserPlaylistsViewModelType!
    private let disposeBag = DisposeBag()
    
    private var canLoadMore = true
    
    class func instanciate(viewModel: UserPlaylistsViewModelType) -> UserPlaylistsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "UserPlaylistsViewController") as! UserPlaylistsViewController
        
        controller.viewModel = viewModel
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Playlists"
        
        bindViewModel()
        loadMoreData()
    }
}

// MARK: Data bindings
private extension UserPlaylistsViewController {
    func bindViewModel() {
        bindLoading()
        bindData()
        bindMoreDataAvailable()
    }
    
    func bindLoading() {
        viewModel.isLoading.asObservable().distinctUntilChanged()
            .subscribe(onNext: { isLoading in
                UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
            })
            .disposed(by: disposeBag)
    }
    
    func bindData() {
        viewModel.playlists.asObservable()
            .subscribe(onNext: { [unowned self] playlists in
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    func bindMoreDataAvailable() {
        viewModel.hasMore.asObservable()
            .subscribe(onNext: { [unowned self] hasMore in
                self.canLoadMore = hasMore
            })
            .disposed(by: disposeBag)
    }
    
    func loadMoreData() {
        if canLoadMore {
            canLoadMore = false
            viewModel.loadMore()
                .subscribe(onError: { [unowned self] _ in
                    self.showFetchErrorIfNeeded()
                })
                .disposed(by: disposeBag)
        }
    }
}

// MARK: Error handling
private extension UserPlaylistsViewController {
    func showFetchErrorIfNeeded() {
        // Only show an error when the collectionView is empty
        if collectionView.numberOfItems(inSection: 0) == 0 {
            let errorAlert = UIAlertController(title: "Error", message: "Unable to load playlists.", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            present(errorAlert, animated: true, completion: nil)
        }
    }
}

// MARK: CollectionView
extension UserPlaylistsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let nextController = PlaylistTracksViewController.instanciate(viewModel: viewModel.playlists.value[indexPath.item])
        navigationController?.pushViewController(nextController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if canLoadMore {
            if indexPath.item >= (collectionView.numberOfItems(inSection: indexPath.section) - 1) {
                loadMoreData()
            }
        }
    }
}

extension UserPlaylistsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.playlists.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "PlaylistCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PlaylistCollectionViewCell

        cell.viewModel = viewModel.playlists.value[indexPath.item]
        
        return cell
    }
}
