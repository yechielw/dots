{pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    (burpsuite.override { proEdition = true; })
    bloodhound-py
    caido
    hashcat
    cudaPackages.cudatoolkit
    netexec
    bloodhound
  ];
}
