package com.vanto.askaris.data

import com.vanto.askaris.data.chats.ChatsRepository
import com.vanto.askaris.data.messages.MessagesRepository
import kotlinx.coroutines.ExperimentalCoroutinesApi

@OptIn(ExperimentalCoroutinesApi::class)
class Repository(
    val client: TelegramClient,
    val chats: ChatsRepository,
    val messages: MessagesRepository,
    val users: UserRepository
)