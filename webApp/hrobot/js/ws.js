// autossh -M 5678 ubuntu@flora.decade.tw -R 2288:192.168.168.88:22 -R 5988:192.168.168.88:5900 -R 2266:192.168.168.66:22 -R 5966:192.168.168.66:5900 -R 2299:192.168.168.99:22 -R 5999:192.168.168.99:5900 -R 8095:192.168.168.95:80 -R 8001:192.168.168.1:80 -R 8033:192.168.168.33:80 -R 8833:192.168.168.33:8080 -R 8133:192.168.168.33:8181 -R 55433:192.168.168.33:554

// var wsUri22 = "ws://127.0.0.1:8000/solar_wss";

var peopleA = 512;
var peopleB = 0;
var peopleC = 1522;
var wsUri = "ws://flora.decade.tw:9999/hrobotgod";
var output;

function init() {

    output = document.getElementById("output");
    websocket = new WebSocket(wsUri);
    websocket.onopen = function(evt) {
        onOpen(evt)
    };
    websocket.onclose = function(evt) {
        onClose(evt)
    };
    websocket.onmessage = function(evt) {
        onMessage(evt)
    };
    websocket.onerror = function(evt) {
        onError(evt)
    };
}

function onOpen(evt) {
    writeToScreen("CONNECTED");
    doSendInfo("WebSocket rocks");
}

function onClose(evt) {
    writeToScreen("DISCONNECTED");
    init();
    writeToScreen("...RE-CONNECTED");
}

function fullS() {
    if (navigator.userAgent.match(/Android/i)) {
        window.scrollTo(0, 1);
    }
}

function bulbActionByID(idx, v) {
    if (v == 0)
        $('#' + idx).css("background-color", "rgba(255, 255, 0, 0.1)");
    else
        $('#' + idx).css("background-color", "rgba(255, 255, 0, 1)");
}

function onMessage(evt) {
    var data = $.parseJSON(evt.data);
    // console.log("[WS][][onMessage]" + evt.data);
    // RESPONSE: { "ip": "127.0.1.1", "name": "PI_IR_01", "IR": false, "id": 1, "people": 0, "hostnameX": "rpi3_x1" }
    // if(data==null)return;
    // if(data.type!="motorboss")return;
    if (data.jsonArray_motors != null) {//active motor mapping data
        for (var y = 0; y < data.jsonArray_motors.length; y++) {
            $('#bulb' + y).css('opacity', 0.05 + (data.jsonArray_motors[y] / 255));
        }
    }

    if ($("#statusLEDAll").css('animation-name') == "G2R_keyframe") {
        $("#statusLEDAll").css('animation-name', "G2R_keyframe2");
        $("#statusLEDMQTT").css('animation-name', "G2R_keyframe2");

    } else {
        $("#statusLEDMQTT").css('animation-name', "G2R_keyframe");
        $("#statusLEDAll").css('animation-name', "G2R_keyframe");
    }


    if(data.HB=="MB"){
        if ($("#statusLED_MB").css('animation-name') == "G2R_keyframe")
            $("#statusLED_MB").css('animation-name', "G2R_keyframe2");
        else
            $("#statusLED_MB").css('animation-name', "G2R_keyframe");
        if(data.BYPASS!=null){
            $("#bypassTextarea").val(data.BYPASS);
        }
        if(data.RT_MODE==false){
            if ($("#REALTIME_STATUS").css('animation-name') == "G2R_keyframe")
                $("#REALTIME_STATUS").css('animation-name', "G2R_keyframe2");
            else
                $("#REALTIME_STATUS").css('animation-name', "G2R_keyframe");
        }
        if(data.MB_MODE!=null){
            $("#mb_mode").html(data.MB_MODE);
        }
    }else if(data.HB=="LB"){
        if ($("#statusLED_LB").css('animation-name') == "G2R_keyframe")
            $("#statusLED_LB").css('animation-name', "G2R_keyframe2");
        else
            $("#statusLED_LB").css('animation-name', "G2R_keyframe");
    }else if(data.HB=="EB"){
        if ($("#statusLED_EB").css('animation-name') == "G2R_keyframe")
            $("#statusLED_EB").css('animation-name', "G2R_keyframe2");
        else
            $("#statusLED_EB").css('animation-name', "G2R_keyframe");
    }else if(data.HB=="FG"){
        // console.log(data);
        if ($("#statusLED_FG").css('animation-name') == "G2R_keyframe")
            $("#statusLED_FG").css('animation-name', "G2R_keyframe2");
        else
            $("#statusLED_FG").css('animation-name', "G2R_keyframe");



        checkMPs(data);

        if(data.W_Deg!=W_DegLast&&data.W_Deg!="0"&&data.W_Speed!="0") {
            W_DegLast=data.W_Deg

            $("#wDir").html(data.W_Deg);
            var wSpeed=data.W_Speed.toFixed(2);
            $("#wSpeed").html(wSpeed);

            pushNewWindSpeed(data.STAMPTIME,wSpeed);

            if ($("#WINDstatusLEDSS").css('animation-name') == "G2R_keyframe")
                $("#WINDstatusLEDSS").css('animation-name', "G2R_keyframe2");
            else
                $("#WINDstatusLEDSS").css('animation-name', "G2R_keyframe");
        }
    }


}
var W_DegLast=0;
var MPswNum = [0,23,28,23];
function checkMPs(data){
    var MP_ALL_OK=true;

    for(var i=0;i<MPswNum[1];i++){
        // console.log(i+","+(31-i)+"="+data.BP_MP1.charAt(31-i)+" len"+data.BP_MP1.length);
        if(data.BP_MP1.charAt(31-i)!='1'){
            MP_ALL_OK=false;
            break;
        }
    }
    if( MP_ALL_OK)
        if ($("#MP1_S_leds").css('animation-name') == "G2R_keyframe")
            $("#MP1_S_leds").css('animation-name', "G2R_keyframe2");
        else
            $("#MP1_S_leds").css('animation-name', "G2R_keyframe");

    MP_ALL_OK=true;
    for(var i=0;i<MPswNum[2];i++){
        if(data.BP_MP2.charAt(31-i)!='1'){
            MP_ALL_OK=false;
            break;
        }
    }
    if( MP_ALL_OK)
        if ($("#MP2_N_leds").css('animation-name') == "G2R_keyframe")
            $("#MP2_N_leds").css('animation-name', "G2R_keyframe2");
        else
            $("#MP2_N_leds").css('animation-name', "G2R_keyframe");

    MP_ALL_OK=true;
    for(var i=0;i<MPswNum[3];i++){
        if(data.BP_MP3.charAt(31-i)!='1'){
            MP_ALL_OK=false;
            break;
        }
    }
    if( MP_ALL_OK)
        if ($("#MP3_E_leds").css('animation-name') == "G2R_keyframe")
            $("#MP3_E_leds").css('animation-name', "G2R_keyframe2");
        else
            $("#MP3_E_leds").css('animation-name', "G2R_keyframe");
}
function onError(evt) {
    writeToScreen('<span style="color: red;">ERROR:</span> ' + evt.data);
}
var clientIP = "x.x.x.x";
$.getJSON('http://api.ipify.org?format=jsonp&callback=?', function(data) {
    // clientIP=JSON.stringify(data, null, 2);
    clientIP = data.ip;
});
// function doSendWS_chgFont(message) {
//     doSendWS("chgFont", message);
// }
function doSendInfo(message) {
    doSendWS("info", message);
}

