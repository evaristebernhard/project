# 实验·1 — area

说明
- 程序 `area.f90` 用 Fortran 计算一个五边形的面积。它把五边形分成 3 个三角形，分别调用内部子程序 `calc_area` 计算三角形面积后求和。

主要结构与语法要点（面向大一初学者）
- `program ... end program`：程序入口。
- `implicit none`：关闭隐式类型，推荐在所有程序中使用（能避免拼写或类型错误）。
- `CONTAINS`：允许在主程序内部定义子例程（subroutine）。
- `subroutine calc_area(...)`：计算三角形面积（使用海伦公式），并通过 `intent(in)`/`intent(out)` 指定参数输入/输出方向。
- `read` / `print`：用于输入输出。

如何编译与运行
```bash
cd fortran实验/实验·1
gfortran area.f90 -o area
./area
```

注意与常见问题
- `calc_area` 中要注意传入变量名和子程序内使用的变量名是否一致（若启用 `implicit none`，编译器会帮助你发现未声明的变量）。
- 输入时程序会提示：按顺序输入 a b c d e m n（对角线 m,n），用空格或回车分隔。
