{ pkgs ? import <nixpkgs> {} }:

let
    helm = pkgs.stdenv.mkDerivation {
        pname = "helm";
        version = "v3.18.4";

        src = pkgs.fetchurl {
            url = "https://get.helm.sh/helm-v3.18.4-darwin-arm64.tar.gz";
            sha256 = "041849741550b20710d7ad0956e805ebd960b483fe978864f8e7fdd03ca84ec8";
        };

        nativeBuildInputs = [ pkgs.gnutar pkgs.gzip ];

        unpackPhase = ''
            tar -xzf $src
        '';

        installPhase = ''
            mkdir -p $out/bin
            cp darwin-arm64/helm $out/bin/helm
            chmod +x $out/bin/helm
        '';
    };
in helm
