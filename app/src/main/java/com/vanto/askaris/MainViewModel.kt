package com.vanto.askaris

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import com.vanto.askaris.data.Repository
import com.vanto.askaris.data.TelegramClient
import com.vanto.askaris.data.UserRepository
import com.vanto.askaris.data.chats.ChatsRepository
import com.vanto.askaris.data.messages.MessagesRepository
import kotlinx.coroutines.ExperimentalCoroutinesApi

@OptIn(ExperimentalCoroutinesApi::class)
class MainViewModel(app: Application) : AndroidViewModel(app) {

    private var client: TelegramClient = TelegramClient(app)

    val repository = Repository(
        client,
        ChatsRepository(client),
        MessagesRepository(client),
        UserRepository(client)
    )

    val authState = repository.client.authState

    override fun onCleared() {
        super.onCleared()
        client.close()
    }
}