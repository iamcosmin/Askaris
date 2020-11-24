package com.vanto.askaris.data.chats

import androidx.paging.PagingSource
import com.vanto.askaris.await
import kotlinx.coroutines.ExperimentalCoroutinesApi
import org.drinkless.td.libcore.telegram.TdApi

@OptIn(ExperimentalCoroutinesApi::class)
class ChatsPagingSource(
    private val chats: ChatsRepository
) : PagingSource<Long, TdApi.Chat>() {

    override suspend fun load(
        params: LoadParams<Long>
    ): LoadResult<Long, TdApi.Chat> {
        try {
            val nextPageNumber = params.key ?: Long.MAX_VALUE
            val response = chats.getChats(
                nextPageNumber,
                params.loadSize
            )
            val chats = response.await()
            return LoadResult.Page(
                data = chats,
                prevKey = null,
                nextKey = chats.lastOrNull()?.order
            )

        } catch (e: Exception) {
            return LoadResult.Error(e)
        }
    }
}
