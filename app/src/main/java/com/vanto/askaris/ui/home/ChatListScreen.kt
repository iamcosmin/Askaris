package com.vanto.askaris.ui.home

import android.util.Log
import androidx.compose.foundation.Text
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.wrapContentSize
import androidx.compose.foundation.lazy.LazyColumnFor
import androidx.compose.material.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import com.vanto.askaris.Navigation
import com.vanto.askaris.R
import com.vanto.askaris.Screen
import com.vanto.askaris.data.Repository
import com.vanto.askaris.data.Response
import com.vanto.askaris.data.asResponse
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.ExperimentalCoroutinesApi
import org.drinkless.td.libcore.telegram.TdApi

@ExperimentalCoroutinesApi
@Composable
fun HomeScreen(repository: Repository, modifier: Modifier = Modifier) {
    val chats = repository.chats.getChats().asResponse().collectAsState(null, Dispatchers.IO)
    when (val response = chats.value) {
        null -> {
            LoadingChats(modifier)
        }
        is Response.Success -> {
            ChatsLoaded(repository, response.data, modifier)
        }
        is Response.Error -> {
            LoadingChatsError(modifier)
        }
    }
}

@Composable
private fun LoadingChats(modifier: Modifier = Modifier) {
    Text(
        text = stringResource(R.string.loading),
        style = MaterialTheme.typography.h5,
        modifier = modifier.fillMaxSize().wrapContentSize(Alignment.Center)
    )
}

@ExperimentalCoroutinesApi
@Composable
private fun ChatsLoaded(
    repository: Repository,
    chats: List<TdApi.Chat>,
    modifier: Modifier = Modifier
) {
    Log.d("HomeScreen", "chat: $chats")
    LazyColumnFor(chats, modifier = modifier.padding(start = 16.dp)) {
        ClickableChatItem(repository, it) {
            Navigation.navigateTo(Screen.Chat(it))
        }
    }
}

@Composable
private fun LoadingChatsError(modifier: Modifier = Modifier) {
    Text(
        text = stringResource(R.string.chats_error),
        style = MaterialTheme.typography.h5,
        modifier = modifier.fillMaxSize().wrapContentSize(Alignment.Center)
    )
}
