<!-- 검색바 -->
<div class="flex items-center gap-2 shrink-0">
    <div
        class="flex items-center px-4 py-2 border border-gray-300 rounded-md bg-gray-50 w-[280px] sm:w-[320px]">
        <input v-model="keyword" type="text" placeholder="Search for product title..."
            @keyUp.enter="fnSearch" class="bg-transparent focus:outline-none text-sm w-full" />
    </div>
    <button @click="fnSearch"
        class="bg-blue-950 hover:bg-blue-700 text-white text-sm px-4 py-2 rounded whitespace-nowrap">
        검색
    </button>
</div>