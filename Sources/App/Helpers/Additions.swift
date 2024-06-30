//
//  File.swift
//  
//
//  Created by David Sarkisyan on 27.06.2024.
//

import Foundation
import TelegramVaporBot

let providerToken: String = "381764678:TEST:88648"

enum Icons: String {
    case rocketsLogo = "https://rockets.coffee/images/logo.png"

    var url: TGFileInfo {
        .url(rawValue)
    }
}


extension TGUpdate {
    var chatId: Int64 {
        if let chatId = message?.from?.id ?? callbackQuery?.from.id {
            return chatId
        } else {
           fatalError("user id not found")
       }
    }
}

extension Array {
    var isNotEmpty: Bool {
        isEmpty == false
    }
}

extension String {
    var isNotEmpty: Bool {
        isEmpty == false
    }
}
