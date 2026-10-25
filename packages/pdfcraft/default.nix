{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  libxkbcommon,
  vulkan-loader,
  libglvnd,
  libX11,
  libXcursor,
  libXi,
  libXrandr,
  libxcb,
  dbus,
  zenity,
  stdenv,
  wayland,
  nix-update-script,
}:

let
  linuxRuntimeLibraries = [
    wayland
    libxkbcommon
    vulkan-loader
    libglvnd
    libX11
    libXcursor
    libXi
    libXrandr
    libxcb
    dbus
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pdfcraft";
  version = "0.4.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "pdfcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Fkzo9qb9obrXa1X4klio+gRgM2UZIO8QwfI0/xSYwmo=";
  };

  cargoHash = "sha256-2y4jFVHDHUYoKo9gzRb7uq2dhtLa97P1iffRrMw46IQ=";

  cargoBuildFlags = [
    "-p"
    "pdfcraft"
    "-p"
    "pdfcraft-cli"
  ];
  # The release-profile workspace test targets take much longer to compile
  # than the application binaries.
  doCheck = false;

  # Rust 1.98 with LLVM 21 rejects the AVX-512 VNNI intrinsic used by rten-gemm.
  # Use the same instruction through inline assembly, as rten-gemm already does
  # in its other AVX-512 kernel.
  postPatch = lib.optionalString stdenv.hostPlatform.isx86_64 ''
    substituteInPlace "$cargoDepsCopy/source-registry-0/rten-gemm-0.26.0/src/i8dot.rs" \
      --replace-fail 'use std::arch::x86_64::_mm512_dpbusd_epi32;' 'use std::arch::asm;' \
      --replace-fail '_mm512_dpbusd_epi32(acc.0, a.0, b.0).into()' 'unsafe {
                  let mut result = acc.0;
                  asm!(
                      "vpdpbusd {result}, {a}, {b}",
                      result = inout(zmm_reg) result,
                      a = in(zmm_reg) a.0,
                      b = in(zmm_reg) b.0,
                      options(nostack)
                  );
                  result.into()
              }'
  '';

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ makeWrapper ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux linuxRuntimeLibraries;

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 packaging/linux/ai.storyteller.pdfcraft.desktop \
      "$out/share/applications/ai.storyteller.pdfcraft.desktop"
    install -Dm644 packaging/linux/ai.storyteller.pdfcraft.mime.xml \
      "$out/share/mime/packages/ai.storyteller.pdfcraft.xml"
    mkdir -p "$out/share/icons"
    cp -R assets/app-icon/hicolor "$out/share/icons/"
  '';

  # winit, wgpu, and rfd load windowing, GPU, and D-Bus libraries at runtime.
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram "$out/bin/pdfcraft" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath linuxRuntimeLibraries}" \
      --prefix PATH : "${lib.makeBinPath [ zenity ]}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "An open-source, clean-room reimplementation of Adobe Acrobat built in pure Rust";
    homepage = "https://github.com/storytold/pdfcraft";
    changelog = "https://github.com/storytold/pdfcraft/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ ];
    mainProgram = "pdfcraft";
  };
})
