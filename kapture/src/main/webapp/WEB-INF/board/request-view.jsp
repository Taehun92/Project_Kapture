<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <link rel="stylesheet" href="../../css/request-view.css">
	<title>첫번째 페이지</title>
</head>
<body>
    <jsp:include page="../common/header.jsp" />
	<div id="app" class="request-container">
        <!-- 요청 정보 표시 영역 -->
        <section>
            <table class="request-view-table">
                <tr>
                    <th>제목</th>
                    <td colspan="3">{{ info.title }}</td>
                </tr>
                <tr>
                    <th>지역</th>
                    <td>{{ info.region }}</td>
                    <th>예산</th>
                    <td class="budget-cell">
                        <span v-if="info.budget">
                            {{ Number(info.budget).toLocaleString() }} {{ getCurrencyLabel(info.currency) }}
                        </span>
                        <span v-else>
                            {{ getCurrencyLabel(info.currency) }}
                        </span>
                        <br>
                        <span v-if="info.currency != 'KRW'">
                            원화(\) 기준: {{ getConvertedBudgetToKRW().toLocaleString() }} 원
                        </span>
                    </td>
                </tr>
                <tr>
                    <th>내용</th>
                    <td colspan="3">
                        <div v-html="info.description" class="description"></div>
                    </td>
                </tr>
                <tr>
                    <th>작성자</th>
                    <td>{{ info.userFirstName }} {{ info.userLastName }}</td>
                    <th>요청상태</th>
                    <td>
                        <template v-if="info.status === '0'">답변 대기</template>
                        <template v-if="info.status === '1'">답변 중</template>
                        <template v-if="info.status === '2'">답변 완료</template>
                    </td>
                </tr>
            </table>
        </section>

        <!-- 댓글 영역 -->
        <section>
            <comment-item
                v-for="comment in commentList"
                :key="comment.commentNo"
                :comment="comment"
                :depth="0"
                :session-id="sessionId"
                :session-role="sessionRole"
                :request-status="info.status"
                :request-user-no="info.userNo"
                @reply="fnReply"
                @edit="fnEditComment"
                @remove="fnRemoveComment"
            />
        </section>

        <!-- 답변 작성 버튼 -->
        <section v-if="canWriteAnswer" class="answer-box">
            <button @click="fnAnswer">댓글쓰기</button>
        </section>
        <section v-if="answerFlg" class="answer-box">
            <div>
                {{ sessionFirstName }} {{ sessionLastName }} :
                <textarea v-model="answerComment" rows="6"></textarea>
            </div>
            <div>
                <button @click="fnAddReply">작성</button>
                <button @click="fnBack">취소</button>
            </div>
        </section>
        <!-- 대댓글 입력창 -->
        <section v-if="replyFlg" class="comment-box reply-input-box">
            <div>
                <input v-model="answerComment" placeholder="댓글을 입력하세요">
            </div>
            <div>
                <button @click="fnAddReply">작성</button>
                <button @click="fnBack">취소</button>
            </div>
        </section>
        <!-- 대댓글 수정-->
        <section v-if="commentFlg" class="answer-box">
            <div>
                <textarea v-model="editComment" rows="4" class="w-full border rounded p-2"></textarea>
            </div>
            <div class="text-right mt-2">
                <button @click="fnUpdateComment(commentNo)">수정 완료</button>
                <button @click="fnBack">취소</button>
            </div>
        </section>
        <div class="btn-group" v-if="canEditDelete">
            <button class="action-btn edit-btn" @click="fnEdit">수정</button>
            <button class="action-btn delete-btn" @click="fnRemove">삭제</button>
        </div>

        <div v-if="canAccept" class="btn-group">
            <button class="action-btn" @click="fnAccept">채택</button>
        </div>
	</div>
    <jsp:include page="../common/footer.jsp" />
</body>

