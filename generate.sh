#!/bin/bash

##############################################################################
# init-project - Claude Code 项目配置生成器
#
# 用途：一键生成完整的 Claude Code 配置结构
# 作者：Claude (千千)
# 版本：1.0.0
##############################################################################

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 脚本目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

# 计数器
CREATED=0
SKIPPED=0
ASKED=0

##############################################################################
# 辅助函数
##############################################################################

# 打印带颜色的消息
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_skip() {
    echo -e "${NC}⊘ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# 检查是否在 git 仓库中
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_warning "未检测到 Git 仓库"
        echo "建议先运行: git init"
        read -p "是否继续？[y/N] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 0
        fi
    fi
}

# 确保目录存在
ensure_dir() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
    fi
}

# 询问是否覆盖
ask_overwrite() {
    local file="$1"
    ((ASKED += 1))
    print_warning "文件已存在: $file"

    # 检测是否在交互式终端中
    if [ -t 0 ]; then
        # 交互模式：读取用户输入
        read -p "是否覆盖？[y/N] " -n 1 -r
        echo
        [[ $REPLY =~ ^[Yy]$ ]]
    else
        # 非交互模式：从标准输入读取一行（支持 yes 命令或重定向）
        read -r REPLY
        [[ $REPLY =~ ^[Yy]$ ]]
    fi
}

# 从模板创建文件
create_from_template() {
    local template="$1"
    local target="$2"
    local target_dir="$(dirname "$target")"

    # 检查模板是否存在
    if [[ ! -f "$SCRIPT_DIR/templates/$template" ]]; then
        print_warning "模板文件不存在: $template"
        return 1
    fi

    # 如果目标文件存在，询问是否覆盖
    if [[ -f "$target" ]]; then
        if ! ask_overwrite "$target"; then
            print_skip "跳过: $target"
            ((SKIPPED += 1))
            return 0  # 返回0，跳过文件不是错误
        fi
    fi

    # 确保目录存在
    ensure_dir "$target_dir"

    # 复制模板内容
    cp "$SCRIPT_DIR/templates/$template" "$target"
    print_success "创建: $target"
    ((CREATED += 1))
    return 0
}

# 初始化 CodeGraph
init_codegraph() {
    # 检查 .codegraph/ 目录是否已存在
    if [[ -d "$PROJECT_ROOT/.codegraph" ]]; then
        print_info "CodeGraph 已初始化，跳过"
        return 0
    fi

    # 检查 codegraph 命令是否可用
    if ! command -v codegraph &> /dev/null; then
        print_warning "未检测到 codegraph 命令"

        # 询问是否安装
        if [ -t 0 ]; then
            read -p "是否安装 CodeGraph (npx @colbymchenry/codegraph)？[y/N] " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                print_skip "跳过 CodeGraph 安装"
                return 0
            fi
        else
            # 非交互模式：从标准输入读取
            read -r REPLY
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                print_skip "跳过 CodeGraph 安装"
                return 0
            fi
        fi

        # 执行安装
        print_info "正在安装 CodeGraph..."
        if npx @colbymchenry/codegraph &> /dev/null; then
            print_success "CodeGraph 安装成功"
        else
            print_warning "CodeGraph 安装失败，跳过初始化"
            return 0
        fi
    fi

    # 询问是否初始化
    print_info "检测到 CodeGraph MCP 服务"
    if [ -t 0 ]; then
        read -p "是否初始化 CodeGraph？[y/N] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_skip "跳过 CodeGraph 初始化"
            return 0
        fi
    else
        # 非交互模式：从标准输入读取
        read -r REPLY
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_skip "跳过 CodeGraph 初始化"
            return 0
        fi
    fi

    # 执行初始化
    print_info "正在初始化 CodeGraph..."
    if cd "$PROJECT_ROOT" && codegraph init -i; then
        print_success "CodeGraph 初始化成功"
    else
        print_warning "CodeGraph 初始化失败，继续..."
    fi
}

# 更新 .gitignore
update_gitignore() {
    local gitignore="$PROJECT_ROOT/.gitignore"
    local entries=(
        "# Claude Code local configurations"
        "CLAUDE.local.md"
        ".claude/settings.local.json"
        "# CodeGraph MCP index"
        ".codegraph/"
    )

    # 检查是否已存在
    if grep -q "Claude Code local configurations" "$gitignore" 2>/dev/null; then
        return 0
    fi

    # 添加条目
    {
        echo ""
        for entry in "${entries[@]}"; do
            echo "$entry"
        done
    } >> "$gitignore"

    print_info "已更新 .gitignore"
}

##############################################################################
# 文件生成
##############################################################################

# 生成所有文件
generate_all() {
    echo -e "${BLUE}🚀 开始生成 Claude Code 配置...${NC}"
    echo ""

    # 核心配置文件
    create_from_template "CLAUDE.md.template" "$PROJECT_ROOT/CLAUDE.md"
    create_from_template "CLAUDE.local.md.template" "$PROJECT_ROOT/CLAUDE.local.md"
    create_from_template "settings.json.template" "$PROJECT_ROOT/.claude/settings.json"
    create_from_template "settings.local.json.template" "$PROJECT_ROOT/.claude/settings.local.json"

    # commands/
    create_from_template "commands-README.md.template" "$PROJECT_ROOT/.claude/commands/README.md"

    # rules/
    create_from_template "rules-README.md.template" "$PROJECT_ROOT/.claude/rules/README.md"
    create_from_template "rules-code-style.md.template" "$PROJECT_ROOT/.claude/rules/code-style.md"
    create_from_template "rules-testing.md.template" "$PROJECT_ROOT/.claude/rules/testing.md"
    create_from_template "rules-api-conventions.md.template" "$PROJECT_ROOT/.claude/rules/api-conventions.md"

    # skills/
    create_from_template "skills-README.md.template" "$PROJECT_ROOT/.claude/skills/README.md"

    # agents/
    create_from_template "agents-README.md.template" "$PROJECT_ROOT/.claude/agents/README.md"
    create_from_template "agents-code-reviewer.md.template" "$PROJECT_ROOT/.claude/agents/code-reviewer.md"
    create_from_template "agents-security-auditor.md.template" "$PROJECT_ROOT/.claude/agents/security-auditor.md"

    # 初始化 CodeGraph
    init_codegraph

    # 更新 .gitignore
    update_gitignore

    # 打印总结
    echo ""
    echo -e "${BLUE}📊 生成完成！${NC}"
    echo "   创建: $CREATED 个文件"
    echo "   跳过: $SKIPPED 个文件"
    echo "   询问: $ASKED 次"
    echo ""

    # 下一步提示
    print_info "下一步："
    echo "   1. 查看 CLAUDE.md 并根据项目定制"
    echo "   2. 查看 .claude/rules/ 中的规范文件"
    echo "   3. 提交到 Git: git add . && git commit -m 'chore: add Claude Code config'"
}

##############################################################################
# 主函数
##############################################################################

main() {
    # 检查 Git 仓库
    check_git_repo

    # 生成所有文件
    generate_all
}

# 运行主函数
main "$@"