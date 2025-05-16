# icat.nix
{
  stdenv,
  fetchFromGitHub,
  wlroots_0_18,
  libinput,
  libxkbcommon,
  pkg-config,
  xorg,
  xwayland,
  wayland,
  wayland-protocols,
  wayland-scanner,
  pixman,
}:

stdenv.mkDerivation {
  pname = "dwl-lucasnt";
  version = "v0.7.2";

  src = fetchFromGitHub {
    owner = "LucasNT";
    repo = "dwl";
    rev = "51cb624822c2d277417994b936a14d932fee26ae";
    hash = "sha256-fFtazj1p9uswlT+5qX+bd6XaQOo6ADTidQwoFSSXmNs=";
  };

  buildInputs = [ wlroots_0_18 libinput libxkbcommon pkg-config xorg.libxcb xwayland wayland wayland-protocols wayland-scanner xorg.xcbutilwm pixman ];

  installPhase = ''
    mkdir -p $out/bin
    cp dwl $out/bin
  '';
}
