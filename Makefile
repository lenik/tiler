# Makefile for Tiler - X11 Window Tiling Tool

# Default installation paths
PREFIX ?= /usr/local
DESTDIR ?=

# Paths
BINDIR = $(PREFIX)/bin
SHAREDIR = $(PREFIX)/share
APPDIR = $(SHAREDIR)/applications
APPDATADIR = $(SHAREDIR)/metainfo
DOCDIR = $(SHAREDIR)/doc/tiler

# Source files
SCRIPT = tiler.py
DESKTOP = tiler.desktop
APPDATA = io.github.tiler.metainfo.xml
DOCS = README.md spec.md

.PHONY: all install install-debug uninstall clean check

all:
	@echo "Tiler - X11 Window Tiling Tool"
	@echo "Available targets:"
	@echo "  install       - Install to system (respects DESTDIR and PREFIX)"
	@echo "  install-debug - Install debug version with symlinks to /usr"
	@echo "  uninstall     - Remove installed files"
	@echo "  check         - Check dependencies and syntax"
	@echo "  clean         - Clean temporary files"

# Production install target - respects DESTDIR and PREFIX
install:
	@echo "Installing Tiler to $(DESTDIR)$(PREFIX)..."
	
	# Create directories
	install -d $(DESTDIR)$(BINDIR)
	install -d $(DESTDIR)$(APPDIR)
	install -d $(DESTDIR)$(APPDATADIR)
	install -d $(DESTDIR)$(DOCDIR)
	
	# Install main script
	install -m 755 $(SCRIPT) $(DESTDIR)$(BINDIR)/tiler
	
	# Install desktop file
	install -m 644 $(DESKTOP) $(DESTDIR)$(APPDIR)/
	
	# Install appdata
	install -m 644 $(APPDATA) $(DESTDIR)$(APPDATADIR)/
	
	# Install documentation
	install -m 644 $(DOCS) $(DESTDIR)$(DOCDIR)/
	install -m 644 requirements.txt $(DESTDIR)$(DOCDIR)/
	
	@echo "Installation complete!"
	@echo "Run 'tiler --help' to get started"

# Debug install target - creates symlinks in /usr (ignores DESTDIR/PREFIX)
install-debug:
	@echo "Installing Tiler in debug mode with symlinks to /usr..."
	
	# Create directories in /usr
	sudo mkdir -p /usr/bin
	sudo mkdir -p /usr/share/applications
	sudo mkdir -p /usr/share/metainfo
	sudo mkdir -p /usr/share/doc/tiler
	
	# Create symlinks to source files
	sudo ln -sf $(PWD)/$(SCRIPT) /usr/bin/tiler
	sudo ln -sf $(PWD)/$(DESKTOP) /usr/share/applications/
	sudo ln -sf $(PWD)/$(APPDATA) /usr/share/metainfo/
	sudo ln -sf $(PWD)/README.md /usr/share/doc/tiler/
	sudo ln -sf $(PWD)/spec.md /usr/share/doc/tiler/
	sudo ln -sf $(PWD)/requirements.txt /usr/share/doc/tiler/
	
	@echo "Debug installation complete!"
	@echo "Symlinks created in /usr pointing to $(PWD)"
	@echo "Changes to source files will be immediately available"

# Uninstall target
uninstall:
	@echo "Uninstalling Tiler..."
	
	# Remove files (try both possible locations)
	rm -f $(DESTDIR)$(BINDIR)/tiler
	rm -f $(DESTDIR)$(APPDIR)/$(DESKTOP)
	rm -f $(DESTDIR)$(APPDATADIR)/$(APPDATA)
	rm -rf $(DESTDIR)$(DOCDIR)
	
	# Also remove debug symlinks if they exist
	sudo rm -f /usr/bin/tiler
	sudo rm -f /usr/share/applications/$(DESKTOP)
	sudo rm -f /usr/share/metainfo/$(APPDATA)
	sudo rm -rf /usr/share/doc/tiler
	
	@echo "Uninstall complete!"

# Check dependencies and syntax
check:
	@echo "Checking Tiler..."
	
	# Check Python syntax
	python3 -m py_compile $(SCRIPT)
	@echo "✓ Python syntax OK"
	
	# Check for required Python modules
	@python3 -c "import Xlib" 2>/dev/null && echo "✓ python-xlib available" || echo "✗ python-xlib missing (run: pip install python-xlib)"
	@python3 -c "import argparse" 2>/dev/null && echo "✓ argparse available" || echo "✗ argparse missing"
	
	# Check if running in X11 environment
	@if [ -n "$$DISPLAY" ]; then echo "✓ X11 display available"; else echo "✗ No X11 display (DISPLAY not set)"; fi
	
	# Validate desktop file if it exists
	@if [ -f "$(DESKTOP)" ]; then \
		if command -v desktop-file-validate >/dev/null 2>&1; then \
			desktop-file-validate $(DESKTOP) && echo "✓ Desktop file valid" || echo "✗ Desktop file invalid"; \
		else \
			echo "? desktop-file-validate not available (install desktop-file-utils to validate)"; \
		fi \
	fi
	
	# Validate appdata if it exists
	@if [ -f "$(APPDATA)" ]; then \
		if command -v appstream-util >/dev/null 2>&1; then \
			appstream-util validate-relax $(APPDATA) && echo "✓ AppData file valid" || echo "✗ AppData file invalid"; \
		else \
			echo "? appstream-util not available (install appstream-util to validate)"; \
		fi \
	fi

# Clean temporary files
clean:
	@echo "Cleaning temporary files..."
	find . -name "*.pyc" -delete
	find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
	rm -f *.deb
	@echo "Clean complete!"

# Development targets
dev-install: install-debug

dev-uninstall: uninstall

# Show current configuration
config:
	@echo "Current configuration:"
	@echo "  PREFIX = $(PREFIX)"
	@echo "  DESTDIR = $(DESTDIR)"
	@echo "  BINDIR = $(DESTDIR)$(BINDIR)"
	@echo "  SHAREDIR = $(DESTDIR)$(SHAREDIR)"
	@echo "  PWD = $(PWD)"
