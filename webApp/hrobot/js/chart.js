var config;
function initChart() {
    window.chartColors = {
        red: 'rgb(255, 99, 132)',
        orange: 'rgb(255, 159, 64)',
        yellow: 'rgb(255, 205, 86)',
        green: 'rgb(75, 192, 192)',
        blue: 'rgb(54, 162, 235)',
        purple: 'rgb(153, 102, 255)',
        grey: 'rgb(201, 203, 207)'
    };
    config = {
        type: 'line',
        ticks: {
            autoSkip: true,
            maxTicksLimit: 10
        },
        data: {
            labels: [],
            datasets: [{
                label: '#目前',
                data: [],
                backgroundColor: window.chartColors.red,
                borderColor: window.chartColors.red,
                fill: false,
                borderWidth: 1
            }, {
                label: '#均速3Hr',
                data: [],
                borderDash: [2, 2],
                backgroundColor: window.chartColors.orange,
                borderColor: window.chartColors.orange,
                fill: false,
                borderWidth: 1
            }, {
                label: '#風神覺得',
                data: [],
                borderDash: [5, 5],
                backgroundColor: window.chartColors.blue,
                borderColor: window.chartColors.blue,
                fill: false,
                borderWidth: 1
            }]
        },
        options: {
            elements: {
                line: {
                    tension: 0.4, // disables bezier curves
                }
            },
            scales: {
                yAxes: [{
                    ticks: {
                        beginAtZero: false

                    }
                }]
            }
        }
    };
    var configOK = initConfig(config);
    var ctx = document.getElementById("myChart").getContext('2d');
    window.myLine = new Chart(ctx, configOK);
}
var avgWindSpeed=1.0;
var sofarMaxWindSpeedAvg=1.0;
var totalWindSpeed=0;
var totalTimesWindSpeed=0;
var lowpassFilterValue=0.8;
var lowpassFilterValue2=1.6;
function pushNewWindSpeed(timestamp,s){
    var splitTime=timestamp.split("_");
    var tLables=splitTime[3]+":"+splitTime[4]+":"+splitTime[5];

    config.data.labels.push(tLables);
    config.data.datasets[0].data.push(s);
    totalWindSpeed+=parseFloat(s);
    totalTimesWindSpeed++;
    avgWindSpeed=totalWindSpeed/totalTimesWindSpeed;

    // avgWindSpeed=valueApproach(avgWindSpeed,s,lowpassFilterValue);
    // console.log(totalWindSpeed+"/"+totalTimesWindSpeed+"="+avgWindSpeed);
    config.data.datasets[1].data.push(avgWindSpeed);
    // console.log(config.data.datasets);
    sofarMaxWindSpeedAvg=(avgWindSpeed+pickMaxWS_Ben(config.data.datasets[0]))/2.0;
    pickMaxWS(window.myLine);
    // sofarMaxWindSpeedAvg=(avgWindSpeed+pickMaxWS(window.myLine))/2.0;
    sofarMaxWindSpeedAvg*=lowpassFilterValue2;

    config.data.datasets[2].data.push(sofarMaxWindSpeedAvg);
    // if(){
        removeData(window.myLine);
    // }
    window.myLine.update();
    // showLog();
    // console.log("push windSpeed "+s);
}
function showLog(){
    var lastIndex=(config.data.datasets[0].data.length-1);
    var v1=config.data.datasets[0].data[lastIndex];
    var v2=config.data.datasets[1].data[lastIndex];
    var v3=config.data.datasets[2].data[lastIndex];
    console.log("now="+v1+",v2="+v2+",v3="+v3);
}
function initConfig(configx) {

    for (var i = 0; i < minXnums; i++) {
        configx.data.labels.push( (i )+":00");

    }
    for (var dsIndex = 0; dsIndex <= 2; dsIndex++) {
        for (var i = 0; i < minXnums; i++) {
            if (configx.data.datasets[dsIndex].data[i] == null) {
                configx.data.datasets[dsIndex].data.push(0);
            }
        }
    }
    console.log(configx);
    return configx;
}
function pickMaxWS_Ben(datasets) {
    var maxS=0;
    datasets.data.forEach((data) => {
        maxS=Math.max(maxS,data);
    });
    // console.log("pickMaxWS="+maxS);

    return maxS;
    // chart.update();
}
function pickMaxWS(chart) {

    var maxS=0;
    chart.data.datasets.forEach((dataset) => {
        maxS=Math.max(maxS,parseFloat(dataset.data));
    });
    // console.log("Wrong pickMaxWS="+maxS);
    return maxS;
    // chart.update();
}
function valueApproach(nowVal, destVal,speed) { // speed=0-1
    return  ((nowVal * (1.0 - speed)) + (destVal * speed));
}
var minXnums=10;
var maxXnums=20;
function removeData(chart) {
    // console.log("Len="+chart.data.labels.length);
    if(chart.data.labels.length<maxXnums)return;
        chart.data.labels.shift();
    chart.data.datasets.forEach((dataset) => {
        dataset.data.shift();
    });
    // chart.update();
}
export default initChart;