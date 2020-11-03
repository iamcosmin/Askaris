package com.vanto.askaris

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.compose.ui.platform.setContent
import com.vanto.askaris.data.Repository
import com.vanto.askaris.data.TelegramClient
import com.vanto.askaris.data.UserRepository
import com.vanto.askaris.data.chats.ChatsRepository
import com.vanto.askaris.data.messages.MessagesRepository
import com.vanto.askaris.ui.Askaris
import kotlinx.coroutines.ExperimentalCoroutinesApi


class MainActivity : AppCompatActivity() {

    @ExperimentalCoroutinesApi
    private var client: TelegramClient? = null

    @ExperimentalCoroutinesApi
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            val newClient = TelegramClient(this.application)
            client = newClient
            val repository = Repository(
                newClient,
                ChatsRepository(newClient),
                MessagesRepository(newClient),
                UserRepository(newClient)
            )
            Askaris(repository)
        }
    }

    override fun onBackPressed() {
        if (!Navigation.pop())
            super.onBackPressed()
    }

    override fun onDestroy() {
        super.onDestroy()
        client?.close()
        client = null
    }
}
