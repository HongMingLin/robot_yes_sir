import doSendWS from "./wsocket.js";
function gHTML() {
    var motor700 = "<table class='bulbsTable'>";
    var bulbs = 0;
    var bulbsW = 50;
    var bulbsH = 16;
    for (var y = 0; y < bulbsH; y++) {
        motor700 += "<tr line-height: 1>";
        for (var x = 0; x < bulbsW; x++) {
            motor700 += "<td class=\"bulb_td\">";
            bulbs = y * bulbsW + x;
            motor700 += "<div id=\"bulb" + bulbs + "\" class=\"typeYellow\">";
            motor700 += "<p>" + bulbs + "</p>";
            motor700 += "</div></td>";
        }
        motor700 += "</tr>";
    }
    motor700 += "</table>";
    $("#motors700").html(motor700);

    var h = "<option value=\"0\" selected=\"selected\" >T1</option>";
    var TNES = ["T", "N", "E", "S"];
    var indexx = 1;
    for (var i = 1; i < 4; i++) {
        for (var j = 1; j < 6; j++) {
            h += "<option value=\"" + (indexx++) + "\"" + ">" + TNES[i] + "" + j + "</option>";
        }
    }
// console.log(h);
    $("#JOG_ALL_OPTION").html(h);

    var welcome = ["大家好", "我是花神呦","不要爬","不要在叫了","不要繞圈圈","我是含羞草不要嚇我喔","等我把花打開","風向模式","日照模式","從前從前有一個", "Hiwin", "際峰鈑金", "義力營造",
        "馬達即將啟動","風速判定過大"];
    h = "";
    for (var i = 0; i < welcome.length; i++) {
        h += "<li id=\"cmd/pc/say/" + welcome[i] + "\" class=\"wsbtn\" ><a>" + welcome[i] + "</a></li>";
    }
    $("#talking").html(h);
    bindEvents();
    initWSBTN();
}
function initMQTT(){
    // var mqtt = require('mqtt');

    var client = mqtt.connect('mqtt://FloraGodReader:xlinxxlinx@broker.shiftr.io', {
        clientId: 'javascript'
    });

    client.on('connect', function(){
        console.log('client has connected!');

        client.subscribe('/FloraGodAir');
        // client.unsubscribe('/example');

        setInterval(function(){
            client.publish('/ip', clientIP);
        }, 1000);
    });

    client.on('message', function(topic, message) {
        console.log('new message:', topic, message.toString());
    });
}
function bindEvents() {

    $("#statusLED1").click(function() {
        console.log("gf");
    });


    $('a[role*="slider"]').mouseup(function(event, ui) {
        var thisaddress = $(this).parent().prev().attr("id");
        var thisaddress = "/" + thisaddress;
        var thisccvalue = $(this).attr("aria-valuenow");
        console.log($(this).parent().val());
        console.log($(this).val());
    });

    $('.sliders').change(function() {
        var SliderValue = $(this).val();
        // alert("Slider value = " + SliderValue);

        var msg = "/" + $(this).attr("id") + "/" + SliderValue;
        doSendWS("ws_cue", msg);
        console.log("SliderValue--->" + SliderValue);
    });

}
function initWSBTN() {
    $(".wsbtn").click(function () {
        var msg = "/" + $(this).attr("id");
        // var textAreaValue = $('textarea#TEXT_AREA').val();
        // var thisaddress = thisaddress + textAreaValue;

        if ($(this).attr('id').startsWith("cmd/mb/jog")) {
            var aa = parseInt($('#JOG_ALL_OPTION').val());
            var bb = parseInt($('#JOG_whichMotor').val());

            doSendWS("ws_cue", msg + "/" + (aa * 50 + bb - 1));

        }else if ($(this).attr('id').startsWith("fg_wind_voice_btn")) {

            doSendWS("ws_cue", ""+windgod_say_textarea.value);
        } else if ($(this).attr('id').startsWith("fg_say_btn")) {

            doSendWS("ws_cue", "/cmd/pc/say/"+fg_say_textarea.value);
        }else if ($(this).attr('id').startsWith("fg_udp_btn1")) {

            doSendWS("ws_cue", fg_udp_textarea1.value);
        }else if ($(this).attr('id').startsWith("fg_udp_btn2")) {

            doSendWS("ws_cue", fg_udp_textarea2.value);
        }else if ($(this).attr('id').startsWith("fg_udp_btn3")) {

            doSendWS("ws_cue", fg_udp_textarea3.value);
        }else if ($(this).attr('id').startsWith("fg_udp_btn4")) {

            doSendWS("ws_cue", fg_udp_textarea4.value);
        }else if ($(this).attr('id').startsWith("fg_udp_btn_78")) {

            doSendWS("ws_cue", $('#fg_udp_textarea_71').val());
        }else {
            doSendWS("ws_cue", msg);
        }

    });
}

export default gHTML;