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
    populateNavBar();

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

function login(password, success, error) {
    console.log("logging in..")
    var data = new FormData()
    data.append("password", password)
    $.ajax({
        url: "/api/login",
        type: 'POST',
        processData: false,
        contentType: false,
        data: data,
        success: function (response) {
            setToken(response.token);
            success();
        },
        error: function (response) {
            error();
        }
    });
}

function logout() {
    $.ajax({
        url: "/api/logout",
        type: 'POST',
        headers: {
            'authorization': `Bearer ${getToken()}`
        },
        success: function (response) {
            clearToken();
            window.location.href = '/index.html';
        },
        error: function (response) {}
    });
}

function populateWeatherData() {
    $.ajax({
        url: "https://webcamfornolo.org/api/weather",
        type: 'GET',
        contentType: "application/json",
        success: function (response) {
            weatherData = response.outdoor_weather_data;
            const temp = weatherData.temperature !== null ? weatherData.temperature + '°C' : "N.D.";
            const humidity = weatherData.humidity !== null ? weatherData.humidity + '%' : "N.D.";
            const rain = weatherData.rain !== null ? weatherData.rain + 'mm' : "N.D.";
            const tempHtml = '<i class="fas fa-thermometer-half"></i> ' + temp;
            const humidityHtml = '<i class="fas fa-tint"></i> ' + humidity;
            const rainHtml = '<i class="fas fa-cloud-rain"></i> ' + rain;
            document.getElementById('weather-data').innerHTML = tempHtml + ' ' + humidityHtml + ' ' + rainHtml;
        },
        error: function (response) {}
    });
}

function populateNavBar() {
    const navBar = document.getElementById('navbarResponsive');

    const createMenuEntry = function (name, ref, action = null) {
        const liNode = document.createElement('li');
        liNode.classList.add("nav-item");
        const aNode = document.createElement('a');
        aNode.classList.add("nav-link");
        aNode.setAttribute("href", ref);
        if (action) {
            aNode.addEventListener("click", action);
        }
        aNode.innerText = name;
        liNode.appendChild(aNode);
        navBar.firstElementChild.appendChild(liNode);
    }

    createMenuEntry("Live", "/index.html");
    createMenuEntry("Gallery", "/gallery.html");
    if (isLogged()) {
        createMenuEntry("Upload", "/upload.html");
    }
    createMenuEntry("About", "/about.html");
    createMenuEntry("Contact", "mailto:webcamfornolo@altervista.org");
    if (isLogged()) {
        createMenuEntry("Logout", "#", logout)
    } else {
        createMenuEntry("Login", "/login.html")
    }
}