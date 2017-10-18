with import <nixpkgs> {};

stdenv.mkDerivation {
    name = "julia-env";
    buildInputs = [ julia curl which ];

    SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt";
    GIT_SSL_CAINFO="/etc/ssl/certs/ca-certificates.crt";

    LD_LIBRARY_PATH="${glfw}/lib:${mesa}/lib:${freetype}/lib:${imagemagick}/lib:${portaudio}/lib:${libsndfile.out}/lib:${libxml2.out}/lib:${expat.out}/lib:${cairo.out}/lib:${pango.out}/lib:${gettext.out}/lib:${glib.out}/lib:${gtk3.out}/lib:${gdk_pixbuf.out}/lib:${cairo.out}:${tk.out}/lib:${tcl.out}/lib:${pkgs.sqlite.out}/lib:${pkgs.zlib}/lib";

    shellHook = ''
      unset http_proxy
      export JULIA_PKGDIR=$(realpath ./.julia_pkgs)
      mkdir -p $JULIA_PKGDIR
    '';
}

