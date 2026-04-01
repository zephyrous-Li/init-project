# Hooks

Git hooks and automation scripts for the init-project project.

## Purpose

This directory is reserved for Git hooks and automation scripts that can enhance the development workflow.

## Potential Uses

Future hook scripts could include:

- **Pre-commit hooks** - Validate template syntax before committing
- **Pre-push hooks** - Run tests before pushing to remote
- **Post-merge hooks** - Update dependencies after merging
- **Commit-msg hooks** - Enforce commit message conventions

## Adding Hooks

To add a Git hook:

1. Create a script in this directory
2. Make it executable: `chmod +x hooks/your-hook`
3. Link it to `.git/hooks/`: `ln -s ../../hooks/your-hook .git/hooks/`

## Example

```bash
# Create a pre-commit hook
cat > hooks/pre-commit << 'EOF'
#!/bin/bash
# Validate templates before commit
echo "Validating templates..."
bash templates/validate.sh
EOF

chmod +x hooks/pre-commit
ln -s ../../hooks/pre-commit .git/hooks/pre-commit
```
