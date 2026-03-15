#!/usr/bin/env bash
#
# OpenClaw Memory System Installer
# 兼容: Linux & macOS
# 用法: ./install-memory-system.sh [--workspace PATH]
#
# 功能：
#   - 创建三层记忆架构目录
#   - 生成必要的配置和模板文件
#   - 配置 memlog.sh 自动时间戳日志工具

set -euo pipefail

# 检测操作系统
OS="$(uname -s)"
if [[ "$OS" == "Darwin" ]]; then
    # macOS
    DATE_CMD="gdate"  # 需要 brew install coreutils
    # 检查是否有 gdate
    if ! command -v gdate &> /dev/null; then
        echo -e "\033[1;33m提示: macOS 需要安装 coreutils 来支持日期格式化:\033[0m"
        echo "  brew install coreutils"
        echo "  或者使用: brew install coreutils"
        # 回退到系统 date（可能不完全兼容）
        DATE_CMD="date"
    fi
else
    # Linux
    DATE_CMD="date"
fi

# 默认值
WORKSPACE="${HOME}/.openclaw/workspace"
MEMORY_DIR=""
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 用法说明
usage() {
    cat << EOF
OpenClaw Memory System Installer

用法: $0 [选项]

选项:
  --workspace PATH    OpenClaw workspace 路径 (默认: ~/.openclaw/workspace)
  -h, --help          显示帮助信息

示例:
  $0                                    # 使用默认路径
  $0 --workspace /path/to/workspace   # 指定自定义路径

EOF
    exit 0
}

