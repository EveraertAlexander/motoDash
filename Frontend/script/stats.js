"use strict";
const socket = io(`http://${lanIP}`);

//#region ***  DOM references ***
let html_rideselect
let html_ridedate, html_rideduration, html_ridename, html_description;
let html_max_angle, html_avg_temp, html_max_temp, html_max_accel, html_max_decel;
let html_avg_temp_bar, html_max_temp_bar, html_max_accel_bar, html_max_decel_bar;
let html_rideinfo;
let html_buttonholder;
let html_chartselect;

let chart_labels, chart_data;
let ride_history;

const map_value = function(value, left_end, right_end, left_start = 0, right_start = 0) {
    const mapped = (value - left_start) / (left_end - left_start) * (right_end - right_start) + right_start
    return mapped;
}

//#region ***  Callback-Visualisation - show___ ***
const showRides = function(jsonObject) {
    console.log(jsonObject)

    let htmlString = ''

    for (const ride of jsonObject.rides.reverse()) {
        const rideid = ride.rideid
        const ridename = ride.ridename

        htmlString += `<option value="${ridename}" id="${rideid}">${ridename}</option>`
    }

    html_rideselect.innerHTML = htmlString;
    getRideStats(html_rideselect.options[html_rideselect.selectedIndex].id)
    getRideHistory(html_rideselect.options[html_rideselect.selectedIndex].id)
    listenToSelectRide()
}

const showRideStats = function(jsonObject) {
    console.log(jsonObject)
    const ridedate = jsonObject.stats.startdate
    const duration = jsonObject.stats.ride_duration
    const name = jsonObject.stats.ridename
    const description = jsonObject.stats.description
    const maxangle = jsonObject.stats.max_angle
    const avg_temp = jsonObject.stats.avg_temp
    const max_temp = jsonObject.stats.max_temp
    const max_accel = jsonObject.stats.max_accel
    const min_accel = jsonObject.stats.min_accel

    const avg_temp_width = map_value(avg_temp, 35, 100, 0, 0)
    const max_temp_width = map_value(max_temp, 35, 100)
    const max_accel_width = map_value(max_accel, 10, 100)
    const min_accel_width = map_value(min_accel, -10, 100)


    html_ridedate.innerHTML = `RIDE FROM ${ridedate}`
    html_rideduration.innerHTML = `Duration: ${duration}`
    html_ridename.innerHTML = name
    html_description.innerHTML = description
    html_max_angle.innerHTML = `${maxangle}°`

    html_avg_temp.innerHTML = `${Math.round(avg_temp)}°C`
    html_avg_temp.style.left = `${avg_temp_width + 5}%`
    html_avg_temp_bar.style.width = `${avg_temp_width}%`

    html_max_temp.innerHTML = `${Math.round(max_temp)}°C`
    html_max_temp.style.left = `${max_temp_width + 5}%`
    html_max_temp_bar.style.width = `${max_temp_width}%`

    html_max_accel.innerHTML = `${max_accel}m/s²`
    html_max_accel.style.left = `${max_accel_width + 5}%`
    html_max_accel_bar.style.width = `${max_accel_width}%`

    html_max_decel.innerHTML = `${min_accel}m/s²`
    html_max_decel.style.left = `${min_accel_width + 5}%`
    html_max_decel_bar.style.width = `${min_accel_width}%`


}

const showConfirmScreen = function() {
    document.querySelector("html").classList.add("has-confirm-screen")
}

const removeConfirmScreen = function() {
    document.querySelector("html").classList.remove("has-confirm-screen")
}

const showChart = function(action) {
    var lineChartParent = document.querySelector('.js-chartcontainer')
    lineChartParent.innerHTML = ''

    chart_labels = []
    chart_data = []

    for (const log of ride_history.history) {
        if (log.actionid == action) {
            let date = new Date(log.date)
            chart_labels.push(log.date)
            chart_data.push({ x: date, y: log.value })
        }
    }

    lineChartParent.innerHTML = `<canvas id="myChart" class='js-chart'></canvas>`
    var currentWindowHeight = window.innerHeight
    var canvas = document.getElementById("myChart")
    var chartHeight = currentWindowHeight - 300
    canvas.width = lineChartParent.clientWidth;
    canvas.height = chartHeight;
    drawChart(chart_labels, chart_data);

}

const drawChart = function(labels, data) {
    let ctx = document.querySelector('.js-chart').getContext('2d');

    var myChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: 'Angle',
                data: data,
                backgroundColor: 'rgba(242, 110, 80, 0.2)',
                borderColor: '#F26E50',
                borderWidth: 1
            }]
        },
        options: {

            legend: {
                display: false
            },
            scales: {
                xAxes: [{
                    display: true,
                    type: 'time',
                    time: {
                        tooltipFormat: 'YYYY-MM-DD HH:mm',
                        displayFormats: {
                            second: 'HH:mm:ss',
                            minute: 'HH:mm',
                            hour: 'HH'
                        }
                    },
                    ticks: {
                        autoSkip: true,
                        maxTicksLimit: 10
                    }
                }],
                yAxes: [{
                    display: true,
                }]
            }
        }
    });
}


//#endregion

//#region ***  Callback-No Visualisation - callback___  ***
const callbackDeleteRide = function(jsonObject) {
    console.log("Rit verwijderd")
}

const callbackUpdateRide = function() {
    console.log("rit geupdated")
}

const callbackGetRideHistory = function(jsonObject) {
        ride_history = jsonObject;
        showChart("TEMP")
        listenToClickSelectChart();
    }
    //#endregion

