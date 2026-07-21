# overlays/channels/default.nix
{ channels
, inputs
, ...
}: final: prev: {
  stable = channels.stable;
  master = channels.master;
  herdr = inputs.herdr.packages.${prev.system}.default;

  gdalMinimal = prev.gdalMinimal.overrideAttrs (old: {
    disabledTests = (old.disabledTests or [ ]) ++ [
      "test_zarr_read_simple_sharding"
    ];
  });

  linux-enable-ir-emitter = prev.linux-enable-ir-emitter.overrideAttrs (old: {
    buildInputs =
      (prev.lib.remove prev.python3.pkgs.opencv4Full old.buildInputs)
      ++ [
        (final.python3.pkgs.opencv4.override {
          enableGtk3 = true;
        })
      ];
  });

  howdy = prev.howdy.overrideAttrs (old:
    let
      pythonEnv = final.python3.buildEnv.override {
        extraLibs = with final.python3.pkgs; [
          dlib
          elevate
          face-recognition
          keyboard
          (opencv4.override {
            enableGtk3 = true;
          })
          pycairo
          pygobject3
        ];
        makeWrapperArgs = [
          "--set"
          "OMP_NUM_THREADS"
          "1"
        ];
      };
    in
    {
      inherit pythonEnv;

      mesonFlags =
        prev.lib.filter
          (flag: !(prev.lib.hasPrefix "-Dpython_path=" flag))
          old.mesonFlags
        ++ [
          "-Dpython_path=${pythonEnv}/bin/python"
        ];
    });

  pythonPackagesExtensions = (prev.pythonPackagesExtensions or [ ]) ++ [
    (python-final: python-prev: {
      face-recognition-models = python-prev.face-recognition-models.overridePythonAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          (prev.fetchpatch {
            url = "https://github.com/ageitgey/face_recognition_models/commit/c142485d6f34c633d67c5e7ccbbc0baf7a1d695f.patch";
            hash = "sha256-3ylcgXuTFlsg3Rgv6Pk1gKw//z2Uq+UxEeOFtD4xqpk=";
          })
        ];

        build-system = [
          python-final.setuptools
        ];
      });
    })
  ];
}
