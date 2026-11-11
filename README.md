# Orchis Reborn theme

Orchis Reborn, based on [Orchis](https://github.com/vinceliuice/Orchis-theme),
is a [Material Design](https://material.io) theme for GNOME/GTK based desktop
environments.

Nix-only build. Four variants, all with light + dark bundled; color-scheme and
accent handled by GTK / libadwaita.

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