<script>
const commentItem = {
    props: {
        comment: Object,
        depth: Number,
        sessionId: String,
        sessionRole: String,
        requestStatus: String,
        requestUserNo: [String, Number] 
    },
    emits: ['reply', 'edit', 'remove'],
    computed: {
        canAnswer() {
            return this.requestStatus !== '2' && (this.sessionRole === 'GUIDE' || this.sessionId === this.requestUserNo);
        },
        canReply() {
            return this.requestStatus !== '2' && (this.sessionRole == 'ADMIN' || this.sessionRole == 'GUIDE' || this.sessionId == String(this.comment.userNo));
        },
        canEditDelete() {
            return this.requestStatus !== '2' && this.sessionId === String(this.comment.userNo);
        }
    },
    template: `
        <section :class="[depth > 0 ? 'reply-container comment-box' : 'comment-box']" :style="{ marginLeft: (depth * 16) + 'px' }">
            <div class="comment-content" :class="{ 'deleted-comment': comment.deleted }">
                <strong>{{ comment.userFirstName }}</strong>
                <span class="message">{{ comment.message }}</span>
                <span
                    v-if="depth < 9 && (!comment.children || comment.children.length === 0) && canReply && !comment.deleted"
                    class="reply-write"
                    @click="$emit('reply', comment.commentNo)"
                >댓글쓰기</span>
            </div>
            <div class="comment-actions" v-if="canEditDelete">
                <button @click="$emit('edit', comment)">수정</button>
                <button @click="$emit('remove', comment.commentNo)">삭제</button>
            </div>
            <comment-item 
                v-for="child in comment.children"
                :key="child.commentNo"
                :comment="child"
                :depth="depth + 1"
                :session-id="sessionId"
                :session-role="sessionRole"
                :request-status="requestStatus"
                :request-user-no="requestUserNo"
                @reply="$emit('reply', $event)"
                @edit="$emit('edit', $event)"
                @remove="$emit('remove', $event)"
            />
        </section>
    `
};

function buildTree(flatList) {
    const map = {};
    const tree = [];

    flatList.forEach(item => {
        item.children = [];

        // 삭제 처리
        if (item.deleteYn === 'Y') {
            item.message = '삭제된 댓글입니다.';
            item.userFirstName = '';
            item.userLastName = '';
            item.deleted = true;
        }

        map[item.commentNo] = item;
    });

    flatList.forEach(item => {
        const parent = map[item.parentCommentNo];
        if (item.parentCommentNo && parent !== undefined) {
            // 삭제되었더라도 연결은 유지
            parent.children.push(item);
        } else {
            tree.push(item);
        }
    });

    return tree;
}

