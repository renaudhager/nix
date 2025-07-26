{ pkgs ? import <nixpkgs> {} }:

let
    terraform = pkgs.stdenv.mkDerivation {
        pname = "terraform";
        version = "1.12.2";

        src = pkgs.fetchurl {
            url = "https://releases.hashicorp.com/terraform/1.12.2/terraform_1.12.2_darwin_arm64.zip";
            sha256 = "1ca02f336ff4f993d6441806d38a0bcc0bbca0e3c877b84c9c2dc80cfcd0dc8b";
        };

        nativeBuildInputs = [ pkgs.unzip ];

        unpackPhase = "unzip $src";

        installPhase = ''
            mkdir -p $out/bin
            mv terraform $out/bin/
        '';
    };
in terraform
