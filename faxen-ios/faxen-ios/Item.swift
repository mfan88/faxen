//
//  Item.swift
//  faxen
//
//  Created by M Fan on 2026-08-25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
