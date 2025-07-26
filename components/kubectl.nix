{ pkgs ? import <nixpkgs> {} }:

let
    kubectl = pkgs.stdenv.mkDerivation {
        pname = "kubectl";
        version = "v1.32.0";

        src = pkgs.fetchurl {
            url = "https://dl.k8s.io/release/v1.32.0/bin/darwin/arm64/kubectl";
            sha256 = "5bfd5de53a054b4ef614c60748e28bf47441c7ed4db47ec3c19a3e2fa0eb5555";
        };

        phases = [ "installPhase" ];

        installPhase = ''
            mkdir -p $out/bin
            cp $src $out/bin/kubectl
            chmod +x $out/bin/kubectl
        '';
    };
in kubectl
