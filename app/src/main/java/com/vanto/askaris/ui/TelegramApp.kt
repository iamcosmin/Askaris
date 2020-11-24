package com.vanto.askaris.ui

import android.app.Activity
import androidx.compose.foundation.Text
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.material.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.res.stringResource
import androidx.navigation.NavController
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.navigate
import androidx.navigation.compose.rememberNavController
import com.vanto.askaris.MainViewModel
import com.vanto.askaris.R
import com.vanto.askaris.Screen
import com.vanto.askaris.data.Authentication
import com.vanto.askaris.data.Repository
import com.vanto.askaris.ui.chat.ChatScreen
import com.vanto.askaris.ui.home.HomeContent
import com.vanto.askaris.ui.login.WaitForCodeScreen
import com.vanto.askaris.ui.login.WaitForNumberScreen
import com.vanto.askaris.ui.login.WaitForPasswordScreen
import com.vanto.askaris.ui.theme.TelegramTheme
import kotlinx.coroutines.launch

@Composable
fun TelegramApp(activity: Activity, viewModel: MainViewModel) {
    TelegramTheme {
        activity.window.statusBarColor = MaterialTheme.colors.primaryVariant.toArgb()
        val navController = rememberNavController()
        navHost(navController, viewModel)
        observeAuthState(navController, viewModel)
    }
}

@Composable
private fun navHost(navController: NavHostController, viewModel: MainViewModel) {
    val repository = viewModel.repository
    NavHost(navController, startDestination = Screen.Home.route) {
        composable(Screen.Home.route) {
            MainScreen(repository, navController)
        }
        composable(Screen.EnterPhoneNumber.route) {
            WaitForNumberScreen {
                repository.client.insertPhoneNumber(it)
            }
        }
        composable(Screen.EnterCode.route) {
            WaitForCodeScreen {
                repository.client.insertCode(it)
            }
        }
        composable(Screen.EnterPassword.route) {
            WaitForPasswordScreen {
                repository.client.insertPassword(it)
            }
        }
        composable(Screen.Chat.route) {
            ChatScreen(
                repository,
                Screen.Chat.getChatId(it),
                navController
            )
        }
    }
}

@Composable
fun observeAuthState(navController: NavHostController, viewModel: MainViewModel) {
    val repository = viewModel.repository
    val authState = viewModel.authState.collectAsState(Authentication.UNKNOWN)
    when (authState.value) {
        Authentication.UNKNOWN -> {
            // Loading
        }
        Authentication.UNAUTHENTICATED -> {
            repository.client.startAuthentication()
        }
        Authentication.WAIT_FOR_NUMBER -> {
            navController.navigate(Screen.EnterPhoneNumber.route)
        }
        Authentication.WAIT_FOR_CODE -> {
            navController.navigate(Screen.EnterCode.route)
        }
        Authentication.WAIT_FOR_PASSWORD -> {
            navController.navigate(Screen.EnterPassword.route)
        }
        Authentication.AUTHENTICATED -> {
            navController.navigate(Screen.Home.route)
        }
    }
}

@OptIn(ExperimentalMaterialApi::class)
@Composable
private fun MainScreen(
    repository: Repository,
    navController: NavController,
    modifier: Modifier = Modifier
) {
    val scaffoldState = rememberScaffoldState()
    val scope = rememberCoroutineScope()
    Scaffold(
        modifier = modifier,
        scaffoldState = scaffoldState,
        topBar = {
            TopAppBar(title = { Text(stringResource(R.string.app_name)) })
        },
        bodyContent = {
            Surface(color = MaterialTheme.colors.background) {
                HomeContent(repository, navController, modifier = Modifier.fillMaxWidth()) {
                    scope.launch {
                        scaffoldState.snackbarHostState.showSnackbar(it)
                    }
                }
            }
        }
    )
}
