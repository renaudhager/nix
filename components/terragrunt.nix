{ pkgs ? import <nixpkgs> {} }:

let
    terragrunt = pkgs.stdenv.mkDerivation {
        pname = "terragrunt";
        version = "0.83.2";

        src = pkgs.fetchurl {
            url = "https://github.com/gruntwork-io/terragrunt/releases/download/v0.83.2/terragrunt_darwin_arm64";
            sha256 = "10cd32a2e25ba01b8e1ca8c7d8bf467caff6082197291be06040f9221871ff96"; 
        };

        phases = [ "installPhase" ];

        installPhase = ''
            mkdir -p $out/bin
            cp $src $out/bin/terragrunt
            chmod +x $out/bin/terragrunt
        '';
    };
in terragrunt
