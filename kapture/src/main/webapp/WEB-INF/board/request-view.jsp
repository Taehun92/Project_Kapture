<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <link rel="stylesheet" href="../../css/request.css">
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
                    <td>{{ info.budget }}</td>
                </tr>
                <tr>
                    <th>내용</th>
                    <td colspan="3">
                        <div v-html="info.description"></div>
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
            <div v-if="canEditRequest">
                <button class="request-btn" @click="fnEdit">수정</button>
                <button class="request-btn" @click="fnRemove">삭제</button>
            </div>
        </section>

        <hr>

        <!-- 댓글 및 대댓글 영역 -->
        <section>
            <div v-for="comment in getNestedComments(null)" :key="comment.commentNo" class="comment-box">
                <strong>{{ comment.userFirstName }} {{ comment.userLastName }}</strong> : {{ comment.message }}
                <div class="comment-buttons">
                    <span v-if="canEditComment(comment)">
                        <button @click="fnEditComment(comment)">수정</button>
                        <button @click="fnRemoveComment(comment.commentNo)">삭제</button>
                    </span>
                    <span v-if="canAccept">
                        <button @click="fnAccept">채택</button>
                    </span>
                    <button v-if="comment.status == '1'" @click="fnReply(comment.commentNo)">대댓글</button>
                </div>

                <div v-for="reply in getNestedComments(comment.commentNo)" :key="reply.commentNo" class="reply-box">
                    <strong>{{ reply.userFirstName }} {{ reply.userLastName }}</strong> : {{ reply.message }}
                    <div class="comment-buttons">
                        <span v-if="canEditComment(reply)">
                            <button @click="fnEditComment(reply)">수정</button>
                            <button @click="fnRemoveComment(reply.commentNo)">삭제</button>
                        </span>
                        <span v-if="canAccept">
                            <button @click="fnAccept">채택</button>
                        </span>
                        <button @click="fnReply(reply.commentNo)">대댓글</button>
                    </div>
                </div>
            </div>
            <div v-if="replyFlg" class="comment-box">
                <input v-model="reply" placeholder="댓글 입력" style="width: 70%">
                <button @click="fnAddReply">저장</button>
                <button @click="fnBack">취소</button>
            </div>
        </section>

        <!-- 답변 작성 영역 -->
        <section v-if="canWriteAnswer" class="answer-box">
            <button @click="fnAnswer">답변쓰기</button>
        </section>
        <section v-if="answerFlg" class="answer-box">
            <div>
                {{ sessionFirstName }} {{ sessionLastName }} :
                <textarea v-model="answerComment" rows="6"></textarea>
            </div>
            <div>
                <button @click="fnCommentSave">작성</button>
                <button @click="fnBack">취소</button>
            </div>
        </section>
	</div>
    <jsp:include page="../common/footer.jsp" />
</body>

<script>
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
            reply : ""
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
        getNestedComments(parentNo) {
            if (!Array.isArray(this.commentList)) return [];
            return this.commentList.filter(item => item.parentCommentNo == parentNo);
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
                    self.commentList = data.commentList;
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
        fnCommentSave() {
            var self = this;
            $.ajax({
                url: "/request/comment/add.dox",
                type: "POST",
                dataType: "json",
                data: {
                    requestNo: self.requestNo,
                    userId: self.sessionId,
                    comments: self.answerComment,
                    commentNo: null
                },
                success: function(data) {
                    alert("답변이 등록 되었습니다.");
                    self.answerComment = "";
                    self.answerFlg = false;
                    self.fnview();
                }
            });
        },
        fnEditComment(comment) {
            this.editComment = comment.message;
            this.commentFlg = true;
            this.commentNo = comment.commentNo;
        },
        fnUpdateComment(commentNo) {
            var self = this;
            $.ajax({
                url: "/request/comment/edit.dox",
                type: "POST",
                dataType: "json",
                data: { commentNo: commentNo, comments: self.editComment },
                success: function(data) {
                    if (data.num > 0) {
                        alert("답변이 수정 되었습니다.");
                        self.commentFlg = false;
                        self.fnview();
                    }
                }
            });
        },
        fnRemoveComment(commentNo) {
            var self = this;
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
                        alert("답변이 삭제 되었습니다.");
                        self.fnview();
                    }
                }
            });
        },
        fnReply(commentNo) {
            this.commentNo = commentNo;
            this.replyFlg = true;
        },
        fnAddReply() {
            var self = this;
            $.ajax({
                url: "/request/comment/add.dox",
                type: "POST",
                dataType: "json",
                data: {
                    requestNo: self.requestNo,
                    userId: self.sessionId,
                    commentNo: self.commentNo,
                    comments: self.reply
                },
                success: function(data) {
                    if (data.num > 0) {
                        alert("댓글이 등록 되었습니다.");
                        self.fnview();
                        self.replyFlg = false;
                        self.reply = "";
                    }
                }
            });
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
        }
    },
    mounted() {
        const params = new URLSearchParams(window.location.search);
        this.requestNo = params.get("requestNo") || "";
        this.fnview();
        
    }
});

app.mount('#app');
</script>
