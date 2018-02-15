//
//  TrackTableViewCell.swift
//  DeezerPOC
//
//  Created by Jerome Ceccato on 15/02/2018.
//  Copyright © 2018 Jerome Ceccato. All rights reserved.
//

import UIKit
import RxSwift

class TrackTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    
    private var disposeBag: DisposeBag?
    
    var viewModel: TrackViewModelType? {
        didSet {
            setupBindings(with: viewModel)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }
}

private extension TrackTableViewCell {
    func setupBindings(with viewModel: TrackViewModelType?) {
        guard let viewModel = viewModel else {
            disposeBag = nil
            titleLabel.text = nil
            subtitleLabel.text = nil
            durationLabel.text = nil
            return
        }
        
        disposeBag = DisposeBag()
        
        viewModel.title.asObservable()
            .subscribe(onNext: { [unowned self] title in
                self.titleLabel.text = title
            })
            .disposed(by: disposeBag!)
        
        viewModel.artistName.asObservable()
            .subscribe(onNext: { [unowned self] artistName in
                self.subtitleLabel.text = artistName
            })
            .disposed(by: disposeBag!)
        
        viewModel.formattedDuration.asObservable()
            .subscribe(onNext: { [unowned self] formattedDuration in
                self.durationLabel.text = formattedDuration
            })
            .disposed(by: disposeBag!)
    }
}

