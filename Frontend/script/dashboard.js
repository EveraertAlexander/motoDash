"use strict";
const socket = io(`http://${lanIP}`);

let currentrideid
let html_gauge, html_temp, html_angle, html_accel, html_button, html_submitbtn, html_rideduration;
let logging = false;
const accel_limit = 2;

//#region ***  Callback-Visualisation - show___ ***
const showSensorValues = function(jsonObject) {
    const angle = jsonObject.rot_x;
    const temp = jsonObject.temp;
    const accel = jsonObject.accel_y
    const ldr = jsonObject.ldr

    showAngle(html_gauge, angle);
    showTemp(temp);
    showAccel(html_gauge, accel);



    if (ldr < 50 && !html_submitbtn) {
        darkTheme();
    } else {
        lightTheme();
    }
}

const darkTheme = function() {
    document.querySelector('html').classList.add("u-bg-dark")

    for (const cover of document.querySelectorAll('.gauge__cover')) {
        cover.classList.add('u-bg-dark')
    }
    for (const fill of document.querySelectorAll('.gauge__fill--secondary')) {
        fill.classList.add('u-bg-dark')
    }

    for (const value of document.querySelectorAll(".js-value")) {
        value.classList.add('u-color-white')
    }
}

const lightTheme = function() {
    document.querySelector('html').classList.remove("u-bg-dark")

    for (const cover of document.querySelectorAll('.gauge__cover')) {
        cover.classList.remove('u-bg-dark')
    }
    for (const fill of document.querySelectorAll('.gauge__fill--secondary')) {
        fill.classList.remove('u-bg-dark')
    }

    for (const value of document.querySelectorAll(".js-value")) {
        value.classList.remove('u-color-white')
    }

}
const showAngle = function(gauge, value) {
    if (value < -90 || value > 90) {
        return;
    }
    const mapped = (value - (-90)) / (90 - (-90))


    gauge.querySelector(".gauge__fill").style.transform = `rotate(${mapped/2}turn)`
    html_angle.innerHTML = `${value}°`
}

const showAccel = function(gauge, value) {
    const html_pos = gauge.querySelector(".accel__pos");
    const html_neg = gauge.querySelector(".accel__neg")

    if (value > 0) {
        const mapped = (value - 0) / (accel_limit - 0) * (0 - (-0.25)) + (-0.25)

        html_pos.style.transform = `rotate(${mapped}turn)`
        html_neg.style.transform = `rotate(0.251turn)`

    } else {
        const mapped = (value - 0) / (-accel_limit - 0) * (0 - 0.25) + 0.25

        html_neg.style.transform = `rotate(${mapped}turn)`
        html_pos.style.transform = `rotate(-0.251turn)`
    }

    html_accel.innerHTML = `${Math.round(value*10)/10}m/s²`
}

const showTemp = function(temp) {
    html_temp.innerHTML = `Oil: ${Math.round(temp)}°C`
}

const showButton = function(jsonObject) {
        const status = jsonObject.started;
        let htmlString;
        if (status == true) {
            htmlString = `<a class="c-link-cta c-link-cta--red js-btn-link js-stop-btn" href="#!" id="1">STOP RIDE</a>`
            logging = true
        } else if (!status) {
            htmlString = `<a class="c-link-cta js-btn-link" href="#!" id="0">START RIDE</a>`
            logging = false
        } else {
            htmlString = `<a class="c-link-cta c-link-cta--grey">CONNECTING...</a>`
        }

        html_button.innerHTML = htmlString;
    }
    //#endregion
    //#region ***  Callback-No Visualisation - callback___  ***
const callbackGetCurrentRide = function(jsonObject) {
    console.log(jsonObject)
    currentrideid = jsonObject.rideid;
    document.querySelector('html').classList.toggle("has-form-screen");
    listenToClickSubmit();
}

const callbackUpdateRide = function(jsonObject) {
        console.log("update succesvol")
    }
    //#endregion

//#region ***  Data Access - get___ ***
const getCurrentRide = function() {
    handleData(`http://${lanIP}/api/v1/currentride`, callbackGetCurrentRide)
}

const getSensorValues = function() {
        handleData(`http://${lanIP}/api/v1/sensorvalues`, showSensorValues)
    }
    //#endregion

//#region ***  Event Listeners - listenTo___ ***
const listenToSocket = function() {
    socket.on('connect_error', function() {
        showButton({ 'started': "connecting" })
    })

    socket.on("B2F_client_connected", function() {
        console.log("verbonden met socket webserver");
    });

    socket.on("B2F_status_logging", showButton);
}

const listenToClickBtn = function() {
    html_button.addEventListener("click", function() {
        const status = html_button.querySelector('.js-btn-link').id;
        if (status == 1) {
            socket.emit('F2B_stop_logging', null)
            getCurrentRide();
        } else if (status == 0) {
            //rit starten
            socket.emit('F2B_start_logging', null)
        }
    })
}

const listenToClickSubmit = function() {
        html_submitbtn.addEventListener("click", function() {
            document.querySelector('html').classList.remove("has-form-screen");
            let ridename = document.querySelector("#ridename")
            let ridedescription = document.querySelector("#ridedescription")
            let jsonObject;
            if (ridename.value == "") {
                jsonObject = {
                    ridename: "MyRide",
                    ridedescription: null
                }
            } else {
                jsonObject = {
                    ridename: ridename.value,
                    ridedescription: ridedescription.value
                }
            }


            console.log(jsonObject)
            ridename.value = ''
            ridedescription.value = ''
            handleData(`http://${lanIP}/api/v1/rides/${currentrideid}`, callbackUpdateRide, null, "PUT", JSON.stringify(jsonObject))
            window.location.href = '/Code/Frontend/stats.html'
        })
    }
    //#endregion

const toggleForm = function() {
    document.querySelector('.js-toggle-form').addEventListener("click", function() {
        document.querySelector('html').classList.toggle("has-form-screen");
    })
}

//#region ***  INIT / DOMContentLoaded  ***
const init_dashboard = function() {
    console.log("init initiated!");
    html_gauge = document.querySelector('.gauge')
    html_temp = document.querySelector('.js-oiltemp')
    html_angle = document.querySelector('.js-angle')
    html_accel = document.querySelector('.js-accel')
    html_button = document.querySelector('.js-button')
    html_submitbtn = document.querySelector('.js-submitbtn')
    html_rideduration = document.querySelector('.js-rideduration')

    if (html_submitbtn) {
        listenToSocket();
        listenToClickBtn();
        toggleForm();
        setInterval(function() {
            getSensorValues();
        }, 50)
    } else {
        setInterval(function() {
            getSensorValues();
        }, 50)
    }

};



document.addEventListener("DOMContentLoaded", init_dashboard);
//#endregion