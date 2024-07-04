//
//  File.swift
//  
//
//  Created by David Sarkisyan on 27.06.2024.
//

import Foundation
import TelegramVaporBot

let providerToken: String = "401643678:TEST:5c75d304-715b-4f09-8cde-8999f0eccda8"

enum Icons: String {
    case rocketsLogo = "https://rockets.coffee/images/logo.png"

    var url: TGFileInfo {
        .url(rawValue)
    }
}


extension TGUpdate {
    var chatId: Int64 {
        if let chatId = message?.from?.id ?? callbackQuery?.from.id ?? preCheckoutQuery?.from.id {
            return chatId
        } else {
           fatalError("user id not found")
       }
    }
}

extension Array where Element: Equatable {
    var isNotEmpty: Bool {
        isEmpty == false
    }

    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        return uniqueValues
    }
}

extension String {
    var isNotEmpty: Bool {
        isEmpty == false
    }
}

extension TGCommandHandler {

    convenience init(
        commands: [Command],
        _ callback: @escaping TGHandlerCallbackAsync
    ) {
        let formattedCommands = commands.map {
            "/\($0)"
        }
        self.init(commands: formattedCommands, callback)
    }

}
