# di

A tiny CLI wrapper providing concise aliases for common Deno commands — inspired by [@antfu/ni](https://github.com/antfu/ni).

## Features

| Alias     | Runs             |
| --------- | ---------------- |
| `dr`      | `deno run`       |
| `da`      | `deno add`       |
| `di`      | `deno install`   |
| `drm`     | `deno remove`    |
| `dun`     | `deno uninstall` |
| `df`      | `deno fmt`       |
| `dl`      | `deno lint`      |
| `dc`      | `deno cache`     |
| `dcl`     | `deno clean`     |
| `di-help` | For help         |

## Installation

**For macOS and Linux only**

```bash
curl -fsSL https://raw.githubusercontent.com/itsithu/di/main/install.sh | sh
```

## Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/itsithu/di/main/uninstall.sh | sh
```

## Usage

After installation, you can start using the shortcuts immediately in new terminals or run:

```bash
source ~/.zshrc  # or ~/.bashrc, ~/.profile depending on your shell
```

Run `di-help` anytime to see the available commands and project info.

## Platform Support

Currently, `di` supports **macOS** and **Linux**. Windows support is **welcome**! Feel free to contribute a port or open an issue for discussion.

## Contributing

Contributions are highly appreciated!  
Feel free to submit issues, pull requests, or feature suggestions.

## License

MIT License

## Credits

Inspired by [@antfu/ni](https://github.com/antfu/ni) — thanks for the inspiration!
