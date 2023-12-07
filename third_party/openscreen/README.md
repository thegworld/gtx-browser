# README.md for Open Screen Library in GTx Browser

openscreen is built in GTx Browser with some build differences based on the value
of the GN argument `build_with_chromium`.  `build_with_chromium` is defined in
`//build_overrides/build.gni` and is `true` when openscreen is built as part of
GTx Browser and `false` when built standalone.
