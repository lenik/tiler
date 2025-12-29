# Tiler: Command-Line Tool for Window Tiling on X11

**Tiler** is a command-line tool written in Python, designed to tile windows on the desktop in an X11 environment. It allows users to automatically arrange and resize windows based on various configurations with support for window aspect ratio and custom tiling options.

## Features

- **Tile Windows**: Automatically arrange and resize windows on the desktop
- **Match by Application Name**: Select windows based on the application name
- **Aspect Ratio Control**: Set a fixed aspect ratio for window resizing
- **Multiple Tiling Modes**:
  - Horizontal tiling (one row, multiple columns)
  - Vertical tiling (one column, multiple rows)
  - Grid layout (default - rows & columns)
- **Margin Settings**: Add customizable margins around tiled windows

## Installation

1. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

2. **Make the script executable**:
   ```bash
   chmod +x tiler
   ```

3. **Optional: Add to PATH**:
   ```bash
   # Add to ~/.bashrc or ~/.zshrc
   export PATH="$PATH:/path/to/tiler"
   
   # Or create a symlink
   sudo ln -s /path/to/tiler/tiler /usr/local/bin/tiler
   ```

4. **Optional: Enable bash completion**:
   ```bash
   # For current session
   source tiler-completion.bash
   
   # For permanent installation (after system install)
   # Bash completion is automatically available after 'make install'
   
   # For manual setup, copy to bash completion directory
   sudo cp tiler-completion.bash /usr/share/bash-completion/completions/tiler
   ```

## Usage

### Basic Commands

```bash
# Tile all windows in a grid (default behavior)
./tiler

# Tile all windows horizontally
./tiler -H

# Tile all windows vertically
./tiler -V
```

### Application-Specific Tiling

```bash
# Tile only specific applications
./tiler -a "Firefox" -a "Terminal"

# Tile Chrome windows horizontally
./tiler -a "Chrome" -H
```

### Aspect Ratio Control

```bash
# Set 16:9 aspect ratio for all windows
./tiler -r 16:9

# Combine with other options
./tiler -a "Firefox" -r 4:3 -V
```

### Margin Settings

```bash
# Apply 10px margin on all sides
./tiler -m 10

# Different margins: top=10, right=20, bottom=15, left=5
./tiler -m 10 20 15 5

# Combine with tiling modes
./tiler -a "Chrome" -a "Vim" -H -m 5
```

## Command-Line Options

| Option | Description |
|--------|-------------|
| `-a`, `--for-app NAME` | Select windows by application name (repeatable) |
| `-r`, `--aspect-ratio W:H` | Set aspect ratio (e.g., 16:9) |
| `-H`, `--horizontal` | Tile windows horizontally |
| `-V`, `--vertical` | Tile windows vertically |
| `-m`, `--margin TOP [RIGHT [BOTTOM [LEFT]]]` | Set margins in pixels |

## Examples

1. **Basic grid tiling**:
   ```bash
   ./tiler
   ```

2. **Horizontal layout with margins**:
   ```bash
   ./tiler -H -m 10
   ```

3. **Specific apps with aspect ratio**:
   ```bash
   ./tiler -a "Firefox" -a "Terminal" -r 16:9
   ```

4. **Vertical layout with custom margins**:
   ```bash
   ./tiler -V -m 5 10 5 10
   ```

## Requirements

- Python 3.x
- X11 environment (Linux desktop)
- `python-xlib` library
- `psutil` library

## Bash Completion

Tiler includes comprehensive bash completion support that provides:

- **Option completion**: Tab completion for all command-line options (`-a`, `--circular`, etc.)
- **Application name completion**: Suggests running applications for `-a/--for-app`
- **Value suggestions**: Common values for aspect ratios, margins, and circular parameters
- **Context-aware completion**: Different completions based on the current option

After installation, bash completion is automatically available. For manual setup, source the completion script:
```bash
source tiler-completion.bash
```

## Troubleshooting

### Common Issues

1. **"No windows found"**: Make sure you have visible windows open
2. **Permission errors**: Ensure you're running in an X11 session
3. **Import errors**: Install dependencies with `pip install -r requirements.txt`

### Debug Mode

To see which windows are detected:
```bash
python3 -c "
from tiler import Tiler
t = Tiler()
windows = t.get_all_windows()
for w in windows:
    print(f'{w.name}: {w.width}x{w.height} at ({w.x},{w.y})')
t.close()
"
```

## License

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

## Author

Copyright (C) 2025 Lenik <tiler@bodz.net>
