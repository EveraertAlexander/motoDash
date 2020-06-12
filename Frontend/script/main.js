"use strict";
const lanIP = `${window.location.hostname}:5000`;
//#region ***  DOM references ***

//#endregion

function toggleNav() {
    let toggleTrigger = document.querySelectorAll(".js-toggle-nav");
    for (let i = 0; i < toggleTrigger.length; i++) {
        toggleTrigger[i].addEventListener("touchstart", function() {
            document.querySelector("html").classList.toggle("has-mobile-nav");
        })
    }
}


//#region ***  Callback-Visualisation - show___ ***
//#endregion

//#region ***  Callback-No Visualisation - callback___  ***
//#endregion

//#region ***  Data Access - get___ ***
//#endregion

//#region ***  Event Listeners - listenTo___ ***
//#endregion

//#region ***  INIT / DOMContentLoaded  ***
const init_main = function() {
    console.log("init initiated!");
    toggleNav();
};

document.addEventListener("DOMContentLoaded", init_main);
//#endregion