<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/quill@1.3.7/dist/quill.snow.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/quill@1.3.7/dist/quill.min.js"></script>
	<title>요청 수정</title>
</head>
<body>
	<div id="app">
        <table>
            <tr>
                <th>제목 :</th>
                <td colspan="3"><input v-model="title" /></td>
            </tr>
            <tr>
                <th>지역 :</th>
                <td><input v-model="region" /></td>
                <th>예산 :</th>
                <td><input v-model="budget" /></td>
            </tr>
            <tr>
                <th>내용 :</th>
                <td colspan="3">
                    <div id="editor" style="width: 800px; height: 400px;"></div>
                </td>
            </tr>
        </table>
        <div style="margin-top: 20px;">
            <button @click="fnEdit">저장</button>
            <button @click="fnBack">취소</button>
        </div>
	</div>
</body>

<script>
const app = Vue.createApp({
    data() {
        return {
            requestNo: "${map.requestNo}",
            info: {},
            title: "",
            contents: "",
            region: "",
            budget: ""
        };
    },
    methods: {
        fnview() {
            var self = this;
            $.ajax({
                url: "/request/view.dox",
                type: "POST",
                dataType: "json",
                data: { requestNo: self.requestNo },
                success: function(data) {
                    self.title = data.info.title;
                    self.contents = data.info.description;
                    self.region = data.info.region;
                    self.budget = data.info.budget;
                    self.$nextTick(function() {
                        quill.root.innerHTML = self.contents;
                    });
                }
            });
        },
        fnEdit() {
            var self = this;
            var nparmap = {
                title: self.title,
                contents: self.contents,
                requestNo: self.requestNo,
                region: self.region,
                budget: self.budget
            };
            $.ajax({
                url: "/request/edit.dox",
                type: "POST",
                dataType: "json",
                data: nparmap,
                success: function(data) {
                    if (data.num > 0) {
                        alert("수정되었습니다.");
                        location.href = "/request/view.do?requestNo=" + self.requestNo;
                    }
                }
            });
        },
        fnBack() {
            history.back();
        }
    },
    mounted() {
        var self = this;

        window.quill = new Quill('#editor', {
            theme: 'snow',
            modules: {
                toolbar: [
                    [{ 'header': [1, 2, 3, false] }],
                    ['bold', 'italic', 'underline'],
                    [{ 'list': 'ordered' }, { 'list': 'bullet' }],
                    ['link', 'image'],
                    [{ 'color': [] }, { 'background': [] }],
                    [{ 'align': [] }],
                    ['clean']
                ]
            }
        });

        quill.on('text-change', function() {
            self.contents = quill.root.innerHTML;
        });

        self.fnview();
    }
});

app.mount('#app');
</script>
