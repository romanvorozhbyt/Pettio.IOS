#!/bin/bash

# Install git hooks for this project
# Run: bash .githooks/install-hooks.sh

HOOKS_DIR=".githooks"
GIT_HOOKS_DIR=".git/hooks"

echo "📦 Installing git hooks..."
echo "============================="

# Create .git/hooks directory if it doesn't exist
mkdir -p "$GIT_HOOKS_DIR"

# Copy hooks
if [ -f "$HOOKS_DIR/pre-commit" ]; then
    cp "$HOOKS_DIR/pre-commit" "$GIT_HOOKS_DIR/pre-commit"
    chmod +x "$GIT_HOOKS_DIR/pre-commit"
    echo "✅ pre-commit hook installed"
else
    echo "❌ pre-commit hook not found"
fi

# Configure git to use .githooks directory
git config core.hooksPath "$HOOKS_DIR" 2>/dev/null || echo "⚠️  Unable to configure git hooks path"

echo ""
echo "✅ Git hooks installed successfully!"
echo ""
echo "Hooks installed:"
echo "- pre-commit: Checks for common mistakes before committing"
echo ""

