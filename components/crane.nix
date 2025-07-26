{ pkgs ? import <nixpkgs> {} }:

let
    crane = pkgs.stdenv.mkDerivation {
        pname = "crane";
        version = "v0.20.6";

        src = pkgs.fetchurl {
            url = "https://github.com/google/go-containerregistry/releases/download/v0.20.6/go-containerregistry_Darwin_arm64.tar.gz";
            sha256 = "ae30b28498de3e1ac51a37042eab46116ec70d86aa9d10431a1fbde35b9918b9";
        };

        nativeBuildInputs = [ pkgs.gnutar pkgs.gzip ];

        unpackPhase = ''
            tar -xzf $src
        '';

        installPhase = ''
            mkdir -p $out/bin
            cp crane $out/bin/crane
            chmod +x $out/bin/crane
        '';
    };
in crane
