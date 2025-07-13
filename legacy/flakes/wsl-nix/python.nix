{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    (python311.withPackages(ps: with ps; [
       pynvim
       pip
       debugpy
       impacket
    ]))
  ];
}
