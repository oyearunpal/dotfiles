#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=== Home Manager Configuration Validator ==="
echo

# 1. Check if home.nix exists
echo -n "Checking if home.nix exists... "
if [ -f "$HOME/.config/home-manager/home.nix" ]; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
    exit 1
fi

# 2. Validate Nix syntax
echo -n "Validating Nix syntax... "
if nix-instantiate --parse "$HOME/.config/home-manager/home.nix" >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
    echo "Run 'nix-instantiate --parse ~/.config/home-manager/home.nix' for details"
fi

# 3. Dry-run home-manager build
echo -n "Testing home-manager build (dry-run)... "
if home-manager build --dry-run >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
    echo "Run 'home-manager build --dry-run' for details"
fi

# 4. Check generated Hyprland config
echo -n "Checking generated Hyprland config... "
if [ -L "$HOME/.config/hypr/hyprland.conf" ]; then
    echo -e "${GREEN}✓${NC}"
    
    # Test specific Hyprland options
    echo "  Testing Hyprland configuration options:"
    
    # Test decoration shadow
    echo -n "  - Shadow configuration... "
    if hyprctl keyword decoration:shadow:enabled true >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗${NC}"
    fi
    
    # Test touchpad options
    echo -n "  - Touchpad disable_while_typing... "
    if hyprctl keyword input:touchpad:disable_while_typing true >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗${NC}"
    fi
    
    echo -n "  - Touchpad tap-to-click... "
    if hyprctl keyword input:touchpad:tap-to-click true >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Not linked${NC}"
fi

# 5. Check for common issues
echo
echo "Checking for common issues:"

# Check for deprecated options
echo -n "  - Checking for deprecated col.shadow... "
if grep -q "col\.shadow" "$HOME/.config/home-manager/home.nix"; then
    echo -e "${RED}✗ Found deprecated option${NC}"
else
    echo -e "${GREEN}✓${NC}"
fi

echo -n "  - Checking for deprecated drop_shadow... "
if grep -q "drop_shadow\s*=" "$HOME/.config/home-manager/home.nix"; then
    echo -e "${RED}✗ Found deprecated option${NC}"
else
    echo -e "${GREEN}✓${NC}"
fi

# 6. Show what would be built
echo
echo "Configuration summary:"
echo -n "  - Total derivations to build: "
home-manager build --dry-run 2>&1 | grep -oP "will be built:.*" | grep -oP "\d+" || echo "0"

# 7. Check for warnings
echo
echo "Checking for warnings:"
WARNINGS=$(home-manager build --dry-run 2>&1 | grep -i "warning" || true)
if [ -z "$WARNINGS" ]; then
    echo -e "  ${GREEN}No warnings found${NC}"
else
    echo -e "  ${YELLOW}Warnings found:${NC}"
    echo "$WARNINGS" | sed 's/^/    /'
fi

echo
echo "=== Validation complete ==="
