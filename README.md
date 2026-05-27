<p align="center">
  <img src="Eidolon.png" alt="Eidolon" width="50%">
</p>

<h1 align="center">Eidolon</h1>

<p align="center">
  <b>AI-powered red team toolkit.</b><br>
  Claude Code in every container. Think, hack, pivot — in natural language.
</p>

<p align="center">
  <sub>基于 <a href="https://github.com/hacktivesec/ghostwire">GhostWire</a> 二次开发 · 7 种场景化渗透容器 + Claude Code AI 驱动</sub>
</p>

<p align="center">
  <a href="#"><img alt="Ubuntu 24.04" src="https://img.shields.io/badge/base-Ubuntu%2024.04-EB5E28?logo=ubuntu&logoColor=white"></a>
  <a href="#"><img alt="amd64+arm64" src="https://img.shields.io/badge/arch-amd64%20%7C%20arm64-1F6FEB"></a>
  <a href="#"><img alt="AI Powered" src="https://img.shields.io/badge/AI-Claude%20Code%20%7C%20DeepSeek-8B5CF6"></a>
  <a href="#"><img alt="Non-root" src="https://img.shields.io/badge/user-ghost%20(non--root)-6C757D"></a>
  <a href="LICENSE"><img alt="License" src="https://img.shields.io/badge/license-CC0-0A0A0A"></a>
</p>

---

## 为什么是 Eidolon？

**传统渗透的问题**：你面对一个目标，需要同时做三件事——操作工具、分析结果、决定下一步。每个环节都有认知负担：nmap 参数记不全、BloodHound 边看不全、报告写到手软。

**Eidolon 的答案**：把 AI 塞进渗透容器。

每个变体都可以加载 **Claude Code**（通过 DeepSeek 的 Anthropic 兼容 API）。你用自然语言下指令，AI 帮你选工具、读输出、写报告。它不替代你——它帮你省掉重复劳动，让你专注在策略和决策上。

```
你：帮我看看 dc.corp.local 开了哪些端口，然后告诉我最可能的值守入口
AI：nmap 发现 88 (Kerberos), 389 (LDAP), 445 (SMB), 636 (LDAPS), 3389 (RDP).
    SMB 445 + LDAP 389 都在，先从 SMB 签名检测开始？
    要我跑 nxc smb dc.corp.local --pass-pol 吗？
```

这就是 Eidolon 和其他工具箱的本质区别：**不是工具多，而是工具聪明**。

| 能力 | Eidolon | Kali (Docker) | Parrot OS | 自己搭环境 |
|---|---|---|---|---|
| **AI 驱动** | 内置 Claude Code，自然语言下指令 | 无 | 无 | 无 |
| **交互方式** | "帮我审计这个 AD 域" 一句话搞定 | 逐条手动敲命令 | 逐条手动敲命令 | 逐条手动敲命令 |
| **自动化报告** | AI 读输出 → 整合 → markdown | 无，手工整理 | 无，手工整理 | 无，自己写脚本 |
| **启动到首次扫描** | **~30s** | 几分钟（拉完还得 apt install） | 几分钟（~4.7GB 镜像） | 半天起步 |
| **SOCKS 跳板** | 内置 `px` 透明代理，开箱即用 | 手配 proxychains | 手配 proxychains | 手配 |
| **按场景分离** | 7 + 1 个变体，按需拉取 | 1 个大而全镜像 | 单镜像 | 全装一起 |
| **镜像大小（单变体）** | ~2GB | 基础 46MB，装完膨胀 | ~4.7GB | 不可控 |
| **非 root 运行** | 是（UID 1001 `ghost` 用户） | 否 | 否 | 通常 root |
| **依赖锁定** | 全部锁版本，可复现 | apt rolling，不可复现 | apt rolling | 无 |
| **镜像签名** | Cosign OIDC + SLSA L2 + SBOM | 无 | 无 | 无 |

---

## 快速开始：AI 渗透体验

### 1. 准备 API Key

