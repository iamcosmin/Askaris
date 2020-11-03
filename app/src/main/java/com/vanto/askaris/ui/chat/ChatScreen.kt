package com.vanto.askaris.ui.chat

import androidx.compose.foundation.*
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.Card
import androidx.compose.material.MaterialTheme
import androidx.compose.material.TextField
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Send
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.state
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.ColorFilter
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.TextFieldValue
import androidx.compose.ui.unit.dp
import com.vanto.askaris.R
import com.vanto.askaris.data.Repository
import com.vanto.askaris.data.Response
import com.vanto.askaris.data.asResponse
import com.vanto.askaris.ui.NetworkImage
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.ExperimentalCoroutinesApi
import org.drinkless.td.libcore.telegram.TdApi

@OptIn(ExperimentalCoroutinesApi::class)
@Composable
fun ChatScreen(repository: Repository, chat: TdApi.Chat, modifier: Modifier = Modifier) {
    val history =
        repository.messages.getMessages(chat.id).asResponse().collectAsState(initial = null)
    when (val response = history.value) {
        null -> {
            ChatLoading(modifier)
        }
        is Response.Success -> {
            Box(modifier = modifier.fillMaxWidth()) {
                ChatHistory(
                    repository,
                    messages = response.data,
                    modifier = Modifier.fillMaxWidth()
                )
                MessageInput(modifier = Modifier.align(Alignment.BottomCenter)) {
                    repository.messages.sendMessage()
                }
            }
        }
        is Response.Error -> {
            Text(
                text = "Cannot load messages",
                style = MaterialTheme.typography.h5,
                modifier = modifier.fillMaxSize().wrapContentSize(Alignment.Center)
            )
        }
    }
}

@Composable
fun ChatLoading(modifier: Modifier = Modifier) {
    Text(
        text = stringResource(R.string.loading),
        style = MaterialTheme.typography.h5,
        modifier = modifier.fillMaxSize().wrapContentSize(Alignment.Center)
    )
}

@ExperimentalCoroutinesApi
@Composable
fun ChatHistory(
    repository: Repository,
    messages: List<TdApi.Message>,
    modifier: Modifier = Modifier
) {
    ScrollableColumn(
        modifier = modifier,
        scrollState = rememberScrollState(0f),
        verticalArrangement = Arrangement.Bottom,
        reverseScrollDirection = true,
    ) {
        messages.forEach {
            MessageItem(repository, it)
        }
    }
}

@ExperimentalCoroutinesApi
@Composable
private fun MessageItem(
    repository: Repository,
    message: TdApi.Message,
    modifier: Modifier = Modifier
) {
    Row(
        verticalAlignment = Alignment.Bottom,
        modifier = Modifier.clickable(onClick = {}).then(modifier.fillMaxWidth())
    ) {
        val userPhoto =
            repository.users.getUser(message.senderUserId).collectAsState(null, Dispatchers.IO)
        val imageModifier = Modifier.padding(16.dp).size(40.dp).clip(shape = CircleShape)
        NetworkImage(
            url = userPhoto.value?.profilePhoto?.small?.local?.path,
            modifier = imageModifier,
            placeHolderRes = null
        )
        Card(
            elevation = 1.dp,
            modifier = Modifier.padding(0.dp, 4.dp, 8.dp, 4.dp)
        ) {
            val messageModifier = Modifier.padding(8.dp)
            when (val content = message.content) {
                is TdApi.MessageText -> TextMessage(content, messageModifier)
                is TdApi.MessageVideo -> VideoMessage(content, messageModifier)
                is TdApi.MessageCall -> CallMessage(content, messageModifier)
                is TdApi.MessageAudio -> AudioMessage(content, messageModifier)
                is TdApi.MessageSticker -> StickerMessage(content, messageModifier)
                is TdApi.MessageAnimation -> AnimationMessage(content, messageModifier)
                else -> Text(message::class.java.simpleName)
            }
        }
    }
}

@Composable
fun MessageInput(modifier: Modifier = Modifier, onEnter: (String) -> Unit) {
    Card(elevation = 8.dp, modifier = modifier.fillMaxWidth()) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            val input = state { TextFieldValue("Message") }
            TextField(
                value = input.value,
                modifier = Modifier.weight(1.0f).then(Modifier.padding(16.dp)),
                onValueChange = { input.value = it },
                label = { },
                textStyle = MaterialTheme.typography.body1
            )
            Image(
                modifier = Modifier.clickable(onClick = { onEnter(input.value.text) })
                    .padding(16.dp).clip(CircleShape),
                asset = Icons.Default.Send,
                alignment = Alignment.Center,
                colorFilter = ColorFilter.tint(MaterialTheme.colors.onBackground)
            )
        }
    }
}