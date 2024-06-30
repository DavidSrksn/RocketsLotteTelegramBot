import Vapor
import TelegramVaporBot

final class DefaultBotHandlers {

    func setup(app: Vapor.Application, connection: TGConnectionPrtcl) async {
        await infoHandler(app: app, connection: connection)

        await menuHandler(app: app, connection: connection)
        await menuItemsHandler(app: app, connection: connection)
        await startHandler(app: app, connection: connection)
        await nicknameHandler(app: app, connection: connection)
        await checkoutHandler(app: app, connection: connection)
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

        await connection.dispatcher.add(TGBaseHandler { update, bot in
            guard 
                let chat = await DbClient.shared.getChat(chatid: update.chatId),
                chat.status == .waitingNickname,
                let message = update.message?.text,
                message.isNotEmpty
            else { return }

            DbClient.shared.editNickname(chatId: update.chatId, nickname: message)
            try await update.message?.reply(text: AnswerFactory.nicknameAdded(name: message), bot: bot)
        })
    }

    private func checkoutHandler(app: Vapor.Application, connection: TGConnectionPrtcl) async {
        await connection.dispatcher.add(TGBaseHandler { update, bot in
            guard
                let preCheckoutQuery = update.preCheckoutQuery
            else { return }

            let preCheckoutQueryParams = TGAnswerPreCheckoutQueryParams(
                preCheckoutQueryId: preCheckoutQuery.id,
                ok: true
            )
            try await bot.answerPreCheckoutQuery(params: preCheckoutQueryParams)
//            let order = Order(id: preCheckoutQuery.id, productName: product.pattern, productId: product.id)
//            DbClient.shared.placeOrder(chatId: update.chatId, order: order)
        })
    }

    private func menuItemsHandler(app: Vapor.Application, connection: TGConnectionPrtcl) async {
        for menuItem in MenuItem.allCases {
            await connection.dispatcher.add(TGCallbackQueryHandler(pattern: menuItem.id) { update, bot in
                let invoiceParams = TGSendInvoiceParams(
                    chatId: .chat(update.chatId),
                    title: "Оплатите ваш напиток",
                    description: "Сразу после оплаты мы начнем готовить. По готовности вы получите пока что ничего, но скоро добавим оповещения",
                    payload: "test",
                    providerToken: providerToken,
                    currency: "RUB",
                    prices: [TGLabeledPrice(label: "RUB", amount: 60000)],
                    startParameter: "test"
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
