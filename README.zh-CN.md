# MATLAB CST Simulation Skill

本 skill 用于辅助 Codex 或其他 AI agent 从论文中提取 CST 建模与仿真所需参数，生成可追溯的建模步骤，并通过 MATLAB 自动控制 CST Studio Suite 完成模型搭建、仿真设置与结果导出。仿真运行前会先征得用户确认。

![MATLAB CST Simulation Skill workflow](assets/workflow.svg)

## 可以做什么

- 读取论文或补充材料，并先询问用户要复现哪个图、表、模型或仿真结果。
- 整理几何尺寸、材料参数、边界条件、激励方式、频率范围、监视器和求解器设置。
- 生成详细的 CST 建模步骤文件，标注参数来源、缺失信息和必要假设。
- 使用 MATLAB 通过 COM/ActiveX 与 CST VBA history 命令创建或修改 `.cst` 工程。
- 在建模和仿真设置完成后，先询问用户是否运行仿真。
- 导出 S 参数、场分布、远场、图片、日志或其他结果文件。

## 基本流程

```text
装载 skill
放入论文
询问要复现的图或模型
提取建模参数
生成建模步骤文件
询问缺失关键参数
确认建模步骤
用 MATLAB 控制 CST 建模
询问是否运行仿真
导出并检查结果
```

## 安装

将仓库中的 `matlab-cst-simulation/` 文件夹复制到本机 Codex skills 目录：

```powershell
git clone https://github.com/xixiheni/matlab-cst-simulation-skill.git
Copy-Item -Path .\matlab-cst-simulation-skill\matlab-cst-simulation `
  -Destination "$env:USERPROFILE\.codex\skills\matlab-cst-simulation" `
  -Recurse -Force
```

## 使用示例

```text
Use $matlab-cst-simulation to read this paper, ask me which figure or model I want to reproduce, extract the CST modeling parameters, write a reproduction plan, and then build the CST model after I confirm the plan.
```

```text
Use $matlab-cst-simulation to create a MATLAB script that builds a CST antenna model, sets ports and monitors, prepares a run script, and asks me before starting the solver.
```

## 注意事项

该 skill 不包含 MATLAB、CST Studio Suite 或 CST 官方文档。实际运行效果取决于本机安装的 MATLAB/CST 版本、COM 注册状态、求解器模块和许可证权限。
