# Grading Simulator 3D (Godot 4)

一个节奏爽快的 3D 批作业模拟器。WASD 移动，鼠标环视，J/K 判定学生答案（正确/错误），E 切换下一张试卷。计时结束显示最终分数。

## 打开与运行

1. 安装 Godot 4 (推荐 4.2+)
2. 在 Godot 启动器中“导入/打开”，指向本目录（包含 `project.godot`）
3. 运行项目（F5）

## 操作

- 移动: W A S D 或 方向键
- 观察: 鼠标移动
- 交互: E / 空格（切换下一张试卷）
- 判定正确: J
- 判定错误: K
- 释放鼠标: Esc

## 结构

- `scenes/Main.tscn`: 主场景，实例化教室、玩家、UI、试卷，挂载 `GameManager.gd`
- `scenes/Classroom.tscn`: 简易教室/桌子/光照
- `scenes/Player.tscn`: 角色控制器 + 摄像机
- `scenes/UI.tscn`: 计分/计时/题面/反馈 HUD
- `scenes/Paper.tscn`: 桌面上的试卷模型
- `scripts/GameManager.gd`: 题目生成、计分、计时、反馈
- `scripts/PlayerController.gd`: 第一人称移动与视角
- `scripts/InputSetup.gd`: 运行时确保输入映射存在（自动载入）

## 自定义

- 在 `scripts/GameManager.gd` 中调整 `session_duration_seconds`、分值规则与题目生成
- 可在 `scenes/Classroom.tscn` 美化环境，或添加更丰富的道具与机关