# 解析参数
while [[ $# -gt 0 ]]; do
    case $1 in
        --workspace)
            WORKSPACE="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "未知选项: $1"
            usage
            ;;
    esac
done

MEMORY_DIR="${WORKSPACE}/memory"

# 检查目录是否存在
if [[ ! -d "$WORKSPACE" ]]; then
    echo -e "${RED}错误: Workspace 目录不存在: $WORKSPACE${NC}"
    exit 1
fi

echo -e "${GREEN}=== OpenClaw Memory System Installer ===${NC}"
echo "Workspace: $WORKSPACE"
echo "Memory Dir: $MEMORY_DIR"
echo ""

# 1. 创建目录结构
echo -e "${YELLOW}[1/6] 创建目录结构...${NC}"
mkdir -p "$MEMORY_DIR"/{lessons,people,decisions,projects,preferences,reflections,actions/{open,in-progress,done},.archive}
echo "  ✓ 目录已创建"

# 2. 创建 NOW.md
echo -e "${YELLOW}[2/6] 创建 NOW.md...${NC}"
cat > "$WORKSPACE/NOW.md" << 'EOF'
# NOW.md - 工作台

> 🎯 **Mission**: 核心目标

## Today
- 

## P0 Priorities
| # | Item | Status | Owner |
|---|------|--------|-------|
| P0 | | | |
| P1 | | | |

## Agent Status
| Agent | Focus |
|-------|-------|
| | |

---
*Updated: 
EOF
echo "  ✓ NOW.md 已创建"

# 3. 创建 AGENTS.md
echo -e "${YELLOW}[3/6] 创建 AGENTS.md...${NC}"
cat > "$WORKSPACE/AGENTS.md" << 'EOF'
# AGENTS.md - Agent 操作手册

## Session Startup（必须按顺序执行）
1. Read NOW.md - 了解当前状态和任务优先级
2. Read memory/INDEX.md - 了解知识库结构
3. Read memory/YYYY-MM-DD.md (today) - 了解今天发生了什么
4. Read memory/preferences/user-preferences.md - 了解用户偏好

## Memory Rules

### 写入时机
- 完成任务时
- 做出重要决策时
- 获得关于用户的新信息时
- 用户告诉重要的事情时

### 写入格式
```bash
# 使用 memlog.sh 写入日志
memlog.sh "Title" "Body content"
```

### 路由规则
- 重大决策？→ decisions/YYYY-MM-DD-slug.md
- 可复用经验？→ lessons/TOPIC.md
- 关于人的信息？→ people/NAME.md
- 其他值得记录的？→ memory/YYYY-MM-DD.md

### NOW.md 更新
- 每次对话结束/重要任务完成后更新
- 只覆写，不追加

### 重要原则
- 不知道的事情坚决说不知道
- 不胡编、不瞎猜
- 文件 = 事实来源。不写进文件 = 从来不知道
EOF
echo "  ✓ AGENTS.md 已创建"

# 4. 创建 HEARTBEAT.md
echo -e "${YELLOW}[4/6] 创建 HEARTBEAT.md...${NC}"
cat > "$WORKSPACE/HEARTBEAT.md" << 'EOF'
# HEARTBEAT.md

### 检查项（每 30 分钟）

1. **扫描活跃 session 消息**
   - 提取重要信息

2. **写入日志**
   - 使用 memlog.sh 记录事件

3. **路由判断**
   - 是否需要写入知识库？（先读再写）

4. **刷新 NOW.md**
   - 更新当前任务和状态

5. **检查任务生命周期**
   - actions/open/ → actions/in-progress/
   - actions/in-progress/ → actions/done/

### 写入禁忌
- ❌ 硬编码时间戳（用脚本自动获取）
- ❌ 用 Edit 修改 memory/ 文件
- ❌ 用 Write 覆写已有 memory/ 文件（NOW.md 除外）
- ❌ 写无实质内容的噪音
- ❌ 不读就写知识文件
EOF
echo "  ✓ HEARTBEAT.md 已创建"

# 5. 创建 INDEX.md
echo -e "${YELLOW}[5/6] 创建 INDEX.md...${NC}"
cat > "$MEMORY_DIR/INDEX.md" << 'EOF'
# Memory Vault Index

> Agent 启动时先扫这个文件，按需加载具体内容。

## Lessons
| 文件 | 优先级 | 状态 | 最后验证 | 说明 |
|------|--------|------|----------|------|
| | | | | |

## Decisions
| 文件 | 说明 |
|------|------|
| | |

## People
| 文件 | 优先级 | 状态 | 说明 |
|------|--------|------|------|
| | | | |

## Projects
| 文件 | 状态 | 说明 |
|------|------|------|
| | | |

## Preferences
| 文件 | 说明 |
|------|------|
| user-preferences.md | 用户偏好与沟通方式 |

---
*Last Updated: 
EOF
echo "  ✓ INDEX.md 已创建"

# 6. 创建 memlog.sh
echo -e "${YELLOW}[6/6] 创建 memlog.sh...${NC}"
cat > "$MEMORY_DIR/memlog.sh" << 'EOF'
#!/usr/bin/env bash
# memlog.sh — 自动时间戳的日志追加工具
# 用法: memlog.sh "Title" "Content body"

set -euo pipefail

MEMORY_DIR="${MEMORY_DIR:-$HOME/.openclaw/workspace/memory}"
TODAY=$(date +%Y-%m-%d)
NOW=$(date +%H:%M)
FILE="$MEMORY_DIR/$TODAY.md"

TITLE="${1:?Usage: memlog.sh \"Title\" \"Body\"}"
BODY="${2:-}"

# 如果文件不存在，创建带日期标题的文件
if [[ ! -f "$FILE" ]]; then
    printf "# %s\n\n" "$TODAY" > "$FILE"
fi

# 追加带时间戳的条目
{
    printf "\n### %s — %s\n" "$NOW" "$TITLE"
    [[ -n "$BODY" ]] && printf "\n%s\n" "$BODY"
} >> "$FILE"

echo "✓ Logged to $TODAY.md at $NOW"
EOF
chmod +x "$MEMORY_DIR/memlog.sh"
echo "  ✓ memlog.sh 已创建"

# 7. 创建默认用户偏好文件
echo -e "${YELLOW}[Bonus] 创建用户偏好模板...${NC}"
cat > "$MEMORY_DIR/preferences/user-preferences.md" << 'EOF'
---
title: "用户偏好"
date: 
category: preferences
priority: 🔴
status: active
last_verified: 
tags: [preferences, user]
---

# 用户偏好

## 沟通方式
- 喜欢直接、高效的沟通
- 不喜欢闲聊，直接说重点
- 可以开玩笑但不要太过

## 忌讳
- ❌ 不希望 AI 胡编乱造
- ❌ 不希望被假设不知道的信息
- ❌ 不喜欢华而不实的东西

## 技术偏好
- 使用 Claude / MiniMax 模型
- 注重稳定性和实用性
- 喜欢自动化和效率工具

## 其他
- 
EOF
echo "  ✓ user-preferences.md 模板已创建"

# 8. 添加到 PATH
echo -e "${YELLOW}[配置] 添加 memlog.sh 到 PATH...${NC}"
PROFILE_FILE="$HOME/.bashrc"
if [[ -f "$HOME/.zshrc" ]]; then
    PROFILE_FILE="$HOME/.zshrc"
fi

# 检查是否已经添加
if ! grep -q "memlog.sh" "$PROFILE_FILE" 2>/dev/null; then
    echo '' >> "$PROFILE_FILE"
    echo '# OpenClaw Memory System' >> "$PROFILE_FILE"
    echo "export PATH=\"$MEMORY_DIR:\$PATH\"" >> "$PROFILE_FILE"
    echo "  ✓ 已添加到 $PROFILE_FILE"
else
    echo "  ✓ PATH 已配置"
fi

# 测试 memlog.sh
echo -e "${YELLOW}[测试] 测试 memlog.sh...${NC}"
export PATH="$MEMORY_DIR:$PATH"
memlog.sh "系统安装测试" "记忆系统安装成功" > /dev/null 2>&1
echo "  ✓ 测试通过"

echo ""
echo -e "${GREEN}=== 安装完成! ===${NC}"
echo ""
echo "使用方法:"
echo "  1. 重新加载配置: source ~/.bashrc"
echo "  2. 写入日志: memlog.sh \"标题\" \"内容\""
echo ""
echo "文件位置:"
echo "  - NOW.md: $WORKSPACE/NOW.md"
echo "  - AGENTS.md: $WORKSPACE/AGENTS.md"
echo "  - HEARTBEAT.md: $WORKSPACE/HEARTBEAT.md"
echo "  - memory/: $MEMORY_DIR/"
echo ""
