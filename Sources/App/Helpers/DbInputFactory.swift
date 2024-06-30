import Foundation
import SotoDynamoDB

enum DbInputFactory {

    static func getChat(_ id: String) -> DynamoDB.GetItemInput {
        return DynamoDB.GetItemInput(
            key: [Constants.primaryKey: .s(id)],
            tableName: Constants.tableName
        )
    }

    static func newChat(_ id: String) -> DynamoDB.PutItemCodableInput<Chat> {
        let chat = Chat(id: id, status: .idle)
        return DynamoDB.PutItemCodableInput(
            item: chat,
            returnValues: .allNew,
            tableName: Constants.tableName
        )
    }

    static func editNickName(chatid: String, nickName: String) -> DynamoDB.UpdateItemCodableInput<Chat> {
        let chat = Chat(id: chatid, status: .idle, nickName: nickName)
        return DynamoDB.UpdateItemCodableInput(
            key: [Constants.primaryKey],
            returnValues: .allNew,
            tableName: Constants.tableName,
            updateItem: chat
        )
    }

    static func setStatus(chatid: Int64, status: ChatStatus) -> DynamoDB.UpdateItemCodableInput<Chat> {
        let chat = Chat(id: chatid.description, status: status)
        return DynamoDB.UpdateItemCodableInput(
            key: [Constants.primaryKey],
            tableName: Constants.tableName,
            updateItem: chat
        )
    }

    static func newTable() -> DynamoDB.CreateTableInput {
        let attributes: [DynamoDB.AttributeDefinition] = [
            .init(attributeName: "id", attributeType: .s),
            .init(attributeName: "status", attributeType: .s),
            .init(attributeName: "nickname", attributeType: .s)
        ]
        let keyElement = DynamoDB.KeySchemaElement(attributeName: "id", keyType: .hash)
        return DynamoDB.CreateTableInput(
            attributeDefinitions: attributes,
            keySchema: [keyElement],
            tableName: Constants.tableName
        )
    }
}

extension DbInputFactory {
    enum Constants {
        static let tableName = "ClientChats"
        static let primaryKey = "id"
    }
}
