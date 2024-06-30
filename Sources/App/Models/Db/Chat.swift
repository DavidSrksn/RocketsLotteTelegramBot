//
//  File.swift
//  
//
//  Created by David Sarkisyan on 30.06.2024.
//

import Foundation

struct Chat: Codable {
    let id: String
    let status: ChatStatus?
    let nickName: String?
    let orders: [Order]?

    init(
        id: String,
        status: ChatStatus? = nil,
        nickName: String? = nil,
        orders: [Order]? = nil
    ) {
        self.id = id
        self.status = status
        self.nickName = nickName
        self.orders = orders
    }
}
