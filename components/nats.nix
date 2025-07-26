{ pkgs ? import <nixpkgs> {} }:

let
    nats = pkgs.stdenv.mkDerivation {
        pname = "nats";
        version = "0.2.3";

        src = pkgs.fetchurl {
            url = "https://github.com/nats-io/natscli/releases/download/v0.2.3/nats-0.2.3-darwin-arm64.zip";
            sha256 = "tiWO+LZi4HkC+c7BopPGFaTQbyqjDc48azLzWgxC8Pg=";
        };

        nativeBuildInputs = [ pkgs.unzip ];

        unpackPhase = "unzip $src";

        installPhase = ''
            mkdir -p $out/bin
            cp nats-*-darwin-arm64/nats $out/bin/nats
            chmod +x $out/bin/nats
        '';
    };
in nats
