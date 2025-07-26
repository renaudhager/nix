{ pkgs ? import <nixpkgs> {} }:

let
    istioctl = pkgs.stdenv.mkDerivation {
        pname = "istioctl";
        version = "1.26.2";

        src = pkgs.fetchurl {
            url = "https://github.com/istio/istio/releases/download/1.26.2/istio-1.26.2-osx-arm64.tar.gz";
            sha256 = "530343166336641d4f95286b71267b191ca660132a15942781f616cf5d762fa0";
        };

        nativeBuildInputs = [ pkgs.gnutar pkgs.gzip ];

        unpackPhase = ''
            tar -xzf $src
        '';

        installPhase = ''
            mkdir -p $out/bin
            cp istio-*/bin/istioctl $out/bin/istioctl
            chmod +x $out/bin/istioctl
        '';
    };
in istioctl
