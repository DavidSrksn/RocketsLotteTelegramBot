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
