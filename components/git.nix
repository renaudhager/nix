{ pkgs ? import <nixpkgs> {} }:

let
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
in git
