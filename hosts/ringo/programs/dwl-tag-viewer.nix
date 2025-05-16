# icat.nix
{
  stdenv,
  fetchFromGitHub,
  go,
}:

stdenv.mkDerivation {
  pname = "dwlmsg";
  version = "7cfc263598";

  src = fetchFromGitHub {
    owner = "LucasNT";
    repo = "dwl-tag-viewer";
    rev = "e4aacfb429c5cd19c46c8a4c4760821e1b9f32f8";
    sha256 = "sha256-kzX5KtOVGR4L4ORS+KiZvGjGx7LZ6Rez7ibnPUBkSEU=";
  };

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  buildInputs = [ go ];

  installPhase = ''
    mkdir -p $out/bin
    cp dwl-tag-viewer $out/bin
  '';
}
