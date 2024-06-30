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
            endpoint: "https://docapi.serverless.yandexcloud.net/ru-central1/b1gmpof9ekkkesn2inj8/etn7r8okmapsskvpn8a3"
        )
        return db
    }()

    func createChat(id: String) {
        let input = DbInputFactory.newChat(id)
        db.putItem(input)
    }

    func editNickName(chatId: String, nickName: String) {
        let input = DbInputFactory.editNickName(chatid: chatId, nickName: nickName)
        db.updateItem(input)
    }

    func creatTable() {
        let input = DbInputFactory.newTable()
        db.createTable(input)
    }
}