去 [DeepSeek](https://platform.deepseek.com) 申请一个 API Key（几块钱就够用很久）。然后：

```bash
# 创建 .env 文件（已在 .gitignore 中，不会提交）
echo 'DEEPSEEK_API_KEY=sk-your-key-here' > .env
```

### 2. 启动 Claude 变体（推荐从这里开始）

```bash
# 用脚本一键启动（自动加载 .env）
./eidolon-claude.sh

# 或者用 docker-compose
docker-compose up -d claude
docker-compose exec claude bash
```

进入容器后，你会看到终端提示符带有 `[eidolon-claude]` 标签。AI 已经就绪——所有 Claude Code 权限已配好，模型后端走 DeepSeek。

### 3. 开始对话式渗透

```bash
# 创建项目
gw new mytarget

# 然后直接对 AI 说你想做什么——
# "帮我枚举 example.com 的子域名，挑出存活站点，用 nuclei 扫一遍"
# "分析这个 AD 域的 BloodHound 路径，找最短到 DA 的路"
# "根据 /shared/recon/ 里的输出，帮我写一份渗透测试报告"
```

AI 会自己调用 container 里的工具，读输出，分析结果，引导你走完整个渗透流程。

### 4. 其他变体也可以用 AI

```bash
# Web 渗透 + AI
docker-compose up -d web
docker-compose exec web bash
# 对 AI 说：sqlmap 发现注入点，接下来怎么办？

# AD 渗透 + AI
docker-compose up -d ad
docker-compose exec ad bash
# 对 AI 说：分析 BloodHound 输出，部署 SMB 中继
```

---

## 7 个变体 + 1 个 AI 变体

| 变体 | 用途 | AI | 核心工具 |
|------|------|:--:|----------|
| **claude** | AI 渗透（自然语言驱动） | ✓ | Claude Code CLI, Node.js 22, 所有 base 工具 |
| **web** | Web 应用渗透 | ✓ 可选 | `ffuf`, `gobuster`, `nikto`, `sqlmap`, `nuclei`, `whatweb`, `subfinder`, `katana` |
| **net** | 网络扫描与隧道 | ✓ 可选 | `nmap`, `masscan`, `tcpdump`, `chisel`, `socat`, `hydra`, `openvpn` |
| **ad** | Active Directory | ✓ 可选 | `nxc`, `bloodhound-python`, `certipy`, `kerbrute`, `responder`, `impacket` |
| **mobile** | 移动应用分析 | ✓ 可选 | `jadx`, `apktool`, `frida-tools`, `objection`, `radare2`, `MobSF` |
| **wifi** | 无线安全 | ✓ 可选 | `aircrack-ng`, `reaver`, `hcxdumptool`, `hcxtools` |
| **pivot** | 跳板 & SOCKS | - | `microsocks`, `chisel`, `sshuttle`, `openvpn`, `wireguard-tools` |
| **base** | 共享基础层 | - | Python venv, `px`/`pxcurl`/`pxwget`, `gw` 编排器 |

> 标记"可选"的变体：进入容器后 `claude` 命令可用，但需要配置 API key。`claude` 变体则开箱即用。

---

## 部署方式

### 方式一：AI 一键体验（推荐）

```bash
git clone https://github.com/Megalomanian/eidolon.git
cd eidolon
echo 'DEEPSEEK_API_KEY=sk-your-key-here' > .env
./eidolon-claude.sh
# 进入容器，直接对 AI 说话
```

### 方式二：拉预构建镜像

```bash
mkdir -p ./artifacts && sudo chown 1001:1001 ./artifacts
docker pull ghcr.io/megalomanian/eidolon-claude:latest
docker run --rm -it --network host \
  -e DEEPSEEK_API_KEY=sk-your-key \
  -v "$PWD:/work" -v "$PWD/artifacts:/shared" \
  ghcr.io/megalomanian/eidolon-claude:latest
```

### 方式三：本地构建

```bash
make base    # 基础镜像（一次性）
make claude  # 构建 AI 变体
# 其他变体：make web, make ad, make mobile...
make build-all  # 全部构建
make test-all   # 冒烟测试全部
```

---

## `gw` 编排器

```bash
gw new acme                       # 创建渗透项目
gw use acme                       # 切换到指定项目
gw ls                             # 列出所有项目
cdgw                              # cd 到当前项目目录

gw recon acme.com                 # 子域名 → httpx → nuclei
gw web https://app.acme.com       # whatweb + wafw00f + nuclei + nikto + gobuster
gw fuzz "https://acme.com/FUZZ"   # ffuf 目录爆破
gw ad 10.0.0.10 alice 'P@ss'      # nxc + kerbrute + bloodhound + certipy
gw mobile app.apk                 # jadx + apkid + apktool + mobsfscan
gw wifi wlan0                     # airodump-ng 抓包

gw report                         # 整合为 markdown 报告
```

输出结构：`/shared/<client>/<UTC-date>/{recon,scans,creds,loot,reports,logs}`

---

## SOCKS 跳板

```bash
# 启动跳板
docker run -d --name pivot --network vpn \
  -p 127.0.0.1:1080:1080 \
  ghcr.io/megalomanian/eidolon-pivot:latest gw-socks5 1080

# 从其他变体穿越
docker run --rm -it --network vpn \
  -e SOCKS5_HOST=pivot -e SOCKS5_PORT=1080 \
  ghcr.io/megalomanian/eidolon-web:latest

# 容器内透明代理
px curl -I https://internal.corp.local
px gw recon internal.corp.local
```

> SYN/UDP 扫描不走 SOCKS5（L3 层），直接登录跳板容器执行。

---

## 文件 I/O

| 路径 | 用途 |
|------|------|
| `/work` | bind-mount 到宿主机当前目录 |
| `/shared` | 渗透输出，映射到 `./artifacts/` |
| `/shared/<client>/<date>/` | `gw new` 自动创建 |

```bash
savehere report.txt              # 复制到 /shared
out nmap -sC -sV target          # 执行 + tee 到 /shared
gw-versions /shared/versions.txt # 工具版本清单
```

---

## 渗透方法论

完整 8 阶段方法论见 **[PENTEST-METHODOLOGY.md](PENTEST-METHODOLOGY.md)**，AI 会按这个流程引导你：

0. 前期准备 → 1. 侦察 → 2. 漏洞发现 → 3. 初始访问 → 4. 后渗透 → 5. 横向移动 → 6. 目标达成 → 7. 报告

---

## 镜像安全

- **Cosign**：无密钥 OIDC 签名，锚定 GitHub Actions workflow
- **SLSA L2**：构建溯源随镜像推送
- **SBOM**：syft SPDX 格式
- **依赖锁定**：所有 git clone、Go module 使用不可变引用

---

## 常见问题

| 现象 | 解决方法 |
|------|----------|
| `container name already in use` | `docker rm -f eidolon-<variant>` |
| Docker Desktop SOCKS 不通 | 设置 `SOCKS5_HOST=host.docker.internal` |
| API Key 不生效 | 检查 `.env` 文件是否在项目根目录 |
| arm64 构建失败 | 提 issue，附变体名称 + Dockerfile 行号 |
| 健康检查红灯 | `docker logs <container>` 然后 `smoke-test <variant>` |

---

## 声明

**仅限有明确书面授权的系统上使用。** 操作者自行对法律法规和 RoE 负责。详见 [SECURITY.md](SECURITY.md)。

---

## 致谢

Eidolon 基于 **[GhostWire](https://github.com/hacktivesec/ghostwire)** 二次开发，感谢上游项目提供的 Docker 化渗透框架和 `gw` 编排器。

在此基础上，Eidolon 增加了 Claude Code + DeepSeek 的 AI 渗透能力、中文本地化支持，以及若干工作流优化。

每个集成工具的许可证在其镜像中适用，锁定版本见 `Dockerfile.<variant>` 和 [CHANGELOG.md](CHANGELOG.md)。