function doSendWS(type, message) {
    var date = new Date().toLocaleDateString("en-US", {
        "year": "numeric",
        "month": "numeric",
        "day": "numeric",
        "hour": "numeric",
        "minute": "numeric",
        "second": "numeric"
    });
    var msgx = {
        id: 7213,
        ip: clientIP,
        type: type,
        text: message,
        date: date
    };
    // writeToScreen(JSON.stringify(msg));
    websocket.send(JSON.stringify(msgx));
    lineline(msgx);
}
function lineline(mmm){
    $.post('https://script.google.com/macros/s/AKfycby1kbxrzwGBg1TrUKhQDmqAFCit2bdx9tSTD63l-oz9TjZqTMuk/exec',
        {msg:mmm},
        function(e){
            console.log("[xlinx][line]");
            console.log(e);
        });
}
function writeToScreen(message) {
    var pre = document.createElement("p");
    pre.style.wordWrap = "break-word";
    pre.innerHTML = message;
    document.getElementById("output").appendChild(pre);
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
    $('a[role*="slider"]').touchend(function(event, ui) {
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

function maxXnums_ValueChange() {
    var sv = $('#maxXnums').val();
    console.log("maxXnums--->" +sv);
    maxXnums=sv;

}
function fg_wind_voice_sec(){
    var sv = $('#fg_wind_voice_sec').val();
    doSendWS("ws_cue","/cue/fg/fg_wind_voice_sec/"+sv);
}
function fg_wind_speed_limit_max(){
    var sv = $('#fg_wind_speed_limit_max').val();
    doSendWS("ws_cue","/cue/fg/fg_wind_speed_limit_max/"+sv);
}
function fg_wind_speed_limit_max_sec(){
    var sv = $('#fg_wind_speed_limit_max_sec').val();
    doSendWS("ws_cue","/cue/fg/fg_wind_speed_limit_max_sec/"+sv);
}
function fg_wind_speed_limit_min(){
    var sv = $('#fg_wind_speed_limit_min').val();
    doSendWS("ws_cue","/cue/fg/fg_wind_speed_limit_min/"+sv);
}
function fg_wind_speed_limit_min_sec(){
    var sv = $('#fg_wind_speed_limit_min_sec').val();
    doSendWS("ws_cue","/cue/fg/fg_wind_speed_limit_min_sec/"+sv);
}
function fg_wind_feels(){
    var sv = $('#fg_wind_feels').val();
    doSendWS("ws_cue","/cue/fg/fg_wind_feels/"+sv);
}

function lowpassFilterValueChange(){
    var sv = $('#lowpassFilter').val();
    console.log("LPFilter1--->" +sv);
    lowpassFilterValue=sv;
}
function lowpassFilterValueChange2(){
    var sv = $('#lowpassFilter2').val();
    console.log("WG_Feels_Filter1--->" +sv);
    lowpassFilterValue2=sv;
}
function valueChanged() {
    var SliderValue = $('.sliders').val();
    // // alert("Slider value = " + SliderValue);
    // var msg = "/" + $(this).attr("id")+"/"+SliderValue;
    // doSendWS("ws_cue",msg);
    console.log("SliderValue--->" +SliderValue);
}
window.addEventListener("load", init, false);