{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
  nix-update-script,
}:

rustPlatform.buildRustPackage (_finalAttrs: {
  pname = "mdv";
  version = "0-unstable-2026-03-29";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "posaune0423";
    repo = "mdv";
    rev = "739511ec80d6b2bc552febd47ffce47e1a9d3368";
    hash = "sha256-5pKZ9Y1XKzB4NTqwRZ4WIXJ4sgdzclLFWoCfWZcpDkI=";
  };

  cargoHash = "sha256-BbVOc87Vrth5W9tU1N0/hbefUwM7C4EQyeDqQBEWfsw=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Mdv is a blazing-fast Markdown viewer built in Rust. With the Kitty Graphics Protocol, it renders rich, beautiful Markdown natively in your terminal, including typography, images, diagrams, syntax highlighting, and GFM features like callouts";
    homepage = "https://github.com/posaune0423/mdv";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "mdv";
  };
})
