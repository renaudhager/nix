{ pkgs ? import <nixpkgs> {} }:

let
    aws-ecr-credential-helper = pkgs.stdenv.mkDerivation {
        pname = "aws-ecr-credential-helper";
        version = "v0.10.1";

        src = pkgs.fetchurl {
            url = "https://amazon-ecr-credential-helper-releases.s3.us-east-2.amazonaws.com/0.10.1/darwin-arm64/docker-credential-ecr-login";
            sha256 = "6a560a3b5d0da4f8e2d98d5aab18a4325fac82029d2d0b41a3f884680bb76113";
        };

        phases = [ "installPhase" ];

        installPhase = ''
            mkdir -p $out/bin
            cp $src $out/bin/docker-credential-ecr-login
        '';
    };
in aws-ecr-credential-helper