const app = Vue.createApp({
    data() {
        return {
            requestNo : "",
            sessionId : "${sessionId}",
            sessionRole : "${sessionRole}",
            sessionFirstName : "${sessionFirstName}",
            sessionLastName : "${sessionLastName}",
            info : {},
            commentList : [],
            answerFlg : false,
            commentFlg : false,
            replyFlg : false,
            answerComment : "",
            editComment : "",
            commentNo : "",
            reply : "",
            exchangeRateMap : {
                USD: 0,
                JPY: 0,
                CNY: 0
            }
        };
    },
    computed: {
        canEditRequest() {
            return this.sessionId == this.info.userNo || this.sessionRole == 'ADMIN';
        },
        canAccept() {
            return this.info.status == '1' && this.sessionId == this.info.userNo;
        },
        canWriteAnswer() {
            return this.info.status != '2' && (this.sessionRole == 'ADMIN' || this.sessionRole == 'GUIDE');
        }
    },
    methods: {
        getConvertedKRW(amount, code) {
            const rates = {
                USD: 1350,
                JPY: 9.1,
                CNY: 185
            };
            if (code == "KRW") return Number(amount);
            const rate = rates[code];
            if (!rate || isNaN(amount)) return 0;
            return Math.round(Number(amount) * rate);
        },
        getCurrencyLabel(code) {
            const labels = {
                KRW: "원(₩)",
                USD: "달러($)",
                JPY: "엔(¥)",
                CNY: "위안(元)"
            };
            return labels[code] || "원(₩)";
        },
        getNestedComments(parentNo) {
            if (!Array.isArray(this.commentList)) return [];
            console.log("부모번호>>>" + parentNo);
            const result = this.commentList.filter(function(item) {
                const itemParent = item.parentCommentNo != null ? String(item.parentCommentNo) : "0";
                const match = String(itemParent) === String(parentNo); // ← 숫자 기준 비교로 고정
                console.log("[getNestedComments] match check ➜ item:", item, "itemParent:", itemParent, "parentNo:", parentNo, "match:", match);
                return match;
            });

            console.log("[getNestedComments] parentNo:", parentNo, "result:", result);
            return result;
        },
         // 들여쓰기 계산 함수
        depthMargin(depth) {
            return (depth * 24) + 'px';
        },
        canEditComment(comment) {
            return this.info.status != '2' && (this.sessionId == comment.userNo || this.sessionRole == 'ADMIN');
        },
        fnview() {
            var self = this;
            $.ajax({
                url: "/request/view.dox",
                type: "POST",
                dataType: "json",
                data: { requestNo: self.requestNo },
                success: function(data) {
                    self.info = data.info;
                    self.commentList = buildTree(data.commentList); // 🌳 트리 구조로 변환!
                    console.log("[fnview] 트리 구조 댓글:", JSON.stringify(self.commentList, null, 2));
                }
            });
        },
        fnEdit() {
            location.href="/request/edit.do?requestNo=" + this.requestNo;
        },
        fnRemove() {
            var self = this;
            if (!confirm("해당 게시글을 삭제 하시겠습니까?")) {
                return;
            }
            $.ajax({
                url: "/request/remove.dox",
                type: "POST",
                dataType: "json",
                data: { requestNo: self.requestNo },
                success: function(data) {
                    if (data.num > 0) {
                        alert("삭제 되었습니다.");
                        location.href = "/request/list.do";
                    }
                }
            });
        },
        fnAnswer() {
            this.answerFlg = true;
        },
        fnBack() {
            this.answerFlg = false;
            this.replyFlg = false;
            this.commentFlg = false;
            this.editComment = "";
            this.reply = "";
        },
        fnReply(commentNo) {
            this.commentNo = commentNo;  // 어떤 댓글에 대해 답글 쓸지 기억
            this.replyFlg = true;
        },
        fnAddReply() {
            const self = this;
            $.ajax({
                url: "/request/comment/add.dox",
                type: "POST",
                dataType: "json",
                data: {
                    requestNo: self.requestNo,
                    userNo: self.sessionId,
                    parentCommentNo: self.commentNo, // parentCommentNo
                    comments: self.answerComment
                },
                success: function(data) {
                    console.log("[댓글 응답 확인]", data);
                    if (data.num > 0 && data.comment) {
                        // 트리 구조에서 해당 부모 찾아 children에 push
                        const parent = self.findCommentInTree(self.commentList, self.commentNo);
                        if (parent) {
                            if (!parent.children) parent.children = [];
                            parent.children.push(data.comment);  // 새로 작성된 댓글을 추가
                        } else {
                            // 혹시 parent가 없으면 루트에 추가
                            self.commentList.push(data.comment);
                        }

                        alert("댓글이 등록 되었습니다.");
                        self.replyFlg = false;
                        self.answerComment = "";
                        self.fnview();
                    }
                }
            });
        },
        findCommentInTree(list, commentNo) {
            for (let item of list) {
                if (String(item.commentNo) === String(commentNo)) {
                    return item;
                }
                if (item.children) {
                    const found = this.findCommentInTree(item.children, commentNo);
                    if (found) return found;
                }
            }
            return null;
        },
        fnEditComment(comment) {
            this.editComment = comment.message; // 수정할 내용 입력창에 넣기
            this.commentFlg = true;
            this.commentNo = comment.commentNo; // 수정 대상 기억
        },
        fnUpdateComment(commentNo) {
            const self = this;
            $.ajax({
                url: "/request/comment/edit.dox",
                type: "POST",
                dataType: "json",
                data: { 
                    commentNo: commentNo, 
                    comments: self.editComment 
                },
                success: function(data) {
                    if (data.num > 0) {
                        const target = self.findCommentInTree(self.commentList, commentNo);
                        if (target) {
                            target.message = self.editComment; // 트리 구조 내 수정 반영
                        }
                        alert("답변이 수정 되었습니다.");
                        self.commentFlg = false;
                        self.editComment = "";
                    }
                }
            });
        },
        findCommentInTree(list, commentNo) {
            for (let item of list) {
                if (String(item.commentNo) === String(commentNo)) {
                    return item;
                }
                if (item.children) {
                    const found = this.findCommentInTree(item.children, commentNo);
                    if (found) return found;
                }
            }
            return null;
        },

        fnRemoveComment(commentNo) {
            const self = this;
            if (!confirm("해당 답변을 삭제 하시겠습니까?")) {
                return;
            }

            $.ajax({
                url: "/request/comment/remove.dox",
                type: "POST",
                dataType: "json",
                data: { commentNo: commentNo },
                success: function(data) {
                    if (data.num > 0) {
                        const comment = self.findCommentInTree(self.commentList, commentNo);
                        if (comment) {
                            comment.message = "삭제된 댓글입니다.";
                            comment.userFirstName = "";
                            comment.userLastName = "";
                            comment.deleted = true;  // ✅ 삭제 플래그
                        }

                        alert("답변이 삭제 되었습니다.");
                    }
                }
            });
        },
        removeCommentFromTree(list, commentNo) {
            for (let i = 0; i < list.length; i++) {
                const item = list[i];
                if (String(item.commentNo) === String(commentNo)) {
                    list.splice(i, 1); // 현재 위치에서 삭제
                    return true;
                }
                if (item.children) {
                    const removed = this.removeCommentFromTree(item.children, commentNo);
                    if (removed) return true;
                }
            }
            return false;
        },
        fnAccept() {
            var self = this;
            if (!confirm("채택하시겠습니까? 채택 후 수정 / 삭제는 불가능합니다.")) {
                return;
            }
            $.ajax({
                url: "/request/accept.dox",
                type: "POST",
                dataType: "json",
                data: { requestNo: self.requestNo },
                success: function(data) {
                    if (data.num > 0) {
                        alert("답변이 채택 되었습니다.");
                        self.fnview();
                    }
                }
            });
        },

        getExchangeRates() {
            const self = this;
            $.ajax({
                url: "/exchangeRate/all",
                type: "GET",
                dataType: "json",
                success(data) {
                    console.log(data);
                    self.exchangeRateMap.USD = data.USD;
                    self.exchangeRateMap.JPY = data.JPY;
                    self.exchangeRateMap.CNY = data.CNY;
                },
                error() {
                    alert("환율 정보를 불러오는 데 실패했습니다.");
                }
            });
        },

        getConvertedBudgetToKRW() {
            const self = this;

            const rawBudget = self.info.budget;
            if (!rawBudget) return 0;

            const budgetNumber = parseFloat(String(rawBudget).replace(/,/g, ''));
            if (isNaN(budgetNumber)) return 0;

            console.log("budget:", rawBudget);
            console.log("parsed:", budgetNumber);
            console.log("rate:", self.exchangeRateMap[self.info.currency]);

            if (self.info.currency === 'KRW') {
                return budgetNumber;
            } else if (self.exchangeRateMap[self.info.currency]) {
                return Math.round(budgetNumber * self.exchangeRateMap[self.info.currency]);
            } else {
                return 0;
            }
        }

    },
    mounted() {
        const params = new URLSearchParams(window.location.search);
        this.requestNo = params.get("requestNo") || "";
        this.fnview();
        this.getExchangeRates();
    }
});
app.component('comment-item', commentItem);
app.mount('#app');
</script>
