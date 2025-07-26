{ pkgs ? import <nixpkgs> {} }:

let
  #  Pinning nixpkgs to a specific Git commit
  pinnedNixpkgs = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/3ff0e34b1383648053bba8ed03f201d3466f90c9.tar.gz";
    sha256 = "1mg2rlxz4q2sq94pg9bi0hpqibxsk0cw0v7g383qzr79vd3gdm89";
  }) {};

  pkgs = pinnedNixpkgs;

in 

pkgs.mkShell {
  name = "n.work";

  buildInputs = [
    pkgs.zsh
    pkgs.go
    pkgs.htop
    pkgs.awscli2
    pkgs.jq
    ~/nix/.artefacts/argocd
    ~/nix/.artefacts/git
    ~/nix/.artefacts/helm
    ~/nix/.artefacts/kubectl
    ~/nix/.artefacts/terraform
    ~/nix/.artefacts/terragrunt
  ];

  shellHook = ''
    echo "Entering $name environment"
    export SHELL=$(which zsh)
    export NIX_SHELL_NAME="$name"
    export RPROMPT="%F{cyan}[$NIX_SHELL_NAME]%f"

    if [[ -z "$IN_NIX_SHELL" || -n "$ZSH_VERSION" ]]; then
      return
    fi

    zsh
  '';
}