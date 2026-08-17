{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ast-cli";
  version = "2.3.60";

  src = fetchFromGitHub {
    owner = "Checkmarx";
    repo = "ast-cli";
    rev = version;
    hash = "sha256-yLoruMiN86pb4iLYHShvL/4GL9QuTO5L27ddTgHYnLs=";
  };

  vendorHash = "sha256-geNlVMo99ynuknKqY/eh0w0jFpRSArk1NFiwKt6vMDM=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/checkmarx/ast-cli/internal/params.Version=${version}"
  ];

  meta = {
    description = "A CLI project wrapping application security testing (AST) APIs";
    homepage = "https://github.com/Checkmarx/ast-cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "ast-cli";
  };
}
