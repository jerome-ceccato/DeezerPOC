//
//  PlaylistCollectionViewCell.swift
//  DeezerPOC
//
//  Created by Jerome Ceccato on 15/02/2018.
//  Copyright © 2018 Jerome Ceccato. All rights reserved.
//

import UIKit
import RxSwift
import AlamofireImage

class PlaylistCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var coverImageView: UIImageView!
    
    private var disposeBag: DisposeBag?
    
    var viewModel: PlaylistViewModelType? {
        didSet {
            setupBindings(with: viewModel)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }
}

private extension PlaylistCollectionViewCell {
    func setupBindings(with viewModel: PlaylistViewModelType?) {
        guard let viewModel = viewModel else {
            disposeBag = nil
            titleLabel.text = nil
            coverImageView.af_cancelImageRequest()
            coverImageView.image = nil
            return
        }
        
        disposeBag = DisposeBag()
        
        viewModel.title.asObservable()
            .subscribe(onNext: { [unowned self] title in
                self.titleLabel.text = title
            })
            .disposed(by: disposeBag!)
        
        viewModel.pictureURL.asObservable()
            .subscribe(onNext: { [unowned self] url in
                self.coverImageView.af_setImage(withURL: url)
            })
            .disposed(by: disposeBag!)
    }
}
