# Miprota — Material Design 3 SDDM Theme

A clean, modern SDDM login theme inspired by Material Design 3.

![preview](preview.png)

## Features

- **Blurred background** — your wallpaper shines through with a soft blur and dark overlay
- **Material Design 3 color tokens** — primary `#D0BCFF`, surface `#28242C`, on-surface `#E6E1E5`
- **Multi-monitor support** — background repeats correctly across screens
- **Session switcher** — pill-style dropdown to choose between desktop sessions
- **Avatar support** — circular-cropped avatar above the username field
- **Login error shake** — card shakes on failed login, with error message display
- **Shutdown / Reboot** — icon buttons at the bottom with Chinese labels
- **Fade-to-black transition** — smooth fade on successful login
- **No external fonts required** — uses "Google Sans Flex" (falls back gracefully)

## Customization

Edit `theme.conf` to change the background image:

```ini
[General]
background=assets/background.png
```

Replace `assets/background.png` with your own wallpaper. Replace `assets/avatar.png` with your own avatar.

## Installation

### Manual

```bash
sudo cp -r miprota /usr/share/sddm/themes/
```

Then edit `/etc/sddm.conf.d/theme.conf`:

```ini
[Theme]
Current=miprota
```

### From AUR (coming soon)

```bash
yay -S sddm-theme-miprota
```

## License

MIT — see [LICENSE](LICENSE) file.

## Credits

Designed and built by [Neo](https://github.com/LaT-SKY) with Claude.
