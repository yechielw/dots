{
  pkgs,
  langs ? "eng+heb",
}:
pkgs.writeShellApplication {
  name = "ocr";

  meta.platforms = pkgs.lib.platforms.linux;

  runtimeInputs = with pkgs; [
    grim
    slurp
    tesseract
    wl-clipboard
  ];

  text = ''
    grim -g "$(slurp)" -t ppm - | tesseract stdin stdout -l ${langs} | wl-copy
  '';
}
