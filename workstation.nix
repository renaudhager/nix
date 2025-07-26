{ pkgs ? import <nixpkgs> {} }:

let
  #  Pinning nixpkgs to a specific Git commit
  pinnedNixpkgs = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/3ff0e34b1383648053bba8ed03f201d3466f90c9.tar.gz";
    sha256 = "1mg2rlxz4q2sq94pg9bi0hpqibxsk0cw0v7g383qzr79vd3gdm89";
  }) {};

  pkgs = pinnedNixpkgs;

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

  # Had to build it from source, 2.50.1 not available yet as nix pkg
  git = pkgs.stdenv.mkDerivation {
    pname = "git";
    version = "2.50.1";

    src = pkgs.fetchurl {
      url = "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.50.1.tar.gz";
      sha256 = "522d1635f8b62b484b0ce24993818aad3cab8e11ebb57e196bda38a3140ea915";
    };

    nativeBuildInputs = with pkgs; [ zlib curl openssl expat gettext perl cpio ];

    buildInputs = with pkgs; [ zlib curl openssl expat gettext perl cpio ];

    # buildInputs = nativeBuildInputs;

    configurePhase = ''
      ./configure --prefix=$out
    '';

    buildPhase = "make";

    installPhase = "make install";
  };

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

in

pkgs.mkShell {
  name = "nix.work";

  buildInputs = [
    pkgs.zsh
    pkgs.go
    pkgs.htop
    pkgs.awscli2
    pkgs.jq
    terraform
    terragrunt
    git
    kubectl
    helm
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