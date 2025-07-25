<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/vue@3.5.13/dist/vue.global.min.js"></script>
        <script src="https://unpkg.com/vue-star-rating@next/dist/VueStarRating.umd.min.js"></script>
        <title>Vue 별점</title>
    </head>
    <style>
        body {
            font-family: 'Raleway', sans-serif;
        }

        .custom-text {
            font-weight: bold;
            font-size: 1.9em;
            border: 1px solid #cfcfcf;
            padding-left: 10px;
            padding-right: 10px;
            border-radius: 5px;
            color: #999;
            background: #fff;
        }
    </style>

    <body>

        <div id="app">
            <h1>Vue Star Rating for Vue 3.x</h1>


            <h2>리뷰 등록시 별점</h2>
            <star-rating :increment="0.5" :star-size="20" :border-width="5" :show-rating="false"
                :rounded-corners="true"></star-rating>

            <h2>등록된 리뷰 별점</h2>
            <star-rating :rating="3.8" :read-only="true" :star-size="20" :increment="0.01" :border-width="5" :show-rating="false"
                :rounded-corners="true"></star-rating>

            <h2>평균 별점</h2>
            <star-rating :rating="3.8" :read-only="true" :increment="0.01" :border-width="5" :show-rating="false"
                :rounded-corners="true"></star-rating>

            <h2>Default</h2>
            <star-rating></star-rating>

            <h2>Half Stars</h2>
            <star-rating :increment="0.5"></star-rating>

            <h2>Red Stars</h2>
            <star-rating active-color="#9c0000"></star-rating>

            <h2>Vibrant Stars</h2>
            <star-rating inactive-color="#e1bad9" active-color="#cc1166"></star-rating>

            <h2>Small Stars</h2>
            <star-rating :star-size="20"></star-rating>

            <h2>Big Stars</h2>
            <star-rating :star-size="90"></star-rating>

            <h2>Bordered Stars</h2>
            <star-rating :border-width="5"></star-rating>

            <h2>Fluid Stars</h2>
            <star-rating :increment="0.01"></star-rating>

            <h2>Preset Stars</h2>
            <star-rating :rating="4"></star-rating>

            <h2>Non rounded start rating</h2>
            <star-rating :rating="4.67" :round-start-rating="false"></star-rating>

            <h2>Read Only Stars</h2>
            <star-rating :rating="3.8" :read-only="true" :increment="0.01"></star-rating>

            <h2>Lots of stars</h2>
            <star-rating :max-rating="10" :star-size="20"></star-rating>

            <h2>Right To Left</h2>
            <star-rating :rtl="true" :increment="0.01"></star-rating>

            <h2>Style Rating</h2>
            <star-rating text-class="custom-text"></star-rating>

            <h2>Hide Rating</h2>
            <star-rating :show-rating="false"></star-rating>

            <h2>Capture Rating</h2>
            <star-rating :show-rating="false" @update:rating="rating = $event"></star-rating>
            <div style="margin-top:10px;font-weight:bold;">{{currentRatingText}}</div>

            <h2>Capture Mouse Over Rating</h2>
            <div @mouseleave="mouseOverRating = null" style="display:inline-block;">
                <star-rating :show-rating="false" @hover:rating="mouseOverRating = $event"
                    :increment="0.5"></star-rating>
            </div>
            <div style="margin-top:10px;font-weight:bold;">{{mouseOverRatingText}}</div>

            <h2>Resetable stars with v-model</h2>
            <div style="display:inline-block;">
                <star-rating v-model:rating="resetableRating"></star-rating>
                <div style="padding-top:10px;cursor:pointer;margin-bottom:20px;color: blue;"><a
                        @click="resetableRating = 0;">Reset
                        Rating</a></div>
            </div>

            <h2>Inline Stars</h2>
            <div style="display:inline-block;">
                Rated
                <star-rating :inline="true" :star-size="20" :read-only="true" :show-rating="false"
                    :rating="5"></star-rating>
                by our customers.

            </div>

            <h2>Rounded Corners</h2>
            <star-rating :rounded-corners="true" :border-width="6"></star-rating>

            <h2>Custom Stars</h2>

            <star-rating :star-size="50" :rounded-corners="true" :border-width="4"
                :star-points="[23,2, 14,17, 0,19, 10,34, 7,50, 23,43, 38,50, 36,34, 46,19, 31,17]"></star-rating>

            <h2>Animated Stars</h2>
            <star-rating :animate="true" :active-color="['#ae0000','#003333']"
                :active-border-color="['#F6546A','#a8c3c0']" :border-width="4"
                :star-points="[23,2, 14,17, 0,19, 10,34, 7,50, 23,43, 38,50, 36,34, 46,19, 31,17]"
                :active-on-click="true" :clearable="true" :padding="3"></star-rating>

            <h2>Glowing Stars</h2>
            <div style="background:#000;overflow:auto;padding:10px;padding-bottom:20px;">
                <star-rating :star-size="70" :glow="10" glow-color="#ffd055"></star-rating>
            </div>

        </div>

    </body>



    </html>
    <script>
        const app = Vue.createApp({
            data() {
                return {
                    rating: null,
                    resetableRating: 2,
                    currentRating: "No Rating",
                    mouseOverRating: null
                };
            },
            //             components: {
            //   StarRating
            // },
            computed: {
                currentRatingText() {
                    return this.rating
                        ? "You have selected " + this.rating + " stars"
                        : "No rating selected";
                },
                mouseOverRatingText() {
                    return this.mouseOverRating
                        ? "Click to select " + this.mouseOverRating + " stars"
                        : "No Rating";
                }
            }
        });

        // ⭐ VueStarRating을 올바르게 등록

        app.component('star-rating', VueStarRating.default)
        app.mount("#app");
    </script>