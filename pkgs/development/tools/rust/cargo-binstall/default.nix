{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, bzip2
, xz
, zstd
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-binstall";
  version = "1.6.9";

  src = fetchFromGitHub {
    owner = "cargo-bins";
    repo = "cargo-binstall";
    rev = "v${version}";
    hash = "sha256-gByMCbh/RswZFrGY176PcZbBeHRsD0mv8Om4xQ/1wTo=";
  };

  cargoHash = "sha256-GPDDKFM2dxsjQcrNK7y2lydnqGnFBUMcDJZ420jmzlo=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    bzip2
    xz
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "fancy-no-backtrace"
    "git"
    "pkg-config"
    "rustls"
    "trust-dns"
    "zstd-thin"
  ];

  cargoBuildFlags = [ "-p" "cargo-binstall" ];
  cargoTestFlags = [ "-p" "cargo-binstall" ];

  checkFlags = [
    # requires internet access
    "--skip=download::test::test_and_extract"
    "--skip=gh_api_client::test::test_gh_api_client_cargo_binstall_no_such_release"
    "--skip=gh_api_client::test::test_gh_api_client_cargo_binstall_v0_20_1"
  ];

  meta = with lib; {
    description = "Tool for installing rust binaries as an alternative to building from source";
    mainProgram = "cargo-binstall";
    homepage = "https://github.com/cargo-bins/cargo-binstall";
    changelog = "https://github.com/cargo-bins/cargo-binstall/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}
