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
	<title>요청 등록</title>
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
            <button @click="fnSave">저장</button>
        </div>
	</div>
</body>

<script>
const app = Vue.createApp({
    data() {
        return {
            title: "",
            contents: "",
            region: "",
            budget: "",
            sessionId: "${sessionId}"
        };
    },
    methods: {
        fnSave() {
            var self = this;
            var nparmap = {
                title: self.title,
                contents: self.contents,
                userNo: self.sessionId,
                region: self.region,
                budget: self.budget
            };
            $.ajax({
                url: "/request/add.dox",
                type: "POST",
                dataType: "json",
                data: nparmap,
                success: function(data) {
                    console.log(data);
                    if (data.num > 0) {
                        alert("입력되었습니다.");
                        location.href = "/request/list.do";
                    }
                }
            });
        }
    }, 
    mounted() {
        var self = this;
        var quill = new Quill('#editor', {
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
    }
});

app.mount('#app');
</script>
