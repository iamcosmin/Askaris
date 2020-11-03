package com.vanto.askaris

import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.MutableStateFlow
import org.drinkless.td.libcore.telegram.TdApi

/**
 * Class defining the screens we have in the app: home, article details and interests
 */
sealed class Screen(val title: String) {
    object ChatList : Screen("Telegram")
    class Chat(val chat: TdApi.Chat) : Screen(chat.title)
}
@ExperimentalCoroutinesApi
object Navigation {

    private val stack = ArrayList<Screen>().apply { add(Screen.ChatList) }

    val currentScreen = MutableStateFlow<Screen>(Screen.ChatList)

    fun push(destination: Screen) {
        stack.add(destination)
        stackChanged()
    }

    fun pop(): Boolean {
        if (stack.size < 2)
            return false
        stack.removeAt(stack.size - 1)
        stackChanged()
        return true
    }

    fun navigateTo(destination: Screen) {
        push(destination)
    }

    fun replace(destination: Screen) {
        stack[stack.size - 1] = destination
        stackChanged()
    }

    private fun stackChanged() {
        currentScreen.value = stack.last()
    }
}