//#region ***  Data Access - get___ ***
const getRides = function() {
    handleData(`http://${lanIP}/api/v1/rides`, showRides)
}

const getRideStats = function(rideid) {
    handleData(`http://${lanIP}/api/v1/rides/${rideid}`, showRideStats)
}

const getRideHistory = function(rideid) {
        handleData(`http://${lanIP}/api/v1/rides/${rideid}/history`, callbackGetRideHistory)
    }
    //#endregion

//#region ***  Event Listeners - listenTo___ ***
const listenToSelectRide = function() {
    html_rideselect.addEventListener("change", function() {
        const selectedride = html_rideselect.options[html_rideselect.selectedIndex].id;
        getRideStats(selectedride)
        getRideHistory(selectedride)
    })
}

const listenToClickEditBtn = function() {
    document.querySelector(".js-editbtn").addEventListener("click", function() {
        html_rideinfo.innerHTML = `<input class="u-max-width-xs u-mb-sm js-ridename" type="text" value="${html_ridename.innerHTML}">
                                        <input class="u-max-width-xs u-mb-sm js-ridedescription" type="text" value="${html_description.innerHTML}">`

        html_buttonholder.innerHTML = `<div class="c-check-btn">
            <svg class="js-checkbtn" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 17 17">
                <path d="M15.418 1.774l-8.833 13.485-4.918-4.386 0.666-0.746 4.051 3.614 8.198-12.515 0.836 0.548z"/>
            </svg>
            </div>
            <div class="c-delete-btn">
                <svg class="js-deletebtn" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 17 17">
                    <path d="M10.935 2.016c-0.218-0.869-0.999-1.516-1.935-1.516-0.932 0-1.71 0.643-1.931 1.516h-3.569v1h11v-1h-3.565zM9 1.5c0.382 0 0.705 0.221 0.875 0.516h-1.733c0.172-0.303 0.485-0.516 0.858-0.516zM13 4h1v10.516c0 0.827-0.673 1.5-1.5 1.5h-7c-0.827 0-1.5-0.673-1.5-1.5v-10.516h1v10.516c0 0.275 0.224 0.5 0.5 0.5h7c0.276 0 0.5-0.225 0.5-0.5v-10.516zM8 5v8h-1v-8h1zM11 5v8h-1v-8h1z" />
                </svg>
            </div>`

        listenToClickDeleteBtn();
        listenToClickCheckBtn();
    })
}

const listenToClickDeleteBtn = function() {
    document.querySelector(".js-deletebtn").addEventListener("click", function() {
        const rideid = html_rideselect.options[html_rideselect.selectedIndex].id
        showConfirmScreen();
        listenToClickConfirmDelete(rideid);

    })
}

const listenToClickCheckBtn = function() {
    document.querySelector(".js-checkbtn").addEventListener("click", function() {
        let ridename = document.querySelector(".js-ridename").value
        let ridedescription = document.querySelector(".js-ridedescription").value
        let currentrideid = html_rideselect.options[html_rideselect.selectedIndex].id

        let jsonObject = {
            ridename: ridename,
            ridedescription: ridedescription
        }

        handleData(`http://${lanIP}/api/v1/rides/${currentrideid}`, callbackUpdateRide, null, "PUT", JSON.stringify(jsonObject))

        location.reload();


    })
}

const listenToClickConfirmDelete = function(rideid) {
    document.querySelector(".js-confirmbtn").addEventListener("click", function() {
        handleData(`http://${lanIP}/api/v1/rides/${rideid}`, callbackDeleteRide, null, "DELETE")
        removeConfirmScreen()
        location.reload()
    })
    document.querySelector(".js-cancelbtn").addEventListener("click", function() {
        removeConfirmScreen()
    })
}

const listenToClickSelectChart = function() {
    html_chartselect.addEventListener("change", function() {
        const selectedChart = html_chartselect.options[html_chartselect.selectedIndex].value;
        showChart(selectedChart);
    })
}

const listenToSocket = function() {
        socket.on("B2F_client_connected", function() {
            init_stats();
        });
    }
    //#endregion

//#region ***  INIT / DOMContentLoaded  ***
const init_stats = function() {
    console.log("stats page initiated!");
    html_rideselect = document.querySelector(".js-rideselect")
    html_ridedate = document.querySelector(".js-ridedate")
    html_rideduration = document.querySelector(".js-rideduration")
    html_ridename = document.querySelector(".js-ridename")
    html_description = document.querySelector(".js-description")
    html_max_accel = document.querySelector(".js-max-accel");
    html_avg_temp = document.querySelector(".js-avg-temp");
    html_max_temp = document.querySelector(".js-max-temp");
    html_max_angle = document.querySelector(".js-max-angle");
    html_max_decel = document.querySelector(".js-max-decel");
    html_max_accel_bar = document.querySelector(".js-max-accel-bar");
    html_avg_temp_bar = document.querySelector(".js-avg-temp-bar");
    html_max_temp_bar = document.querySelector(".js-max-temp-bar");
    html_max_decel_bar = document.querySelector(".js-max-decel-bar");
    html_rideinfo = document.querySelector(".js-rideinfo")
    html_buttonholder = document.querySelector(".js-buttonholder")
    html_chartselect = document.querySelector(".js-chartselect")

    getRides()
    listenToClickEditBtn();
};

document.addEventListener("DOMContentLoaded", function() {
    console.log("DOM loaded")
    listenToSocket();
});
//#endregion