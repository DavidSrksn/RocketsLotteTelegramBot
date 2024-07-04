//
//  File.swift
//  
//
//  Created by David Sarkisyan on 30.06.2024.
//

import Foundation

struct Order: Codable, Equatable {
    let id: String
    let productName: String
    let productId: String

    static func ==(lhs: Order, rhs: Order) -> Bool {
        return lhs.id == rhs.id
    }
}
