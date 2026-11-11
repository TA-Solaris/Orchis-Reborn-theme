# Orchis Reborn theme

Orchis Reborn, based on [Orchis](https://github.com/vinceliuice/Orchis-theme),
is a [Material Design](https://material.io) theme for GNOME/GTK based desktop
environments.

Supports GTK 4.20+ / libadwaita and GNOME Shell 51.
Four layout variants, each with light and dark styles.

GTK4 uses native `prefers-color-scheme` media queries: Default gives light windows
and white popovers with dark text; Dark gives dark windows and popovers.
Controls follow the system accent, and Settings retains all nine accent swatches.
Import the theme's `gtk-4.0/gtk.css` for adaptive styling; importing `gtk-light.css`
or an older fixed-colour Orchis stylesheet forces that appearance.

GNOME Shell uses St CSS, a separate engine from GTK4. Select `Orchis-Reborn` for
light popups or `Orchis-Reborn-Dark` for dark popups (likewise for the other
layout variants). The panel keeps its original dark appearance in both modes;
its opacity, spacing and shape depend only on the layout variant.
Shell controls use the native system accent. The User Themes
extension loads a fixed stylesheet, so the Settings Default/Dark switch does not
automatically change a custom Shell theme. This package installs no switching
services or extensions.

## Variants

Two orthogonal options:

- **Solid** — opaque panel (vs transparent)
- **Compact** — attached panel (vs floating)

| Variant                       | Opacity     | Panel    |
| ----------------------------- | ----------- | -------- |
| `Orchis-Reborn`               | transparent | floating |
| `Orchis-Reborn-Solid`         | solid       | floating |
| `Orchis-Reborn-Compact`       | transparent | compact  |
| `Orchis-Reborn-Solid-Compact` | solid       | compact  |

## Install

### Flake input

```nix
{
  inputs.orchis-reborn.url = "github:TA-Solaris/Orchis-Reborn-theme";
}
```

### Home-manager

```nix
{ inputs, pkgs, ... }: {
  home.packages = [ inputs.orchis-reborn.packages.${pkgs.system}.Orchis-Reborn ];
  gtk.theme.name = "Orchis-Reborn";
}
```

Use any of the four package attrs: `Orchis-Reborn`, `Orchis-Reborn-Solid`,
`Orchis-Reborn-Compact`, `Orchis-Reborn-Solid-Compact`. `default` / `all` bundle
every variant.

### Build directly

```sh
nix build github:TA-Solaris/Orchis-Reborn-theme#Orchis-Reborn
```

Output lands at `result/share/themes/Orchis-Reborn`.

## Develop

```sh
nix develop
nix build .#Orchis-Reborn
```

Dev shell provides `sassc`.
