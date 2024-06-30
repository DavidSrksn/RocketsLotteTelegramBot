import Vapor
import TelegramVaporBot

final class DefaultBotHandlers {

//    private let chat: Chat
//
//    init(chat: Chat) {
//        self.chat = chat
//    }

    func setup(app: Vapor.Application, connection: TGConnectionPrtcl) async {
        await infoHandler(app: app, connection: connection)

        await menuHandler(app: app, connection: connection)
        await menuItemsHandler(app: app, connection: connection)
        await startHandler(app: app, connection: connection)
        await nicknameHandler(app: app, connection: connection)
    }

    private func startHandler(app: Vapor.Application, connection: TGConnectionPrtcl) async {
        await connection.dispatcher.add(TGCommandHandler(commands: ["/start"]) { update, bot in
            let userId = update.chatId
            DbClient.shared.createChat(chatid: userId.description)
            try await self.sendMenu(userId: userId, connection: connection)
        })
    }

    private func menuHandler(app: Vapor.Application, connection: TGConnectionPrtcl) async {
        await connection.dispatcher.add(TGCommandHandler(commands: ["/menu"]) { update, bot in
            try await self.sendMenu(userId: update.chatId, connection: connection)
        })
    }

    private func nicknameHandler(app: Vapor.Application, connection: TGConnectionPrtcl) async {
        await connection.dispatcher.add(TGCommandHandler(commands: ["/nickname"]) { update, bot in
            DbClient.shared.setStatus(chatid: update.chatId, status: .waitingNickname)
            try await update.message?.reply(text: AnswerFactory.makeAddNickname(), bot: bot)
        })

//        await connection.dispatcher.add(TGMessageHandler(filters: ) { update, bot in
//            guard let userId = update.message?.from?.id else { fatalError("user id not found") }
//            try await sendMenu(userId: userId, connection: connection)
//        })
    }

    private func menuItemsHandler(app: Vapor.Application, connection: TGConnectionPrtcl) async {
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
    private func infoHandler(app: Vapor.Application, connection: TGConnectionPrtcl) async {
        await connection.dispatcher.add(TGCommandHandler(commands: ["/info"]) { update, bot in
            try await update.message?.reply(text: AnswerFactory.makeInfo(), bot: bot)
        })
    }
}

extension DefaultBotHandlers {
    private func sendMenu(userId: Int64, connection: TGConnectionPrtcl) async throws {
        let buttons = MenuItem.allCases.map(\.buttons)
        let keyboard: TGInlineKeyboardMarkup = .init(inlineKeyboard: buttons)
        let photoParams = TGSendPhotoParams(
            chatId: .chat(userId),
            photo: Icons.rocketsLogo.url,
            replyMarkup: .inlineKeyboardMarkup(keyboard)
        )
        try await connection.bot.sendPhoto(params: photoParams)
    }
}
