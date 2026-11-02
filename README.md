# Kensaku 一键安装指南

> 第三方部署指南 · 非 Kensaku 官方仓库。官方项目：[yjid/kensaku](https://github.com/yjid/kensaku)
> 内容来自官方文档（2026-11-02）。项目迭代快，请以[官方文档](https://github.com/yjid/kensaku#install)为准。

[![⚡ 一键安装](https://img.shields.io/badge/%E2%9A%A1_%E4%B8%80%E9%94%AE%E5%AE%89%E8%A3%85-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#一键安装推荐用百度搭子)

## 一键安装（推荐：用百度搭子）

> [!TIP]
> 你记得的是内容，不是文件名；搜索就该按内容来。

⚠️ 桌面应用，装完常驻托盘，靠快捷键唤起，没有网页界面。首次运行要选索引目录，OCR 与语义模型包按需联网下载。索引只在本机，agent 通过 `kensaku-cli mcp` 只读访问。Windows 安装包未签名时可能被 SmartScreen 拦。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/kensaku-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子会下载 Windows 安装包并校验 SHA256，装好后提示你先选索引目录，按它的提示确认即可，结束时它会告诉你结果。
   （下载地址与校验方式以官方文档为准。）



## Kensaku 是什么？

Kensaku 是开源的文件名、文档正文、截图里的字都能搜，索引留在本机，还能通过 MCP 借给 agent（协议：MIT，<img src="https://img.shields.io/github/stars/yjid/kensaku?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

本地文件搜索器：文件名毫秒级命中，支持 PDF、DOCX、EPUB 等正文检索、截图 OCR 与语义搜索，并通过 MCP 把同一份索引只读地提供给 coding agent。

- 文件名搜索：10 万文件约 1 毫秒
- 正文检索：PDF、DOCX、EPUB 都能搜
- 截图 OCR：图片里的报错也能找到
- 语义搜索：按描述找文件
- 托盘常驻：快捷键唤起，回车打开
- MCP 只读接入，数据不出本机

（来源：[官方仓库](https://github.com/yjid/kensaku)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 495 stars 10 月新项目 | 名称搜索 316 条但无同名部署指南 |
| 文件名、正文、OCR、语义四种检索合一 | — |
| 10 万文件毫秒级 | 空闲内存约 20 MB |
| 托盘常驻 | 快捷键唤起，回车即开 |
| MCP 只读接入 | 索引不外传 |
| MIT | 自用与二开都自由 |

| 需要注意 | 说明 |
|---|---|
| 纯桌面应用 | 没有 Web 界面 |
| 首次索引与模型下载耗时 | — |
| 语义搜索仍是 beta | — |
| 大目录会占内存与磁盘 | — |
| Windows 安装包可能触发 SmartScreen | — |

> 以上基于官方文档与社区反馈整理（2026-11-02），以官方最新文档为准。

## 官方安装方式（可手动执行）

```bash
curl -fL -O https://github.com/yjid/kensaku/releases/download/v1.0.11/kensaku_1.0.11_amd64.AppImage
chmod +x kensaku_1.0.11_amd64.AppImage
./kensaku_1.0.11_amd64.AppImage
echo "首次运行：先选要索引的目录"
```

安装包来源：[https://github.com/yjid/kensaku#install](https://github.com/yjid/kensaku#install)

## 验证状态

| 场景 | 状态 |
|---|---|
| README 确认安装包清单、托盘行为与 MCP 接入方式 | 已核对 2026-11-02 |
| Release v1.0.11 的 SHA256SUMS 已下载，Windows 安装包校验值已核对 | 已核对 2026-11-02 |
| 未实测安装、索引与 OCR | 说明 2026-11-02 |
| MCP 冒烟：initialize / tools/list 返回 get_guide、search_guide、get_project_info | 已验证 2026-11-02 |
| 非目标宿主调用 get_guide 被拦截（HOST_NOT_ALLOWED） | 已验证 2026-11-02 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

通过 `kensaku-cli mcp` 以 stdio 方式提供只读搜索能力，可接入 Claude Code、Cursor 等客户端；本仓库的 MCP 只提供安装步骤与常见问题。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-11-02）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\kensaku-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 安装包对照

| 平台 | 文件 |
|---|---|
| Windows | `kensaku_1.0.11_x64-setup.exe` 或 `.msi` |
| macOS | `kensaku_1.0.11_universal.dmg` |
| Linux | `kensaku_1.0.11_amd64.AppImage` 或 `.deb` |
| 命令行 | `kensaku-cli-windows-x86_64.exe` 等 |

## 接 agent

在 MCP 客户端配置里指向 CLI：

```json
{
  "mcpServers": {
    "kensaku": { "command": "kensaku-cli", "args": ["mcp"] }
  }
}
```

Windows 上建议写 `kensaku-cli.exe` 的绝对路径，改完重启客户端。

## 首次使用

1. 选索引目录与排除项
2. 等首轮扫描跑完（期间也能搜）
3. 需要搜图片文字时，再下载 OCR 包
4. 需要按描述找文件时，再下载语义模型

## 注意

- 索引常驻内存，目录越大占用越高，建议排除构建产物与缓存
- OCR 与语义模型包按需下载，离线环境要提前准备
- 语义搜索仍是 beta，结果只作参考
- MCP 是只读的，agent 不能改你的文件
- MIT，可自用可二开

## 常见坑

- 首次搜索很慢：等首轮索引完成，或先缩小索引范围
- 图片搜不到文字：OCR 包还没下载，去设置里装
- agent 调不到：MCP 命令用 `kensaku-cli` 的绝对路径，注册后重启客户端
- 内存占用高：排除 `node_modules`、构建目录与缓存
- 文件搜不到：确认目录在索引范围内，移动文件后等增量扫描
- Windows 被 SmartScreen 拦：核对 SHA256 后选择仍要运行
- 语义结果不准：该功能仍是 beta，优先用关键词

## 免责声明

本仓库为第三方指南，与 Kensaku 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-11-02），项目迭代快，请以[官方文档](https://github.com/yjid/kensaku#install)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
