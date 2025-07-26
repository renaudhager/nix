{ pkgs ? import <nixpkgs> {} }:

let
  terraform_1_12_2 = pkgs.stdenv.mkDerivation {
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

  terragrunt_0_83_2 = pkgs.stdenv.mkDerivation {
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
  git_2_50_1 = pkgs.stdenv.mkDerivation {
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

in

pkgs.mkShell {
  name = "nix-work";

  buildInputs = [
    pkgs.zsh
    terraform_1_12_2
    terragrunt_0_83_2
    git_2_50_1
  ];

  shellHook = ''
    echo "Entering nix-work environment"
    export SHELL=$(which zsh)
    exec zsh
  '';
}
