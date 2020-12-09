(function ($) {
    "use strict"; // Start of use strict

    // Floating label headings for the contact form
    $("body").on("input propertychange", ".floating-label-form-group", function (e) {
        $(this).toggleClass("floating-label-form-group-with-value", !!$(e.target).val());
    }).on("focus", ".floating-label-form-group", function () {
        $(this).addClass("floating-label-form-group-with-focus");
    }).on("blur", ".floating-label-form-group", function () {
        $(this).removeClass("floating-label-form-group-with-focus");
    });

    // Show the navbar when the page is scrolled up
    var MQL = 992;

    //primary navigation slide-in effect
    if ($(window).width() > MQL) {
        var headerHeight = $('#mainNav').height();
        $(window).on('scroll', {
            previousTop: 0
        },
            function () {
                var currentTop = $(window).scrollTop();
                //check if user is scrolling up
                if (currentTop < this.previousTop) {
                    //if scrolling up...
                    if (currentTop > 0 && $('#mainNav').hasClass('is-fixed')) {
                        $('#mainNav').addClass('is-visible');
                    } else {
                        $('#mainNav').removeClass('is-visible is-fixed');
                    }
                } else if (currentTop > this.previousTop) {
                    //if scrolling down...
                    $('#mainNav').removeClass('is-visible');
                    if (currentTop > headerHeight && !$('#mainNav').hasClass('is-fixed')) $('#mainNav').addClass('is-fixed');
                }
                this.previousTop = currentTop;
            });
    }

    // setup navigation
    var navBar = document.getElementById('navbarResponsive');
    var liNode = document.createElement('li');
    liNode.classList.add("nav-item");
    var aNode = document.createElement('a');
    aNode.classList.add("nav-link");
    if (isLogged()) {
        aNode.setAttribute("href", "#");
        aNode.innerText = "Logout";
        aNode.addEventListener("click", logout);
    } else {
        aNode.setAttribute("href", "/index.html");
        aNode.innerText = "Login";
    }
    liNode.appendChild(aNode);
    navBar.firstElementChild.appendChild(liNode);

    // weather data
    populateWeatherData();

})(jQuery); // End of use strict

function setToken(token) {
    if (typeof (Storage) !== "undefined") {
        localStorage.setItem("token", token);
    } else {
        window.name = token;
    }
};

function getToken() {
    console.log("clearing token");
    if (typeof (Storage) !== "undefined") {
        return localStorage.getItem("token");
    } else {
        return window.name;
    }
};

function clearToken() {
    if (typeof (Storage) !== "undefined") {
        localStorage.removeItem("token");
    } else {
        window.name = "";
    }
};

function isLogged() {
    if (typeof (Storage) !== "undefined") {
        return localStorage.getItem("token") != null;
    } else {
        return window.name != "";
    }
};

function login(password) {
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.open("POST", "/api/login", true); // true for asynchronous 
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
            var response = JSON.parse(xmlHttp.responseText)
            setToken(response.token);
        }
    };
    var data = new FormData();
    data.append("password", password);
    xmlHttp.send(data);
}

function logout() {
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.open("POST", "/api/logout", true); // true for asynchronous 
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
            clearToken();
        }
    };
    xmlHttp.setRequestHeader("authorization", `Basic ${getToken()}`);
    xmlHttp.send(null);
}

function populateWeatherData() {
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
            var weatherData = JSON.parse(xmlHttp.responseText);
            var temp = '<i class="fas fa-thermometer-half"></i> ' + weatherData.outdoor_weather_data.temperature + '°C';
            var humidity = '<i class="fas fa-tint"></i> ' + weatherData.outdoor_weather_data.humidity + '%';
            var rain = '<i class="fas fa-cloud-rain"></i> ' + weatherData.outdoor_weather_data.rain + 'mm';
            document.getElementById('weather-data').innerHTML = temp + ' ' + humidity + ' ' + rain;
        }
    }
    xmlHttp.open("GET", "https://webcamfornolo.org/api/weather", true); // true for asynchronous 
    xmlHttp.send(null);
}
