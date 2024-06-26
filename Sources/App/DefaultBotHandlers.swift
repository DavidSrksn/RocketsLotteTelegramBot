import Vapor
import TelegramVaporBot

final class DefaultBotHandlers {

    static func addHandlers(app: Vapor.Application, connection: TGConnectionPrtcl) async {
        await infoHandler(app: app, connection: connection)

        await menuHandler(app: app, connection: connection)
        await menuItemsHandler(app: app, connection: connection)
    }

    /// Handler for buttons callbacks
    private static func menuHandler(app: Vapor.Application, connection: TGConnectionPrtcl) async {
        await connection.dispatcher.add(TGCommandHandler(commands: ["/menu"]) { update, bot in
            guard let userId = update.message?.from?.id else { fatalError("user id not found") }
            let buttons = MenuItem.allCases.map(\.buttons)
            let keyboard: TGInlineKeyboardMarkup = .init(inlineKeyboard: buttons)
            let params: TGSendMessageParams = .init(chatId: .chat(userId),
                                                    text: "Напитки",
                                                    replyMarkup: .inlineKeyboardMarkup(keyboard))
            let photoParams = TGSendPhotoParams(chatId: .chat(userId), photo: .url("https://avatars.mds.yandex.net/get-marketcms/1357599/img-f91870e7-ba18-4e6d-8f83-db84b768e3c6.png/optimize"))
            try await connection.bot.sendPhoto(params: photoParams)
            try await connection.bot.sendMessage(params: params)
        })
    }

    /// Handler for buttons callbacks
    private static func menuItemsHandler(app: Vapor.Application, connection: TGConnectionPrtcl) async {
        for menuItem in MenuItem.allCases {
            await connection.dispatcher.add(TGCallbackQueryHandler(pattern: menuItem.pattern) { update, bot in
                guard let userId = update.message?.from?.id else { fatalError("user id not found") }
                let params: TGAnswerCallbackQueryParams = .init(callbackQueryId: update.callbackQuery?.id ?? "0",
                                                                text: "",
                                                                showAlert: nil,
                                                                url: nil,
                                                                cacheTime: nil)
                try await bot.answerCallbackQuery(params: params)

                let invoiceParams = TGSendInvoiceParams(
                    chatId: .chat(userId),
                    title: "Оплатите ваш напиток",
                    description: "Сразу после оплаты мы начнем готовить. По готовности вы получите пока что ничего, но скоро добавим оповещения",
                    payload: "",
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
            try await update.message?.reply(text: "Бот сделан для яндексойдов, которые кайфуют от Рокетс и экономии времени. Да, это Давид", bot: bot)
        })
    }
}
