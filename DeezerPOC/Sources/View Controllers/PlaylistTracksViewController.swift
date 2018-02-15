//
//  PlaylistTracksViewController.swift
//  DeezerPOC
//
//  Created by Jerome Ceccato on 15/02/2018.
//  Copyright © 2018 Jerome Ceccato. All rights reserved.
//

import UIKit
import RxSwift

class PlaylistTracksViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewHeader: PlaylistTracksTableViewHeader!
    
    private var viewModel: PlaylistViewModelType!
    private var tracksViewModel: PlaylistTracksViewModelType! {
        return viewModel.trackList
    }
    private let disposeBag = DisposeBag()
    
    private var canLoadMore = true
    
    class func instanciate(viewModel: PlaylistViewModelType) -> PlaylistTracksViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PlaylistTracksViewController") as! PlaylistTracksViewController
        
        controller.viewModel = viewModel
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        loadMoreData()
    }
}

// MARK: Data bindings
private extension PlaylistTracksViewController {
    func bindViewModel() {
        tableViewHeader.viewModel = viewModel
        
        bindTitle()
        bindLoading()
        bindData()
        bindMoreDataAvailable()
    }
    
    func bindTitle() {
        viewModel.title.asObservable().distinctUntilChanged()
            .subscribe(onNext: { [unowned self] title in
                self.title = title
            })
            .disposed(by: disposeBag)
    }
    
    func bindLoading() {
        tracksViewModel.isLoading.asObservable().distinctUntilChanged()
            .subscribe(onNext: { isLoading in
                UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
            })
            .disposed(by: disposeBag)
    }
    
    func bindData() {
        tracksViewModel.tracks.asObservable()
            .subscribe(onNext: { [unowned self] playlists in
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    func bindMoreDataAvailable() {
        tracksViewModel.hasMore.asObservable()
            .subscribe(onNext: { [unowned self] hasMore in
                self.canLoadMore = hasMore
            })
            .disposed(by: disposeBag)
    }
    
    func loadMoreData() {
        if canLoadMore {
            canLoadMore = false
            tracksViewModel.loadMore()
                .subscribe(onError: { [unowned self] _ in
                    self.showFetchErrorIfNeeded()
                })
                .disposed(by: disposeBag)
        }
    }
}

// MARK: Error handling
private extension PlaylistTracksViewController {
    func showFetchErrorIfNeeded() {
        // Only show an error when the tableView is empty
        if tableView.numberOfRows(inSection: 0) == 0 {
            let errorAlert = UIAlertController(title: "Error", message: "Unable to load tracks for that playlist.", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            present(errorAlert, animated: true, completion: nil)
        }
    }
}

// MARK: CollectionView
extension PlaylistTracksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if canLoadMore {
            if indexPath.row >= (tableView.numberOfRows(inSection: indexPath.section) - 1) {
                loadMoreData()
            }
        }
    }
}

extension PlaylistTracksViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracksViewModel.tracks.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "TrackTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TrackTableViewCell
        
        cell.viewModel = tracksViewModel.tracks.value[indexPath.row]
        
        return cell
    }
}

