import NIOSSL
import Fluent
import FluentSQLiteDriver
import Vapor
import TelegramVaporBot


public func configure(_ app: Application) async throws {

    app.http.server.configuration.hostname = "51.250.102.56"

    let tgApi: String = "7358659853:AAGu5GCqo6ydpKMIcqovKeY1gd9aAmJ_EL4"
    let bot: TGBot = .init(app: app, botId: tgApi)

    TGBot.log.logLevel = app.logger.logLevel
    await TGBOT.setConnection(try await TGLongPollingConnection(bot: bot))
    await DefaultBotHandlers.addHandlers(app: app, connection: TGBOT.connection)
    try await TGBOT.connection.start()

    try routes(app)
}
