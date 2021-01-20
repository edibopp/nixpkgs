{ stdenv,
  mkDerivation,
  cmake,
  elfutils,
  extra-cmake-modules,
  fetchFromGitHub,
  kconfigwidgets,
  ki18n,
  kio,
  kitemmodels,
  kitemviews,
  kwindowsystem,
  libelf,
  qtbase,
  threadweaver,
}:

mkDerivation rec {
  pname = "hotspot";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "KDAB";
    repo = "hotspot";
    rev = "v${version}";
    sha256 = "1f68bssh3p387hkavfjkqcf7qf7w5caznmjfjldicxphap4riqr5";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    elfutils
    extra-cmake-modules
    kconfigwidgets
    ki18n
    kio
    kitemmodels
    kitemviews
    kwindowsystem
    libelf
    qtbase
    threadweaver
  ];

  # hotspot checks for the presence of third party libraries'
  # git directory to give a nice warning when you forgot to clone
  # submodules; but Nix clones them and removes .git (for reproducibility).
  # So we need to fake their existence here.
  postPatch = ''
    mkdir -p 3rdparty/perfparser/.git
  '';

  meta = {
    description = "A GUI for Linux perf";
    longDescription = ''
      hotspot is a GUI replacement for `perf report`.
      It takes a perf.data file, parses and evaluates its contents and
      then displays the result in a graphical way.
    '';
    homepage = "https://github.com/KDAB/hotspot";
    license = with stdenv.lib.licenses; [ gpl2 gpl3 ];
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ nh2 ];
  };
}
