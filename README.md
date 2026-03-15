# OpenClaw Memory System

OpenClaw 记忆管理系统，基于 [Ray Wang](https://x.com/wangray) 的 [实战指南](https://x.com/wangray/status/2027034737311907870) 实现。

## 特性

- 🧠 **三层记忆架构**: 短期(NOW.md) → 中期(日志) → 长期(知识库)
- 📝 **自动时间戳**: `memlog.sh` 脚本自动记录时间
- 🔄 **自动衰减**: 基于温度模型的遗忘机制
- 🔍 **混合检索**: 关键词 + 向量语义搜索
- 🤖 **多 Agent 支持**: 独立记忆空间，跨 Agent 信息聚合
- 🌐 **跨平台**: Linux / macOS / Windows (Git Bash)

## 快速开始

### 安装

```bash
# 克隆仓库
git clone https://github.com/swizardlv/openclaw_enhance_memory.git
cd openclaw_enhance_memory

# 运行安装脚本
./install-memory-system.sh --workspace ~/.openclaw/workspace
```

### 使用

```bash
# 写入日志
memlog.sh "完成了什么" "具体内容"

# 读取今日日志
cat memory/$(date +%Y-%m-%d).md
```

### Windows 使用

```powershell
# 使用 Git Bash 运行
./install-memory-system.sh --workspace ~/.openclaw/workspace
```

> 注意：Windows 路径格式可能不同，如 `/c/Users/...`

## 目录结构

```
~/.openclaw/workspace/
├── NOW.md              # 短期：状态仪表盘（覆写式）
├── AGENTS.md           # Agent 操作手册
├── HEARTBEAT.md        # Heartbeat 执行流程
└── memory/
    ├── INDEX.md        # 知识导航
    ├── YYYY-MM-DD.md  # 每日日志（追加式）
    ├── lessons/         # 可复用经验
    ├── people/         # 人物画像
    ├── decisions/      # 战略决策
    ├── projects/       # 项目追踪
    ├── preferences/    # 用户偏好
    ├── reflections/    # 每日自省
    ├── actions/        # 任务卡片
    │   ├── open/
    │   ├── in-progress/
    │   └── done/
    └── .archive/       # 冷存储
```

## 系统架构

### 三层记忆

| 层级 | 文件 | 特点 |
|------|------|------|
| 短期 | NOW.md | 每次 heartbeat 覆写，记录当前状态 |
| 中期 | memory/YYYY-MM-DD.md | 每日日志，追加式 |
| 长期 | INDEX.md → lessons/people/ | 结构化知识库 |

### 信息流动

```
对话/事件 → 日志 (memlog.sh)
     ↓
每晚反思 → 提炼到知识库
     ↓
定期归档 → .archive/ 冷存储
```

## 核心原则

> **文件 = 事实来源。你不写进文件的东西 = 你从来不知道的东西。**

### 写入规则

- ✅ 完成任务时写入日志
- ✅ 做出重要决策时写入 decisions/
- ✅ 获得可复用经验时写入 lessons/
- ✅ 获得用户新信息时写入 people/
- ❌ 不要硬编码时间戳（用脚本自动获取）
- ❌ 不要不读就写知识文件

### 检索优先级

1. **L1**: 扫描 INDEX.md → 定位目标文件
2. **L2**: 直接读取目标文件
3. **L3**: QMD 语义搜索（兜底方案）

## 相关资源

- [Ray Wang 原文](https://x.com/wangray/status/2027034737311907870)
- [OpenClaw 官方文档](https://docs.openclaw.ai)

## License

MIT
