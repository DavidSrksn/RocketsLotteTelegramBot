//
//  File.swift
//  
//
//  Created by David Sarkisyan on 30.06.2024.
//

import Foundation

enum AnswerFactory {
    static func makeInfo() -> String {
        "Бот сделан для яндексойдов, которые хотят удобнее пить кофе в любимом Rockets на 6 этаже в Лотте @davidsrksn"
    }

    static func makeAddNickname() -> String {
        "Как подписать ваш заказ? Напишем на стикере для вашего удобства"
    }

    static func nicknameAdded(name: String) -> String {
        "✍️ Вы всегда можете поменять подпись, воспользовавшись командой /\(Command.nickname.rawValue)"
    }

    static func invoiceTitle(productName: String) -> String {
        "Оплатите \(productName)"
    }

    static func invoiceDescription(nickname: String?) -> String {
        let appeal = nickname.flatMap { " , \($0)" } ?? ""
        return "По готовности мы отправим сообщение\(appeal)"
    }

    static func thanksForOrder(nickname: String?, productName: String) -> String {
        let appeal = nickname.flatMap { " , \($0)" } ?? ""
        return "Спасибо\(appeal)! Скоро начнем готовить ваш \(productName)"
    }
}
