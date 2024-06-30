import Vapor
import TelegramVaporBot

final class DefaultBotHandlers {

    static func addHandlers(app: Vapor.Application, connection: TGConnectionPrtcl) async {
        await infoHandler(app: app, connection: connection)

        await menuHandler(app: app, connection: connection)
        await menuItemsHandler(app: app, connection: connection)
    }

    private static func menuHandler(app: Vapor.Application, connection: TGConnectionPrtcl) async {
        await connection.dispatcher.add(TGCommandHandler(commands: ["/menu", "/start"]) { update, bot in
            guard let userId = update.message?.from?.id else { fatalError("user id not found") }
            let buttons = MenuItem.allCases.map(\.buttons)
            let keyboard: TGInlineKeyboardMarkup = .init(inlineKeyboard: buttons)
            let photoParams = TGSendPhotoParams(
                chatId: .chat(userId),
                photo: Icons.rocketsLogo.url,
                replyMarkup: .inlineKeyboardMarkup(keyboard)
            )
            try await connection.bot.sendPhoto(params: photoParams)
        })
    }

    private static func menuItemsHandler(app: Vapor.Application, connection: TGConnectionPrtcl) async {
        for menuItem in MenuItem.allCases {
            await connection.dispatcher.add(TGCallbackQueryHandler(pattern: menuItem.pattern) { update, bot in
                guard let userId = update.callbackQuery?.from.id else { fatalError("user id not found") }
                let invoiceParams = TGSendInvoiceParams(
                    chatId: .chat(userId),
                    title: "Оплатите ваш напиток",
                    description: "Сразу после оплаты мы начнем готовить. По готовности вы получите пока что ничего, но скоро добавим оповещения",
                    payload: "",
                    providerToken: providerToken,
                    currency: "RUB",
                    prices: [TGLabeledPrice(label: "RUB", amount: 249)],
                    photoUrl: menuItem.photo
                )
                try await bot.sendInvoice(params: invoiceParams)
            })
        }
    }

    /// Handler for Commands
    private static func infoHandler(app: Vapor.Application, connection: TGConnectionPrtcl) async {
        await connection.dispatcher.add(TGCommandHandler(commands: ["/info"]) { update, bot in
            try await update.message?.reply(text: AnswerFactory.makeInfo(), bot: bot)
        })
    }
}
