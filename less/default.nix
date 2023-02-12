{
  # Core nixpkgs imports
  pkgs,
  # Derivation utils
  makeWrapper, symlinkJoin,
}:

let
  # TODO: Generate lesskey from config
  lesskeyBin = pkgs.runCommand "lesskey-bin" {} ''
    ${pkgs.less}/bin/lesskey -o $out -- ${./lesskey}
  '';
in symlinkJoin {
  name = "less";
  paths = [ pkgs.less ];
  buildInputs = [ makeWrapper ];
  # TODO: IMPURITY - lesskey loading will fetch from system paths and
  # environment variable. may be a good idea to see if this can be overridden
  # TODO: Set default flags from config. Possibly set in lesskey
  postBuild = ''
    mv "$out/bin/less" "$out/bin/less-unwrapped"
    makeWrapper \
      "$out/bin/less-unwrapped" \
      "$out/bin/less" \
      --add-flags "--lesskey-file=${lesskeyBin}" \
      --add-flags "--chop-long-lines" \
      --add-flags "--RAW-CONTROL-CHARS" \
      --add-flags "--quit-if-one-screen" \
      --add-flags "--mouse" \
      --add-flags "--wheel-lines=5" \
      --add-flags "--ignore-case" \
      --add-flags "--prompt=%lb/%L" \
  '';
}
