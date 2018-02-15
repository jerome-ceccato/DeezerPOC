//
//  DurationFormatter.swift
//  DeezerPOC
//
//  Created by Jerome Ceccato on 15/02/2018.
//  Copyright © 2018 Jerome Ceccato. All rights reserved.
//

import Foundation

protocol DurationFormatterType {
    func string(from duration: TimeInterval) -> String
}

final class DurationFormatter: DurationFormatterType {
    static let shared = DurationFormatter()
    
    private let formatter: DateComponentsFormatter
    
    private init() {
        formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
    }
    
    func string(from duration: TimeInterval) -> String {
        return formatter.string(from: duration) ?? "-"
    }
}
