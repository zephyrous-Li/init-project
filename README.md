# init-project

> Enhanced Claude Code project initialization with comprehensive templates and best practices

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude_Code-Compatible-blue.svg)](https://github.com/anthropics/claude-code)

## Overview

`init-project` is an enhanced project initialization tool for Claude Code that generates a complete, production-ready configuration structure. Unlike the basic `/init` command, this skill provides detailed templates, comprehensive documentation, and established best practices for teams and individual developers.

**Inspired by** [peterskoett/self-improving-agent](https://github.com/peterskoett/self-improving-agent), adapted for project initialization use cases.

## Features

- 🚀 **One-Command Setup** - Generate complete Claude Code configuration structure instantly
- 📝 **Comprehensive Templates** - Detailed, production-ready templates for all configuration files
- 🎯 **Best Practices** - Built-in conventions for code style, testing, and API design
- 🤖 **Agent Definitions** - Pre-configured templates for code review and security audit agents
- 🔧 **Interactive & Friendly** - Respects existing files, asks before overwriting
- 📦 **Modular Structure** - Organized commands, rules, skills, and agents directories
- 🎨 **Colored Output** - Clear, color-coded feedback for all operations

## Installation

### As a Claude Code Skill

1. Clone this repository to your Claude Code skills directory:
```bash
# Clone to your skills directory
git clone https://github.com/zephyrous-Li/init-project.git ~/.claude/skills/init-project
```

2. Make the generation script executable:
```bash
chmod +x ~/.claude/skills/init-project/generate.sh
```

3. Use via Claude Code:
```
/init-project
```

Or invoke the skill directly:
```
Skill("init-project")
```

### Manual Installation

1. Clone the repository:
```bash
git clone https://github.com/YOUR_USERNAME/init-project.git
cd init-project
```

2. Run the generation script:
```bash
bash generate.sh
```

## Usage

### Quick Start

Generate Claude Code configuration for your current project:

```bash
# From your project root
bash ~/.claude/skills/init-project/generate.sh
```

### What Gets Created

```
project-root/
├── CLAUDE.md                   # Team-level instructions (commit to Git)
├── CLAUDE.local.md             # Personal overrides (gitignored)
└── .claude/
    ├── settings.json           # Permissions and configuration (commit to Git)
    ├── settings.local.json     # Personal settings (gitignored)
    ├── commands/               # Custom slash commands
    │   └── README.md
    ├── rules/                  # Modular instruction files
    │   ├── README.md
    │   ├── code-style.md       # Code style conventions
    │   ├── testing.md          # Testing standards
    │   └── api-conventions.md  # API design patterns
    ├── skills/                 # Auto-triggered workflows
    │   └── README.md
    └── agents/                 # Sub-agent role definitions
        ├── README.md
        ├── code-reviewer.md    # Code review agent
        └── security-auditor.md # Security audit agent
```

### Interactive Mode

The script asks before overwriting existing files:

```bash
$ bash generate.sh
🚀 开始生成 Claude Code 配置...

⚠️  文件已存在: CLAUDE.md
是否覆盖？[y/N] N
⊘ 跳过: CLAUDE.md

✅ 创建: .claude/rules/code-style.md
```

### Non-Interactive Mode

For automation, pipe `yes` or use `y` inputs:

```bash
yes | bash generate.sh    # Overwrite all existing files
echo "y" | bash generate.sh  # Overwrite first file only
```

## Project Structure

```
init-project/
├── SKILL.md              # Skill documentation for Claude Code
├── generate.sh           # Main generation script
├── templates/            # Template files for generation
│   ├── CLAUDE.md.template
│   ├── CLAUDE.local.md.template
│   ├── settings.json.template
│   ├── settings.local.json.template
│   ├── commands-README.md.template
│   ├── rules-README.md.template
│   ├── rules-code-style.md.template
│   ├── rules-testing.md.template
│   ├── rules-api-conventions.md.template
│   ├── skills-README.md.template
│   ├── agents-README.md.template
│   ├── agents-code-reviewer.md.template
│   └── agents-security-auditor.md.template
├── assets/               # Supporting assets and documentation
├── hooks/                # Git hooks and automation scripts
├── references/           # Additional documentation and references
└── README.md             # This file
```

## Customization

### Modifying Templates

Edit templates in `templates/` to customize generated files:

```bash
# Edit the main CLAUDE.md template
vim templates/CLAUDE.md.template
```

### Adding New Templates

1. Create a new template file in `templates/`
2. Add a `create_from_template()` call in `generate.sh`
3. Update this README's Project Structure section

### Team Customization

For team-wide customization:

1. Fork this repository
2. Modify templates to match your team's conventions
3. Distribute the fork to team members
4. Encourage contributions back to the templates

## Templates Overview

### Core Configuration

- **CLAUDE.md** - Project-level instructions, tech stack, workflow, commit conventions
- **CLAUDE.local.md** - Personal overrides without affecting team config
- **settings.json** - Team-level permissions and tool configurations
- **settings.local.json** - Personal permission overrides

### Rules (Modular Instructions)

- **code-style.md** - Naming conventions, commenting standards, code organization
- **testing.md** - Test strategy, unit tests, integration tests, coverage requirements
- **api-conventions.md** - RESTful patterns, error handling, response formats

### Agents

- **code-reviewer.md** - Code review dimensions, process, checklists
- **security-auditor.md** - Security checks, vulnerability scanning, best practices

## Best Practices

1. **Start Fresh** - Run on new projects before development begins
2. **Version Control** - Commit `CLAUDE.md` and `.claude/settings.json` to Git
3. **Team Alignment** - Use consistent templates across team projects
4. **Iterate** - Update templates as your practices evolve
5. **Review Regularly** - Keep generated files synchronized with template changes

## Git Integration

The script automatically updates `.gitignore` to exclude personal configurations:

```gitignore
# Claude Code local configurations
CLAUDE.local.md
.claude/settings.local.json
```

**Commit to Git:**
- `CLAUDE.md` - Team instructions
- `.claude/settings.json` - Team permissions
- `.claude/rules/*.md` - Team standards
- `.claude/agents/*.md` - Agent definitions

**Don't Commit (Personal):**
- `CLAUDE.local.md` - Personal overrides
- `.claude/settings.local.json` - Personal permissions

## Contributing

Contributions are welcome! Areas for improvement:

- Additional template variations
- Support for more programming languages
- Enhanced error handling
- Additional agent definitions
- Documentation improvements

### Development

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-change`
3. Make your changes
4. Test the script: `bash generate.sh`
5. Commit changes: `git commit -m 'feat: add my feature'`
6. Push to branch: `git push origin feature/my-change`
7. Open a Pull Request

## Acknowledgments

- **Built for** [Claude Code](https://github.com/anthropics/claude-code) by Anthropic
- **License**: MIT - See [LICENSE](LICENSE) for details

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- **Claude Code Documentation**: https://github.com/anthropics/claude-code
- **Issue Tracker**: Report bugs and request features via GitHub Issues
- **Discussions**: Ask questions and share ideas in GitHub Discussions

---

Made with ❤️ for the Claude Code community
