{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
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

  # Upstream's tests are not sandbox-safe: they use production polling delays,
  # download the ASCA engine, and compare maps with assert.Equal.
  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    mv "$out/bin/cmd" "$out/bin/cx"

    installShellCompletion --cmd cx \
      --bash <("$out/bin/cx" completion bash) \
      --zsh <("$out/bin/cx" completion zsh) \
      --fish <("$out/bin/cx" completion fish)

    mkdir -p "$out/share/powershell"
    "$out/bin/cx" completion powershell \
      > "$out/share/powershell/cx.Completion.ps1"
  '';

  meta = {
    description = "A CLI project wrapping application security testing (AST) APIs";
    homepage = "https://github.com/Checkmarx/ast-cli";
    license = lib.licenses.asl20;
    # maintainers = with lib.maintainers; [ ];
    mainProgram = "cx";
  };
}
