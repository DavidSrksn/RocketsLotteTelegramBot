//
//  File.swift
//  
//
//  Created by David Sarkisyan on 30.06.2024.
//

import Foundation

enum AnswerFactory {
    static func makeInfo() -> String {
        "Бот сделан для яндексойдов, которые хотят удобнее и быстрее пить кофе в любимом Рокетс на 6 этаже в Лотте. Да, это Давид @davidsrksn"
    }

    static func makeAddNickname() -> String {
        "Как подписать ваш заказ? Напишем на стикере для вашего удобства"
    }

    static func nicknameAdded(name: String) -> String {
        "Спасибо! Напишем на стикере \(name) ✍️"
    }
}
