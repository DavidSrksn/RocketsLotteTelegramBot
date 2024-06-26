//
//  File.swift
//  
//
//  Created by David Sarkisyan on 26.06.2024.
//

import Foundation
import TelegramVaporBot

enum Command {
    case menu
    case menuItem(MenuItem)

    var code: String {
        switch self {
        case .menu:
            return "menu"
        case .menuItem(let item):
            return item.rawValue
        }
    }
}

enum MenuItem: String, CaseIterable {
    // Drinks
    case iceLatte
    case iceMatcha

    var buttons: [TGInlineKeyboardButton] {
        [.init(text: name, callbackData: pattern)]
    }

    var pattern: String {
        rawValue
    }

    var photo: String {
        switch self {
        case .iceLatte:
            return "https://images.ctfassets.net/v601h1fyjgba/4GLzOncHIe8rq3xY099cZ/dd17ce72ebb6fb01659c763fe64953db/Iced_Latte.jpg"
        case .iceMatcha:
            return "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTmgMDf8XjFpWsPFOt4X9wk3arI5mDP6J9kjQ&usqp=CAU"
        }
    }

    private var name: String {
        switch self {
        case .iceLatte:
            return "🏮 Ice Latte"
        case .iceMatcha:
            return "🍀 Ice Matcha"
        }
    }
}
