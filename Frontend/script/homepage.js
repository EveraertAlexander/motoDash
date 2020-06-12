"use strict";
const socket = io(`http://${lanIP}`);


//#region ***  DOM references ***
let html_pastrides, html_monthselect, html_editbtn;
let html_max_angle, html_avg_temp, html_max_temp, html_max_accel, html_max_decel;
let html_avg_temp_bar, html_max_temp_bar, html_max_accel_bar, html_max_decel_bar;
//#endregion


const map_value = function(value, left_end, right_end, left_start = 0, right_start = 0) {
    const mapped = (value - left_start) / (left_end - left_start) * (right_end - right_start) + right_start
    return mapped;
}

//#region ***  Callback-Visualisation - show___ ***
const showSummary = function(jsonObject) {
    let htmlString = ''
    console.log(jsonObject)

    for (let ride of jsonObject.summary) {
        const ridename = ride.ridename;
        const rideid = ride.rideid;
        const avg_temp = ride.avg_temp;
        const max_angle = ride.max_angle;
        const date = ride.date

        htmlString += `<div class="o-layout__item u-mb-md u-1-of-2-bp3 js-pastride">
        <div class="o-layout o-layout--justify-space-between o-layout--align-center u-border-bottom-orange">
            <div>
                <p class="c-lead--xl u-mb-sm">${ridename}</p>
                <p class="u-mb-md">${date}</p>
            </div>
            <div class="u-color-grey js-deletebtn" id="${rideid}">
                <p class="u-txt-align-right u-mb-sm">Max Angle: ${max_angle}°</p>
                <p class="u-txt-align-right u-mb-md">Avg Temp: ${Math.round(avg_temp)}°C</p>
            </div>
        </div>
    </div>`

    }
    htmlString += `<div class="o-layout__item u-mb-md u-1-of-2-bp3"></div>`
    html_pastrides.innerHTML = htmlString;
}

const showMonths = function(jsonObject) {
    let htmlString = ''

    for (let month of jsonObject.months.reverse()) {
        month = month.date
        htmlString += `<option class="special" value="${month}">${month}</option>`
    }

    html_monthselect.innerHTML = htmlString;
    const selectedMonth = html_monthselect.options[0].value;
    getMonthSummary(selectedMonth)
    listenToClickSelectMonth();
}

