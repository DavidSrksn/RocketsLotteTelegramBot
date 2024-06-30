import Foundation
import SotoDynamoDB

enum DbInputFactory {
    static func newChat(_ id: String) -> DynamoDB.PutItemCodableInput<Chat> {
        let chat = Chat(id: id)
        return DynamoDB.PutItemCodableInput(
            item: chat,
            tableName: Contsnts.tableName
        )
    }

    static func editNickName(chatid: String, nickName: String) -> DynamoDB.UpdateItemCodableInput<Chat> {
        let chat = Chat(id: chatid, status: .idle, nickName: nickName)
        return DynamoDB.UpdateItemCodableInput(
            key: [chatid],
            tableName: Contsnts.tableName,
            updateItem: chat
        )
    }

    static func newTable() -> DynamoDB.CreateTableInput {
        let attributes: [DynamoDB.AttributeDefinition] = [
            .init(attributeName: "id", attributeType: .s),
            .init(attributeName: "status", attributeType: .s),
            .init(attributeName: "nickName", attributeType: .s)
        ]
        let keyElement = DynamoDB.KeySchemaElement(attributeName: "id", keyType: .hash)
        return DynamoDB.CreateTableInput(
            attributeDefinitions: attributes,
            keySchema: [keyElement],
            tableName: Contsnts.tableName
        )
    }
}

extension DbInputFactory {
    enum Contsnts {
        static let tableName = "ClientChats"
    }
}
