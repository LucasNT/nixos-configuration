# icat.nix
{
  stdenv,
  fetchgit,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:

stdenv.mkDerivation {
  pname = "dwlmsg";
  version = "7cfc263598";

  src = fetchgit {
    url = "https://codeberg.org/notchoc/dwlmsg.git";
    rev = "7cfc2635984611e6eceef011084f21c22979b3d0";
    hash = "sha256-uEw9QY0WveM8cu7uhXLbIKLYgtmyUyMxEDti+uWLoCU=";
  };

  buildInputs = [ pkg-config wayland wayland-protocols wayland-scanner ];

  installPhase = ''
    mkdir -p $out/bin
    cp dwlmsg $out/bin
  '';
}
