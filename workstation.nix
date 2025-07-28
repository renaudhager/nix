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
  
  # nixpkgs.config.allowUnfree = true;

  buildInputs = [
    pkgs._1password-cli
    pkgs.awscli2
    pkgs.curl
    pkgs.fzf
    pkgs.go
    pkgs.htop
    pkgs.jq
    pkgs.less
    pkgs.locale
    pkgs.mysql84
    pkgs.openssh
    pkgs.pre-commit
    pkgs.sops
    pkgs.terraform-docs
    pkgs.tflint
    pkgs.vim
    pkgs.which
    pkgs.zsh
    ~/nix/.artefacts/argocd
    ~/nix/.artefacts/aws-ecr-credential-helper
    ~/nix/.artefacts/crane
    ~/nix/.artefacts/git
    ~/nix/.artefacts/helm
    ~/nix/.artefacts/istioctl
    ~/nix/.artefacts/kubectl
    ~/nix/.artefacts/nats
    ~/nix/.artefacts/terraform
    ~/nix/.artefacts/terragrunt
  ];

  shellHook = ''
    echo "Entering $name environment"
    export SHELL=$(which zsh)
    export NIX_SHELL_NAME="$name"
    export RPROMPT="%F{cyan}[$NIX_SHELL_NAME]%f"
    export TERM_PROGRAM=ghostty
    export TERMINFO=/Applications/Ghostty.app/Contents/Resources/terminfo
    export PATH="$PATH:/usr/local/bin/"

    if [[ -z "$IN_NIX_SHELL" || -n "$ZSH_VERSION" ]]; then
      return
    fi

    zsh
  '';
}