{ pkgs ? import <nixpkgs> {} }:

let
    argocd = pkgs.stdenv.mkDerivation {
        pname = "argocd";
        version = "v3.0.12";

        src = pkgs.fetchurl {
            url = "https://github.com/argoproj/argo-cd/releases/download/v3.0.12/argocd-darwin-arm64";
            sha256 = "37904a99c178dc305645ce0bd51c262fbab8cef01dab1506dbb9ae4d6aab90f9";
        };

        phases = [ "installPhase" ];

        installPhase = ''
            mkdir -p $out/bin
            cp $src $out/bin/argocd
            chmod +x $out/bin/argocd
        '';
    };
in argocd
