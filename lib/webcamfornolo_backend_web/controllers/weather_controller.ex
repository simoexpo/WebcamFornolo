defmodule WebcamfornoloBackendWeb.WeatherController do
  use WebcamfornoloBackendWeb, :controller

  def getWeather do
    WebcamfornoloBackend.getWeatherInfo()
  end
end
