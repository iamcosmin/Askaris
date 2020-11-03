package com.vanto.askaris.ui

import androidx.compose.foundation.Image
import androidx.compose.foundation.Text
import androidx.compose.foundation.clickable
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.wrapContentSize
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.ColorFilter
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.font
import androidx.compose.ui.text.font.fontFamily
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import com.vanto.askaris.Navigation
import com.vanto.askaris.R
import com.vanto.askaris.Screen
import com.vanto.askaris.data.Authentication
import com.vanto.askaris.data.Repository
import com.vanto.askaris.ui.chat.ChatScreen
import com.vanto.askaris.ui.home.HomeScreen
import com.vanto.askaris.ui.login.WaitForCodeScreen
import com.vanto.askaris.ui.login.WaitForNumberScreen
import com.vanto.askaris.ui.login.WaitForPasswordScreen
import kotlinx.coroutines.ExperimentalCoroutinesApi

@OptIn(ExperimentalCoroutinesApi::class)
@Composable

// TODO: Implement Font Family - in progress...
private val afonta = fontFamily(
        font(R.font)
)

fun Askaris(repository: Repository) {
    val isDark = isSystemInDarkTheme()
    MaterialTheme(
        colors = if (isDark) darkColors() else lightColors(),
        typography = Typography(defaultFontFamily = FontFamily() )
    ) {
        val authState = repository.client.authState.collectAsState(Authentication.UNKNOWN)
        android.util.Log.d("Askaris", "auth state: ${authState.value}")
        when (authState.value) {
            Authentication.UNKNOWN -> {
                CircularProgressIndicator(modifier = Modifier.wrapContentSize(Alignment.Center))
            }
            Authentication.UNAUTHENTICATED -> {
                repository.client.startAuthentication()
                CircularProgressIndicator(modifier = Modifier.wrapContentSize(Alignment.Center))
            }
            Authentication.WAIT_FOR_NUMBER -> {
                WaitForNumberScreen {
                    repository.client.insertPhoneNumber(it)
                }
            }
            Authentication.WAIT_FOR_CODE -> {
                WaitForCodeScreen {
                    repository.client.insertCode(it)
                }
            }
            Authentication.WAIT_FOR_PASSWORD -> {
                WaitForPasswordScreen {
                    repository.client.insertPassword(it)
                }
            }
            Authentication.AUTHENTICATED -> {
                MainScreen(repository)
            }
        }
    }
}

@Composable
@ExperimentalCoroutinesApi
private fun MainScreen(repository: Repository) {
    val currentScreen = Navigation.currentScreen.collectAsState()
    val destination = currentScreen.value
    val title = destination.title
    Scaffold(
        topBar = {
            if (destination == Screen.ChatList) {
                TopAppBar(title = { Text(text = stringResource(R.string.app_name), textAlign = TextAlign.Center) })
            } else {
                TopAppBar(
                    title = { Text(title, maxLines = 1) },
                    navigationIcon = {
                        Image(
                            modifier = Modifier.clickable(onClick = { Navigation.pop() })
                                .padding(16.dp),
                            asset = Icons.Default.ArrowBack,
                            alignment = Alignment.Center,
                            colorFilter = ColorFilter.tint(MaterialTheme.colors.onPrimary)
                        )
                    })
            }
        },
        bodyContent = {
            AppContent(repository, destination, modifier = Modifier.fillMaxWidth())
        }
    )
}

@ExperimentalCoroutinesApi
@Composable
private fun AppContent(repository: Repository, screen: Screen, modifier: Modifier = Modifier) {
    Surface(color = MaterialTheme.colors.background, modifier = modifier) {
        when (screen) {
            is Screen.ChatList -> {
                HomeScreen(repository)
            }
            is Screen.Chat -> ChatScreen(repository, screen.chat)
        }
    }
}
