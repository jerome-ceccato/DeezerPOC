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
        if duration >= 0, let formattedDuration = formatter.string(from: duration) {
            // Our format is HH:mm:ss so we always want (at least) 2 digits for each unit
            // Apple's formatter does not work in the intended and documented way so we add the leading 0 if needed
            if formattedDuration.count == "H:mm:ss".count {
                return "0" + formattedDuration
            }
            return formattedDuration
        }
        return "-"
    }
}
