{
  description = "Orchis-Reborn — a Material Design GTK theme for GNOME 51";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f (import nixpkgs { inherit system; }));

      # Two orthogonal options:
      #   opacity:    "default" (transparent) | "solid"
      #   panelStyle: "float"   (floating)    | "compact" (attached)
      variants = {
        "Orchis-Reborn"               = { opacity = "default"; panelStyle = "float";   };
        "Orchis-Reborn-Solid"         = { opacity = "solid";   panelStyle = "float";   };
        "Orchis-Reborn-Compact"       = { opacity = "default"; panelStyle = "compact"; };
        "Orchis-Reborn-Solid-Compact" = { opacity = "solid";   panelStyle = "compact"; };
      };

      mkTheme = pkgs: name: { opacity, panelStyle }:
        let
          # Written via printf '%s' so shell doesn't interpret $-prefixed sass vars
          wrapper = variant: topbar: entry: ''
            $variant: '${variant}';
            $topbar: '${topbar}';
            $panel_style: '${panelStyle}';
            $opacity: '${opacity}';

            @import '${entry}';
          '';
        in
        pkgs.stdenvNoCC.mkDerivation {
          pname = pkgs.lib.toLower name;
          version = "0.1.0";
          src = ./.;

          nativeBuildInputs = [ pkgs.sassc ];

          buildPhase = ''
            runHook preBuild

            printf '%s' ${pkgs.lib.escapeShellArg (wrapper "light" "light" "src/gtk/4.0/gtk")}      > gtk-light.scss
            printf '%s' ${pkgs.lib.escapeShellArg (wrapper "dark"  "dark"  "src/gtk/4.0/gtk")}      > gtk-dark.scss
            printf '%s' ${pkgs.lib.escapeShellArg (wrapper "light" "dark" "src/gnome-shell/shell-51-0/gnome-shell")} > shell.scss

            sassc -t expanded gtk-light.scss gtk-4.0-light.css
            sassc -t expanded gtk-dark.scss  gtk-4.0-dark.css
            sassc -t expanded shell.scss gnome-shell.css

            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall

            dest=$out/share/themes/${name}
            mkdir -p $dest/{gtk-4.0,gnome-shell}

            # GTK 4
            cp src/gtk/4.0/adaptive.css $dest/gtk-4.0/gtk.css
            cp gtk-4.0-light.css $dest/gtk-4.0/gtk-light.css
            cp gtk-4.0-dark.css  $dest/gtk-4.0/gtk-dark.css
            cp -r src/gtk/assets   $dest/gtk-4.0/assets
            cp -r src/gtk/scalable $dest/gtk-4.0/assets/scalable

            # GNOME Shell
            cp gnome-shell.css $dest/gnome-shell/gnome-shell.css
            cp -r src/gnome-shell/assets $dest/gnome-shell/assets
            cp -r src/gnome-shell/common-assets $dest/gnome-shell/common-assets
            cp -r src/gnome-shell/extensions    $dest/gnome-shell/extensions
            cp src/gnome-shell/pad-osd.css      $dest/gnome-shell/pad-osd.css
            cp src/gnome-shell/activities/activities-default.svg $dest/gnome-shell/assets/activities.svg
            cp src/gnome-shell/theme/*.svg      $dest/gnome-shell/

            cat > $dest/index.theme <<EOF
            [Desktop Entry]
            Type=X-GNOME-Metatheme
            Name=${name}
            Comment=Orchis-Reborn — Material Design theme for GNOME 51
            Encoding=UTF-8

            [X-GNOME-Metatheme]
            GtkTheme=${name}
            MetacityTheme=${name}
            IconTheme=Adwaita
            CursorTheme=Adwaita
            ButtonLayout=close,minimize,maximize:
            EOF

            runHook postInstall
          '';

          meta = with pkgs.lib; {
            description = "Orchis-Reborn ${name} — Material Design theme for GNOME 51";
            homepage = "https://github.com/TA-Solaris/Orchis-Reborn-theme";
            license = licenses.gpl3Only;
            platforms = platforms.linux;
          };
        };
    in
    {
      packages = forAllSystems (pkgs:
        let
          built = pkgs.lib.mapAttrs (name: cfg: mkTheme pkgs name cfg) variants;
          all = pkgs.symlinkJoin {
            name = "orchis-reborn-all";
            paths = builtins.attrValues built;
          };
        in
        built // {
          all = all;
          default = all;
        });

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = [ pkgs.sassc pkgs.nixpkgs-fmt ];
        };
      });

      formatter = forAllSystems (pkgs: pkgs.nixpkgs-fmt);
    };
}
