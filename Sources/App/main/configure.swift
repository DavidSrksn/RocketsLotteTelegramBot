import NIOSSL
import Fluent
import FluentSQLiteDriver
import Vapor
import TelegramVaporBot

public func configure(_ app: Application) async throws {

//    app.http.server.configuration.hostname = "51.250.102.56"
    app.http.server.configuration.hostname = "0.0.0.0"
    app.http.server.configuration.port = 80

    DbClient.shared.createChat(id: "test")

    let tgApi: String = "7295409848:AAEawsWC1hgxQih_7qYBu7ENXP5CKUX22SI"
    let bot: TGBot = .init(app: app, botId: tgApi)

    TGBot.log.logLevel = app.logger.logLevel
    await TGBOT.setConnection(try await TGLongPollingConnection(bot: bot))
    await DefaultBotHandlers.addHandlers(app: app, connection: TGBOT.connection)
    try await TGBOT.connection.start()

    try routes(app)
}
