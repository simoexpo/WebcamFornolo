defmodule WebcamfornoloBackend.Service.ImageEditorService do
  import Mogrify

  @text_color "white"
  @text_font "Lato-Bold"
  @text_size "20"
  @text_padding "10,10"
  @border_size "0x40"
  @border_color "#030C7E"

  def create_webcam_view(image, label1, label2) do
    Mogrify.open(image)
    |> custom("fill", @text_color)
    |> custom("gravity", "south")
    |> custom("background", @border_color)
    |> custom("splice", @border_size)
    |> custom("gravity", "SouthWest")
    |> custom("font", @text_font)
    |> custom("pointsize", @text_size)
    |> custom("draw", "text #{@text_padding} '#{label1}'")
    |> custom("gravity", "SouthEast")
    |> custom("draw", "text #{@text_padding} '#{label2}'")
    |> save(in_place: true)
    |> Map.get(:path)
  end
end
