
$(document).ready(function() {
    console.log("[E]$(document).ready]");
    window.setInterval(timeInterval1000, 1000);
    // $("#sync1").click(function(){ $(this).css('animation-name') == "G2R_keyframe"; });
    // initMQTT();
    gHTML();
    bindEvents();
    initWSBTN();
    initChart();
   

});



window.onload = function() {
    console.log("[window.onload]");


};
$(function() {
    console.log("[E]$(function)]");
});
$(window).load(function() {
    console.log("[E]$(window).load]");

});

function timeInterval1000() {
    // console.log("[INFO][timeInterval1000XXX]");
    // var text=$("#textareaX").val();
    // console.log("[DEBUG] textareaX="+ text);
    // doSendWS("from_mobile",text);
    // $("#output").append(" [T]"+new Date().getMilliseconds());
    // window.ctx.update();
    // $("#sync1").css("animation-name") == "G2R_keyframe";
    // $("#sync1").toggle();
}
function parseData(url, callBack) {
    Papa.parse(url, {
        download: true,
        dynamicTyping: true,
        complete: function(results) {
            callBack(results.data);
        }
    });
}