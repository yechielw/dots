{pkgs,pkgs-master,inputs, ...}:

{
  environment.systemPackages = with pkgs; [
    
    bloodhound-py
    caido
    netexec
  ];
}
