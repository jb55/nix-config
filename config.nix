# buildTools
# cabal2nix-1.73
# coqTools
# coreutils-8.23
# emacsTools
# env-agda
# env-coqHEAD
# env-ghc784
# gitTools
# langTools
# ledger-3.1.0.20141005
# mailTools
# networkTools
# nix-1.9pre4028_0d1dafa
# nix-prefetch-scripts
# nix-repl-1.8-f924081
# perlTools
# publishTools
# pythonTools
# rubyTools
# serviceTools
# systemTools
# xquartz

{ pkgs }: {

packageOverrides = self: with pkgs; rec {

emacs = if self.stdenv.isDarwin
        then pkgs.emacs24Macport_24_4
        else pkgs.emacs;

emacs24Packages =
  if self.stdenv.isDarwin
  then recurseIntoAttrs (emacsPackages emacs24Macport_24_3 pkgs.emacs24Packages)
    // { proofgeneral = pkgs.emacs24Packages.proofgeneral_4_3_pre; }
  else pkgs.emacs24Packages;

ledger = self.callPackage /Users/johnw/Projects/ledger {};

haskellProjects = self: super: {
  hoogleLocal     = self.callPackage
    /Users/johnw/src/nixpkgs/pkgs/development/libraries/haskell/hoogle/local.nix {};

  # sizes         = self.callPackage /Users/johnw/Projects/sizes {};
  # c2hsc         = self.callPackage /Users/johnw/Projects/c2hsc {};
  # consistent    = self.callPackage /Users/johnw/Projects/consistent {};
  # findConduit   = self.callPackage /Users/johnw/Projects/find-conduit {};
  # asyncPool     = self.callPackage /Users/johnw/Projects/async-pool {};
  # gitAll        = self.callPackage /Users/johnw/Projects/git-all {};
  # hours         = self.callPackage /Users/johnw/Projects/hours {};
  # loggingHEAD   = self.callPackage /Users/johnw/Projects/logging {};
  # pushme        = self.callPackage /Users/johnw/Projects/pushme {};
  # simpleMirror  = self.callPackage /Users/johnw/Projects/simple-mirror {};
  # simpleConduitHEAD = self.callPackage /Users/johnw/Projects/simple-conduit {};
  # fuzzcheck     = self.callPackage /Users/johnw/Projects/fuzzcheck {};
  # hnix          = self.callPackage /Users/johnw/Projects/hnix {};
  # commodities   = self.callPackage /Users/johnw/Projects/ledger/new/commodities {};
  # linearscan    = self.callPackage /Users/johnw/Contracts/BAE/Projects/linearscan {};

  # gitlib        = self.callPackage /Users/johnw/Projects/gitlib/gitlib {};
  # gitlibTest    = self.callPackage /Users/johnw/Projects/gitlib/gitlib-test {};
  # hlibgit2      = self.callPackage /Users/johnw/Projects/gitlib/hlibgit2 {};
  # gitlibLibgit2 = self.callPackage /Users/johnw/Projects/gitlib/gitlib-libgit2 {};
  # gitMonitor    = self.callPackage /Users/johnw/Projects/gitlib/git-monitor {};
  # gitGpush      = self.callPackage /Users/johnw/Projects/gitlib/git-gpush {};
  # gitlibCmdline = self.callPackage /Users/johnw/Projects/gitlib/gitlib-cmdline {
  #   git = gitAndTools.git;
  # };
  # gitlibCross   = self.callPackage /Users/johnw/Projects/gitlib/gitlib-cross {
  #   git = gitAndTools.git;
  # };
  # gitlibHit     = self.callPackage /Users/johnw/Projects/gitlib/gitlib-hit {};
  # gitlibLens    = self.callPackage /Users/johnw/Projects/gitlib/gitlib-lens {};
  # gitlibS3      = self.callPackage /Users/johnw/Projects/gitlib/gitlib-S3 {};
  # gitlibSample  = self.callPackage /Users/johnw/Projects/gitlib/gitlib-sample {};

  # newartisans   = self.callPackage /Users/johnw/Documents/newartisans {
  #   yuicompressor = pkgs.yuicompressor;
  # };

  # hdevtools    = self.callPackage /Users/johnw/Contracts/OSS/Projects/hdevtools {};

  ########## nixpkgs overrides ##########

  # cabalNoLinks = self.cabal.override { enableHyperlinkSource = false; };
  # disableLinks = x: x.override { cabal = self.cabalNoLinks; };

  # systemFileio = self.disableTest  super.systemFileio;
  # shake        = self.disableTest  super.shake;
  # unlambda     = self.disableLinks super.unlambda;
};

##############################################################################

haskellTools = ghcEnv: ([
  ghcEnv.ghc
  sloccount
  emacs24Packages.idris
] ++ (with ghcEnv.hsPkgs; [
  cabal-bounds
  cabal-install
  ghc-core
  ghc-mod
  hdevtools
  hlint
  ihaskell
  (myHoogleLocal ghcEnv)
]) ++ (with haskell-ng.packages.ghc784; [
  cabal2nix
  codex
  hobbes
  # simple-mirror
  hasktags
  cabal-meta
  djinn mueval
  idris
  threadscope
  timeplot splot
  liquidhaskell cvc4
  hakyll
]) ++ (with haskell-ng.packages.ghc763; [
  #lambdabot
]));

agdaEnv = pkgs.myEnvFun {
  name = "agda";
  buildInputs = [
    haskellPackages.Agda
    AgdaStdlib
    #haskellPackages.AgdaPrelude
  ];
};

buildToolsEnv = pkgs.buildEnv {
  name = "buildTools";
  paths = [
    ninja
    scons
    global
    autoconf automake114x
    # bazaar bazaarTools
    ccache
    cvs cvsps
    # darcs
    diffstat
    doxygen
    # haskellngPackages.newartisans
    fcgi
    flex
    htmlTidy
    lcov
    mercurial
    patch
    subversion
  ];
};

emacsToolsEnv = pkgs.buildEnv {
  name = "emacsTools";
  paths = [ emacs aspell aspellDicts.en ] ++
    (with self.emacs24Packages; [
      auctex
    ]);
};

coqEnv = pkgs.myEnvFun {
  name = "coqHEAD";
  buildInputs = [ coq_HEAD ];
};

coq85Env = pkgs.myEnvFun {
  name = "coq85";
  buildInputs = [
    coq_8_5beta1
    coqPackages.mathcomp_1_5_for_8_5beta1
    coqPackages.ssreflect_1_5_for_8_5beta1
  ];
};

coqToolsEnv = pkgs.buildEnv {
  name = "coqTools";
  paths = [
    ocaml
    ocamlPackages.camlp5_transitional
    coq
    #coqPackages.bedrock
    #coqPackages.containers
    #coqPackages.coqExtLib
    coqPackages.coqeal
    coqPackages.domains
    coqPackages.fiat
    coqPackages.flocq
    coqPackages.heq
    coqPackages.mathcomp
    coqPackages.paco
    coqPackages.ssreflect
    coqPackages.tlc
    coqPackages.ynot
    prooftree
    emacs24Packages.proofgeneral_4_3_pre
  ];
};

langToolsEnv = pkgs.buildEnv {
  name = "langTools";
  paths = [
    clang llvm boost
    ott isabelle
    gnumake
    compcert #verasco
    # fsharp
    #rustc                # jww (2015-02-01): now needs procps?
    sbcl acl2
    erlang
    swiProlog
    yuicompressor
  ];
 };

gameToolsEnv = pkgs.buildEnv {
    name = "gameTools";
    paths = [ chessdb craftyFull eboard gnugo ];
  };

gitToolsEnv = pkgs.buildEnv {
    name = "gitTools";
    paths = [
      diffutils patchutils
      #bup                       # jww: joelteon broken
      dar

      haskellngPackages.git-annex
      # haskellngPackages.git-gpush # jww (2014-10-14): broken
      haskellngPackages.git-monitor
      gitAndTools.gitFull
      gitAndTools.gitflow
      gitAndTools.hub
      gitAndTools.topGit

      haskellngPackages.git-all
    ];
  };

systemToolsEnv = pkgs.buildEnv {
  name = "systemTools";
  paths = [
    haskellngPackages.pushme
    haskellngPackages.sizes
    haskellngPackages.una

    ack
    # apg
    cabextract
    bashInteractive
    bashCompletion
    exiv2
    expect
    figlet
    findutils
    gnugrep
    gnupg
    gnuplot
    gnused
    gnutar
    #graphviz
    guile
    # haskellngPackages.hours
    imagemagick
    less
    #macvim                # jww: joelteon broken
    multitail
    nixbang
    p7zip
    haskellngPackages.pandoc
    parallel
    pinentry
    pv
    recutils
    rlwrap
    screen
    silver-searcher
    sqlite
    stow
    time
    tmux
    tree
    #unarj                       # jww: joelteon broken (no gcc)
    unrar
    unzip
    watch
    watchman
    xquartz xlibs.xauth xlibs.xhost
    xz
    z3
    zip
    zsh
  ];
};

networkToolsEnv = pkgs.buildEnv {
  name = "networkTools";
  paths = [
    arcanist
    aria
    cacert
    fping
    httrack
    iperf
    mosh
    mtr
    openssl
    rsync
    s3cmd
    socat2pre
    spiped
    #zswaks
    wget
    youtubeDL
  ];
};

mailToolsEnv = pkgs.buildEnv {
  name = "mailTools";
  paths = [
    leafnode dovecot22 dovecot_pigeonhole fetchmail procmail w3m
    mairix mutt msmtp lbdb contacts spamassassin
  ];
};

publishToolsEnv = pkgs.buildEnv {
  name = "publishTools";
  paths = [ texLiveFull djvu2pdf ghostscript librsvg ];
};

serviceToolsEnv = pkgs.buildEnv {
  name = "serviceTools";
  paths = [ nginx postgresql redis pdnsd mysql55 nodejs ];
};

perlToolsEnv = pkgs.buildEnv {
  name = "perlTools";
  paths = [ perl ];
};

pythonToolsEnv = pkgs.buildEnv {
  name = "pythonTools";
  paths = [
    python27Full
    pythonDocs.pdf_letter.python27
    pythonDocs.html.python27
    python27Packages.ipython
  ];
};

rubyToolsEnv = pkgs.buildEnv {
  name = "rubyTools";
  paths = [ ruby_2_1_2 ];
};

##############################################################################

myHoogleLocal = ghcEnv: ghcEnv.hsPkgs.hoogleLocal.override {
  packages = myPackages ghcEnv;
};

ghcTools = ghcEnv: pkgs.myEnvFun {
  name = ghcEnv.name;
  buildInputs = haskellTools ghcEnv ++ myPackages ghcEnv;
};

haskellPackages_wrapper = hp: hp.override {
  overrides = haskellProjects;
};

# haskell-ng.packages.ghc763 = haskellPackages_wrapper self.haskell-ng.packages.ghc763;
# # haskell-ng.packages.ghc763.profiling =
# #   haskellPackages_wrapper (recurseIntoAttrs haskell-ng.packages.ghc763.profiling);

# ghcEnv_763 = ghcTools {
#   name   = "ghc763";
#   ghc    = ghc.ghc763;
#   hsPkgs = haskell-ng.packages.ghc763;
# };
# # ghcEnv_763_profiling = ghcTools {
# #   name   = "ghc763-prof";
# #   ghc    = ghc.ghc763;
# #   hsPkgs = haskell-ng.packages.ghc763_profiling;
# # };

# haskell-ng.packages.ghc784 =
#   haskellPackages_wrapper self.haskell-ng.packages.ghc784;
# haskell-ng.packages.ghc784.profiling =
#   haskellPackages_wrapper (recurseIntoAttrs haskell-ng.packages.ghc784.profiling);

ghcEnv_784 = ghcTools {
  name   = "ghc784";
  ghc    = ghc.ghc784;
  # hsPkgs = haskell-ng.packages.ghc784;
  hsPkgs = haskellPackages_wrapper self.haskell-ng.packages.ghc784;
};
# ghcEnv_784_profiling = ghcTools {
#   name   = "ghc784-prof";
#   ghc    = ghc.ghc784;
#   hsPkgs = haskell-ng.packages.ghc784_profiling;
# };

##############################################################################

myPackages = ghcEnv: with ghcEnv.hsPkgs; [
  Boolean
  CC-delcont
  HTTP
  HUnit
  IfElse
  MemoTrie
  MissingH
  MonadCatchIO-transformers
  QuickCheck
  abstract-deque
  abstract-par
  adjunctions
  aeson
  async
  attempt
  attoparsec
  attoparsec-conduit
  attoparsec-enumerator
  base16-bytestring
  base64-bytestring
  base-unicode-symbols
  basic-prelude
  bifunctors
  bindings-DSL
  blaze-builder
  blaze-builder-conduit
  blaze-builder-enumerator
  blaze-html
  blaze-markup
  blaze-textual
  bool-extras
  byteable
  byteorder
  bytes
  bytestring-mmap
  case-insensitive
  cassava
  #categories
  cereal
  cereal-conduit
  charset
  cheapskate
  chunked-data
  classy-prelude
  classy-prelude-conduit
  cmdargs
  comonad
  comonad-transformers
  composition
  compressed
  cond
  conduit
  conduit-combinators
  conduit-extra
  configurator
  constraints
  contravariant
  convertible
  cpphs
  cryptohash
  css-text
  data-checked
  data-default
  data-fin
  data-fix
  derive
  distributive
  dlist
  dlist-instances
  dns
  doctest
  doctest-prop
  either
  #ekg
  enclosed-exceptions
  errors
  # esqueleto
  exceptions
  extensible-exceptions
  failure
  fast-logger
  file-embed
  filepath
  fingertree
  fmlist
  foldl
  free
  fsnotify
  #free-operational
  ghc-paths
  groups
  hamlet
  hashable
  hashtables
  haskeline
  haskell-lexer
  haskell-src
  haskell-src-exts
  haskell-src-meta
  hfsevents
  hoopl
  hslogger
  hspec
  hspec-expectations
  HStringTemplate
  html
  http-client
  http-date
  http-types
  io-memoize
  io-storage
  json
  keys
  language-c
  language-java
  language-javascript
  lifted-async
  lifted-base
  list-extras
  # logging
  logict
  machines
  mime-mail
  mime-types
  mmorph
  monad-control
  monad-coroutine
  # monad-logger
  monad-loops
  monad-par
  monad-par-extras
  monad-stm
  monadloc
  monoid-extras
  mono-traversable
  mtl
  multimap
  multirec
  network
  newtype
  numbers
  operational
  optparse-applicative
  pandoc
  parallel
  parallel-io
  parsec
  # persistent
  # persistent-postgresql
  # persistent-sqlite
  # persistent-template

  pipes
  # pipes-aeson
  pipes-attoparsec
  pipes-binary
  pipes-bytestring
  pipes-concurrency
  # pipes-csv
  pipes-group
  pipes-http
  pipes-network
  pipes-parse
  # pipes-postgresqlsimple
  pipes-safe
  pipes-text
  # pipes-zlib

  pointed
  posix-paths
  pretty-show
  profunctors
  random
  reducers
  reflection
  regex-applicative
  regex-base
  regex-compat
  regex-posix
  regular
  # resource-pool
  resourcet
  retry
  rex
  safe
  sbv
  scotty
  semigroupoids
  semigroups
  shake
  shakespeare
  shelly
  simple-reflect
  speculation
  split
  spoon
  stm
  stm-chans
  # stm-conduit
  stm-stats
  strict
  strptime
  syb
  system-fileio
  system-filepath
  tagged
  tar
  tasty
  tasty-hunit
  tasty-smallcheck
  tasty-quickcheck
  temporary
  text
  text-format
  these
  thyme
  time
  timeparsers
  time-recurrence
  transformers
  transformers-base
  unix-compat
  unordered-containers
  uuid
  vector
  void
  wai
  warp
  xhtml
  yaml
  # z3
  zippers
  zlib
]

++ pkgs.stdenv.lib.optionals
     (pkgs.stdenv.lib.versionOlder "7.7" ghcEnv.ghc.version)
     # Packages that only work in 7.8+
     [ trifecta
       parsers
       compdata
       singletons
       units
       criterion
       kan-extensions
       pipes-shell
       tasty-hspec
     ]

++ pkgs.stdenv.lib.optionals
     (pkgs.stdenv.lib.versionOlder "7.5" ghcEnv.ghc.version)
     # Packages that only work in 7.6+
     [ folds
       linear
       lens
       lens-family
       lens-family-core
       lens-datetime
     ]

++ pkgs.stdenv.lib.optionals
     (pkgs.stdenv.lib.versionOlder ghcEnv.ghc.version "7.9")
     # Packages that do not work in 7.10+
     [ stringsearch
       exceptions
       arithmoi
       fgl
     ]

++ pkgs.stdenv.lib.optionals
     (pkgs.stdenv.lib.versionOlder ghcEnv.ghc.version "7.7")
     # Packages that do not work in 7.8+
     [ recursion-schemes
     ]

++ pkgs.stdenv.lib.optionals
     (ghcEnv.name != "ghc784-prof")
     # Packages that do not work in specific versions
     [ http-client-tls
       http-conduit
     ]
;

};

allowUnfree = true;
allowBroken = true;

}
