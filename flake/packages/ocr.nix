{
  pkgs,
  langs ? "eng+heb",
}:

pkgs.writeShellApplication {
  name = "ocr";

    runtimeInputs = with pkgs; [
      grim
      slurp
      tesseract
      wl-clipboard
    ];

  text = ''
      grim -g "$(slurp)" - | tesseract stdin stdout -l ${langs} | wl-copy
    '';

}