const showMonthSummary = function(jsonObject) {
    console.log(jsonObject);
    const summary = jsonObject.month_summary;
    const max_angle = summary.max_angle
    const avg_temp = summary.avg_temp;
    const max_temp = summary.max_temp;
    const max_accel = summary.max_accel;
    const min_accel = summary.min_accel;

    const avg_temp_width = map_value(avg_temp, 35, 100, 0, 0)
    const max_temp_width = map_value(max_temp, 35, 100)
    const max_accel_width = map_value(max_accel, 10, 100)
    const min_accel_width = map_value(min_accel, -10, 100)


    html_max_angle.innerHTML = `${max_angle}°`

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

const showDeleteButtons = function() {
    const rides = document.querySelectorAll(".js-deletebtn")
    for (const ride of rides) {
        ride.classList.add("c-delete-btn")
        ride.innerHTML = `<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 17 17">
            <path d="M10.935 2.016c-0.218-0.869-0.999-1.516-1.935-1.516-0.932 0-1.71 0.643-1.931 1.516h-3.569v1h11v-1h-3.565zM9 1.5c0.382 0 0.705 0.221 0.875 0.516h-1.733c0.172-0.303 0.485-0.516 0.858-0.516zM13 4h1v10.516c0 0.827-0.673 1.5-1.5 1.5h-7c-0.827 0-1.5-0.673-1.5-1.5v-10.516h1v10.516c0 0.275 0.224 0.5 0.5 0.5h7c0.276 0 0.5-0.225 0.5-0.5v-10.516zM8 5v8h-1v-8h1zM11 5v8h-1v-8h1z" />
        </svg>`
    }

    listenToClickDeleteBtn();
}

const showConfirmScreen = function() {
    document.querySelector("html").classList.add("has-confirm-screen")
}

const removeConfirmScreen = function() {
        document.querySelector("html").classList.remove("has-confirm-screen")
    }
    //#endregion
    //#region ***  Callback-No Visualisation - callback___  ***
const callbackDeleteRide = function(jsonObject) {
        console.log("deleted ride")
    }
    //#endregion

//#region ***  Data Access - get___ ***
const getRideSummaries = function() {
    handleData(`http://${lanIP}/api/v1/rides/summary`, showSummary)
}

const getMonths = function() {
    handleData(`http://${lanIP}/api/v1/months`, showMonths)
}

const getMonthSummary = function(month) {
    handleData(`http://${lanIP}/api/v1/summary/${month}`, showMonthSummary)
}

const deleteRide = function(rideid) {
        handleData(`http://${lanIP}/api/v1/rides/${rideid}`, callbackDeleteRide, null, "DELETE")
    }
    //#endregion

//#region ***  Event Listeners - listenTo___ ***
const listenToClickSelectMonth = function() {
    html_monthselect.addEventListener("change", function() {
        const selectedMonth = html_monthselect.options[html_monthselect.selectedIndex].value;
        getMonthSummary(selectedMonth);
    })
}

const listenToClickEditBtn = function() {
    html_editbtn.addEventListener("click", function() {
        const btnvalue = html_editbtn.getAttribute("value")

        if (btnvalue == 0) {
            html_editbtn.setAttribute("value", 1)
            html_editbtn.innerHTML = "Done"
            showDeleteButtons();
        } else if (btnvalue == 1) {
            html_editbtn.setAttribute("value", 0)
            html_editbtn.innerHTML = "Edit"
            getRideSummaries();
        }
    })
}

const listenToClickDeleteBtn = function() {
    const pastrides = document.querySelectorAll('.js-pastride');

    for (const ride of pastrides) {
        ride.querySelector('.js-deletebtn').addEventListener("click", function() {
            const rideid = this.getAttribute("id")
            showConfirmScreen();
            listenToClickConfirmDelete(rideid, ride);
            // deleteRide(rideid);
            // ride.innerHTML = ''
        })
    }
}

const listenToSocket = function() {
    socket.on("B2F_client_connected", function() {
        init_homepage();
    });
}

const listenToClickConfirmDelete = function(rideid, ride) {
    document.querySelector(".js-confirmbtn").addEventListener("click", function() {
        deleteRide(rideid)
        removeConfirmScreen()
        ride.innerHTML = ''
    })
    document.querySelector(".js-cancelbtn").addEventListener("click", function() {
        removeConfirmScreen()
    })
}

//#endregion

//#region ***  INIT / DOMContentLoaded  ***
const init_homepage = function() {
    console.log("init_homepage initiated!");
    html_pastrides = document.querySelector(".js-pastrides");
    html_monthselect = document.querySelector(".js-selectmonth");
    html_max_accel = document.querySelector(".js-max-accel");
    html_avg_temp = document.querySelector(".js-avg-temp");
    html_max_temp = document.querySelector(".js-max-temp");
    html_max_angle = document.querySelector(".js-max-angle");
    html_max_decel = document.querySelector(".js-max-decel");

    html_max_accel_bar = document.querySelector(".js-max-accel-bar");
    html_avg_temp_bar = document.querySelector(".js-avg-temp-bar");
    html_max_temp_bar = document.querySelector(".js-max-temp-bar");
    html_max_decel_bar = document.querySelector(".js-max-decel-bar");

    html_editbtn = document.querySelector('.js-editbtn');

    getRideSummaries();
    getMonths();
    listenToClickEditBtn();
};

document.addEventListener("DOMContentLoaded", function() {
    console.log("DOM geladen")
    listenToSocket();
});
//#endregion