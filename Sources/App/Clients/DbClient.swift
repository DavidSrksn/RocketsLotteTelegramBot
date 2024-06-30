//
//  File.swift
//  
//
//  Created by David Sarkisyan on 30.06.2024.
//

import Foundation
import SotoCore
import SotoS3
import SotoDynamoDB

final class DbClient {

    static let shared = DbClient()

    private let db: DynamoDB  = {
        let client = AWSClient(
            credentialProvider: .static(accessKeyId: "YCAJEOgoJjisKVrpk25XgyqB-", secretAccessKey: "YCOXWPeuzGAJFCUKApctIkA9SvdeFu1qqCznbiVx"),
            httpClientProvider: .createNew
        )
        let db = DynamoDB(
            client: client,
            endpoint: "https://docapi.serverless.yandexcloud.net/ru-central1/b1gmpof9ekkkesn2inj8/etn5cts5et1fdbq54ak9"
        )
        return db
    }()

    func getChat(chatid: Int64) async -> Chat? {
        let input = DbInputFactory.getChat(chatid)
        let output = try? await db.getItem(input, type: Chat.self).get()
        return output?.item
    }

    func setStatus(chatid: Int64, status: ChatStatus) {
        let input = DbInputFactory.setStatus(chatid: chatid, status: status)
        let output = db.updateItem(input)
    }

    func createChat(chatid: String) {
        let input = DbInputFactory.newChat(chatid)
        let _ = try? db.putItem(input).wait()
    }

    func editNickname(chatId: Int64, nickname: String) {
        let input = DbInputFactory.editNickname(chatid: chatId, nickname: nickname)
        let output = db.updateItem(input)
    }

    func placeOrder(chatId: Int64, order: Order) {
//        let input = DbInputFactory.editNickname(chatid: chatId, nickname: nickname)
//        let output = db.updateItem(input)
    }

    func creatTable() {
        let input = DbInputFactory.newTable()
        let output = db.createTable(input)
    }
}
