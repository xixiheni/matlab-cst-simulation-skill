# MATLAB CST Simulation Skill

[![Skill](https://img.shields.io/badge/Codex%20Skill-matlab--cst--simulation-blue)](matlab-cst-simulation/SKILL.md)
[![MATLAB](https://img.shields.io/badge/MATLAB-CST%20Automation-orange)](matlab-cst-simulation/examples)
[![Platform](https://img.shields.io/badge/platform-Windows%20COM-lightgrey)](matlab-cst-simulation/references/environment-and-execution.md)

本 skill 用于辅助 Codex 或其他 AI agent 从论文中提取 CST 建模与仿真所需参数，生成可追溯的建模步骤，并通过 MATLAB 自动控制 CST Studio Suite 完成模型搭建、仿真设置与结果导出。只有在用户明确要求完整仿真复现，或单独确认运行后，才会启动 CST 求解器。

![MATLAB CST Simulation Skill workflow](assets/workflow.svg)

## 可以做什么

- 读取论文或补充材料，并在用户未指定目标时先询问要复现哪个图、表、模型或仿真结果。
- 判断目标结果对应的论文模型版本，避免混用 initial、optimized、fabricated、measured 等不同参数。
- 整理几何尺寸、材料参数、边界条件、激励方式、频率范围、监视器、求解器和结果定义。
- 生成详细的 CST 建模步骤文件，标注参数来源、状态、缺失信息和必要假设。
- 使用 MATLAB 通过 COM/ActiveX 与 CST VBA history 命令创建或修改 `.cst` 工程。
- 在建模完成后检查 CST 模型，再根据用户请求决定是否运行仿真。
- 导出 S 参数、场分布、远场、图片、日志或其他结果文件。
- 对仿真结果和论文目标结果做特征级对比，例如谐振点、带宽、趋势、波束方向或场分布。

## 基本流程

```text
装载 skill
放入论文
确认要复现的图、表、模型或结果
检查 MATLAB-CST 环境
确定目标对应的论文模型版本
提取建模和仿真参数
集中询问关键缺失参数
生成建模步骤文件
用 MATLAB 控制 CST 建模
检查 CST 实际模型
按用户请求运行仿真
导出结果并与论文目标对比
```

## 示例 CST 模型

![Example CST model generated or inspected through MATLAB automation](assets/example.png)

## 安装

下面这段命令需要在 **Windows PowerShell** 中运行，不是在 GitHub 网页中运行。

操作方式：

1. 在 Windows 中打开 **PowerShell**。
2. 复制下面整段命令。
3. 粘贴到 PowerShell 窗口中并按回车。

命令会先下载本仓库，然后把 `matlab-cst-simulation/` 文件夹复制到当前用户的 Codex skills 目录中：

```powershell
git clone https://github.com/xixiheni/matlab-cst-simulation-skill.git
Copy-Item -Path .\matlab-cst-simulation-skill\matlab-cst-simulation `
  -Destination "$env:USERPROFILE\.codex\skills\matlab-cst-simulation" `
  -Recurse -Force
```

运行完成后，skill 会被安装到：

```text
C:\Users\你的用户名\.codex\skills\matlab-cst-simulation
```

## 使用示例

从论文开始复现：

```text
使用 $matlab-cst-simulation 读取这篇论文，先确认我要复现哪个图或模型，再提取 CST 建模参数，生成复现建模方案，并在方案明确后建立 CST 模型。
```

创建一个新的 CST 模型：

```text
使用 $matlab-cst-simulation 创建一个 MATLAB 脚本，用于建立 CST 天线模型、设置端口和监视器、准备仿真运行脚本，并在需要启动求解器时按我的请求执行。
```

修改已有 CST 工程：

```text
使用 $matlab-cst-simulation 打开这个已有 .cst 工程，修改两个参数，准备参数扫描，并导出 Touchstone 结果文件。
```

## 仓库结构

```text
assets/
  workflow.svg
  workflow.png
  example.png
matlab-cst-simulation/
  SKILL.md
  agents/
    openai.yaml
  references/
    environment-and-execution.md
    geometry-vba-patterns.md
    parameter-extraction-template.md
    paper-to-model-workflow.md
    simulation-setup.md
    tcstinterface.md
    version-compatibility.md
    validation.md
  scripts/
    check-cst-project.ps1
    parse-cst-log.ps1
    probe-matlab-cst.ps1
  examples/
    build-basic-plane-wave-project.m
    run-existing-project.m
```

## 运行要求

- Windows
- MATLAB
- CST Studio Suite
- 已注册 CST COM/ActiveX 自动化接口
- 有效的 CST license

该 skill 可以在非 Windows 系统上辅助生成 MATLAB/CST 脚本，但真正通过 COM 自动控制 CST 通常需要 Windows 环境。

## 版本兼容策略

本 skill 不承诺适配所有 MATLAB 和 CST 版本，而是采用更稳妥的版本自适应策略：

- 优先探测 MATLAB、CST、COM/ActiveX、工程创建/保存和 Solver 访问能力。
- 公共示例中尽量使用兼容性更好的 MATLAB 写法。
- 优先使用 CST `AddToHistory` VBA 命令块，使生成的 CST 工程更容易检查和复现。
- 明确报告检测到的版本、假设、失败命令和 fallback 方案。

环境探测脚本：

```powershell
powershell -ExecutionPolicy Bypass -File .\matlab-cst-simulation\scripts\probe-matlab-cst.ps1
```

## 注意事项

该 skill 不包含 MATLAB、CST Studio Suite、CST 官方文档或第三方 MATLAB-CST 接口库。实际运行效果取决于本机安装的 MATLAB/CST 版本、COM 注册状态、求解器模块和许可证权限。

如果使用外部项目，例如 `CSTMWS-Matlab-Interface`，请遵守其上游许可证。

## 建议 GitHub Topics

```text
codex-skill
agent-skill
matlab
cst-studio-suite
cst-microwave-studio
matlab-cst
simulation
electromagnetic-simulation
matlab-automation
activex
com-automation
antenna-simulation
microwave-engineering
paper-reproduction
```
