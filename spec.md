### **Tiler: Command-Line Tool for Window Tiling on X11**

**Tiler** is a **command-line tool** written in Python, designed to **tile windows on the desktop** in an **X11** environment. It allows users to automatically arrange and resize windows based on various configurations. With support for **window aspect ratio** and custom tiling options, Tiler is a flexible utility for organizing windows efficiently.

---

### **Key Features**

1. **Tile Windows**: Automatically arrange and resize windows on the desktop.
2. **Match by Application Name**: Select windows based on the application name.
3. **Aspect Ratio Control**: Set a fixed aspect ratio for window resizing.
4. **Tiling Modes**:

   * **Horizontal tiling**
   * **Vertical tiling**
   * **Default (rows & columns)**
5. **Margin Settings**: Add customizable margins around tiled windows for a cleaner layout.

---

### **CLI Options**

Here is a breakdown of the available options for the **Tiler** tool:

#### **1. General Options**

* **`-a` / `--for-app NAME`**
  Select windows by matching the application name. Can be repeated to match multiple applications. If no applications are specified, all visible windows on the desktop are selected.

  ```bash
  tiler -a "Firefox" -a "Terminal"
  ```

* **`-r` / `--aspect-ratio W:H`**
  Set the aspect ratio for resizing windows. The ratio is defined as **width:height** (e.g., `-r 16:9` to resize windows with a 16:9 aspect ratio).

  ```bash
  tiler -r 16:9
  ```

* **`-H` / `--horizontal`**
  Tile windows horizontally (one row with multiple columns).

  ```bash
  tiler -H
  ```

* **`-V` / `--vertical`**
  Tile windows vertically (one column with multiple rows).

  ```bash
  tiler -V
  ```

* **`-m` / `--margin TOP [RIGHT [BOTTOM [LEFT]]]`**
  Set margins for the windows. You can specify margins for all sides or just one side. The values represent the top, right, bottom, and left margins in pixels.

  ```bash
  tiler -m 10 20 15 5
  ```

  If only the top margin is specified:

  ```bash
  tiler -m 10
  ```

#### **2. Default Behavior**

* If no specific options are provided, **Tiler** will tile windows in a **grid** layout with both **rows and columns**.

---

### **Usage Examples**

1. **Tile all windows** in a grid (default behavior):

   ```bash
   tiler
   ```

2. **Tile all windows** horizontally:

   ```bash
   tiler -H
   ```

3. **Tile windows** vertically:

   ```bash
   tiler -V
   ```

4. **Tile only specific applications** (e.g., Firefox and Terminal):

   ```bash
   tiler -a "Firefox" -a "Terminal"
   ```

5. **Set a specific aspect ratio** for all windows (e.g., 16:9):

   ```bash
   tiler -r 16:9
   ```

6. **Tile with margins** (e.g., 10px top margin, 20px right margin, 15px bottom, 5px left):

   ```bash
   tiler -m 10 20 15 5
   ```

7. **Tile windows** horizontally for specific applications with a margin:

   ```bash
   tiler -a "Chrome" -a "Vim" -H -m 5
   ```

---

### **Implementation Details**

**Tiler** uses Python with the **X11** window system, leveraging libraries like `python-xlib` to interact with windows. The tool will perform the following steps:

1. **Window Selection**:

   * Identify all visible windows on the desktop.
   * If the `--for-app` flag is specified, windows matching the app names will be selected.

2. **Window Geometry**:

   * Retrieve the geometry (size and position) of each selected window.
   * Based on the tiling option (`-H`, `-V`, or default), compute the new positions and sizes for each window.
   * Apply the specified aspect ratio and margin to adjust the windows accordingly.

3. **Window Manipulation**:

   * Use the **X11** API (through `python-xlib` or similar) to resize and move windows according to the computed layout.

4. **Margin and Padding**:

   * If margins are specified, adjust the positions of the windows accordingly to maintain the requested spacing between them.

---

### **Dependencies**

* **Python** 3.x
* **python-xlib** (for interacting with X11)

  * Install with `pip install python-xlib`
* **xprop** (to list window properties like name)
* **wmctrl** (for window management)

---

### **Conclusion**

**Tiler** is a simple yet powerful **command-line tool** for tiling windows on an **X11** desktop. With options to select windows by application name, control aspect ratios, and apply margins, **Tiler** provides an easy way to organize your workspace, whether you're working with a few apps or need to manage dozens of windows.

