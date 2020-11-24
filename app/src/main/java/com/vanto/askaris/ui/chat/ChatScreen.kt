package com.vanto.askaris.ui.chat

import androidx.compose.foundation.Image
import androidx.compose.foundation.Text
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumnFor
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.Gif
import androidx.compose.material.icons.outlined.AttachFile
import androidx.compose.material.icons.outlined.Mic
import androidx.compose.material.icons.outlined.Send
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.ColorFilter
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.TextFieldValue
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import androidx.ui.tooling.preview.Preview
import com.vanto.askaris.R
import com.vanto.askaris.data.Repository
import com.vanto.askaris.data.Response
import com.vanto.askaris.data.asResponse
import dev.chrisbanes.accompanist.coil.CoilImage
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.launch
import org.drinkless.td.libcore.telegram.TdApi

@OptIn(ExperimentalCoroutinesApi::class)
@Composable
fun ChatScreen(
    repository: Repository,
    chatId: Long,
    navController: NavController,
    modifier: Modifier = Modifier
) {
    val chat = repository.chats.getChat(chatId).collectAsState(null)
    Scaffold(
        modifier = modifier,
        topBar = {
            TopAppBar(
                title = { Text(chat.value?.title ?: "", maxLines = 1) },
                navigationIcon = {
                    IconButton(
                        onClick = { navController.navigateUp() },
                        icon = {
                            Image(
                                asset = Icons.Default.ArrowBack,
                                colorFilter = ColorFilter.tint(MaterialTheme.colors.onPrimary)
                            )
                        }
                    )
                })
        },
        bodyContent = {
            ChatContent(chatId, repository)
        }
    )
}

@Composable
fun ChatContent(chatId: Long, repository: Repository, modifier: Modifier = Modifier) {
    val history = repository.messages.getMessages(chatId).asResponse().collectAsState(null)
    when (val response = history.value) {
        null -> {
            ChatLoading(modifier)
        }
        is Response.Success -> {
            Column(modifier = modifier.fillMaxWidth()) {
                ChatHistory(
                    repository,
                    messages = response.data,
                    modifier = Modifier.fillMaxWidth().weight(1.0f)
                )
                val input = remember { mutableStateOf(TextFieldValue("")) }
                val scope = rememberCoroutineScope()
                MessageInput(
                    input = input,
                    insertGif = {
                        // TODO
                    }, attachFile = {
                        // todo
                    }, sendMessage = {
                        scope.launch {
                            repository.messages.sendMessage(
                                chatId = chatId,
                                inputMessageContent = TdApi.InputMessageText(
                                    TdApi.FormattedText(
                                        it,
                                        emptyArray()
                                    ), false, false
                                )
                            ).await()
                            input.value = TextFieldValue()
                        }
                    })
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

@Composable
fun ChatHistory(
    repository: Repository,
    messages: List<TdApi.Message>,
    modifier: Modifier = Modifier
) {
    LazyColumnFor(items = messages, modifier = modifier) {
        MessageItem(repository, it)
    }
}

@OptIn(ExperimentalCoroutinesApi::class)
@Composable
private fun MessageItem(
    repository: Repository,
    message: TdApi.Message,
    modifier: Modifier = Modifier
) {
    Row(
        verticalAlignment = Alignment.Bottom,
        modifier = Modifier.clickable(onClick = {}) then modifier.fillMaxWidth()
    ) {
        val userPhoto =
            repository.users.getUser(message.senderUserId).collectAsState(null, Dispatchers.IO)
        val imageModifier = Modifier.padding(16.dp).size(40.dp).clip(shape = CircleShape)
        userPhoto.value?.profilePhoto?.small?.local?.path?.let {
            CoilImage(
                data = it,
                modifier = imageModifier,
            )
        } ?: Box(imageModifier)
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

@Preview
@Composable
fun PreviewMessageInput () {
    MessageInput() {}
}

@Composable
fun MessageInput(
    modifier: Modifier = Modifier,
    input: MutableState<TextFieldValue> = remember { mutableStateOf(TextFieldValue("")) },
    insertGif: () -> Unit = {},
    attachFile: () -> Unit = {},
    sendMessage: (String) -> Unit = {}
) {
    Surface(modifier, color = MaterialTheme.colors.surface, elevation = 6.dp) {
        TextField(
            value = input.value,
            modifier = Modifier.fillMaxWidth(),
            onValueChange = { input.value = it },
            textStyle = MaterialTheme.typography.body1,
            placeholder = {
                Text("Message")
            },
            leadingIcon = {
                Row (
                    horizontalArrangement = Arrangement.Center
                        ) {
                    IconButton(
                        onClick = insertGif,
                        modifier = Modifier.align(Alignment.CenterVertically)
                    ) {
                        Image(
                            asset = Icons.Default.Gif,
                            colorFilter = ColorFilter.tint(MaterialTheme.colors.onSurface),
                            modifier = Modifier.align(Alignment.CenterVertically).size(30.dp)
                        )
                    }
                }
            },
            trailingIcon = {
                if (input.value.text.isEmpty()) {
                    Row (
                        horizontalArrangement = Arrangement.End
                            ) {
                        IconButton(onClick = attachFile, modifier = Modifier.align(Alignment.CenterVertically)) {
                            Image(
                                asset = Icons.Outlined.AttachFile,
                                colorFilter = ColorFilter.tint(MaterialTheme.colors.onSurface),
                                modifier = Modifier.align(Alignment.CenterVertically)
                            )
                        }
                        IconButton(onClick = { }, modifier = Modifier.align(Alignment.CenterVertically)) {
                            Image(
                                asset = Icons.Outlined.Mic,
                                colorFilter = ColorFilter.tint(MaterialTheme.colors.onSurface),
                                modifier = Modifier.align(Alignment.CenterVertically)
                            )
                        }
                    }
                } else {
                    Row (horizontalArrangement = Arrangement.Center) {
                        IconButton(onClick = { sendMessage(input.value.text)}, modifier = Modifier.align(Alignment.CenterVertically)) {
                            Image(
                                asset = Icons.Outlined.Send,
                                colorFilter = ColorFilter.tint(MaterialTheme.colors.secondary),
                                modifier = Modifier.align(Alignment.CenterVertically)
                            )
                        }
                    }
                }
            },
            backgroundColor = MaterialTheme.colors.surface
        )
    }
}