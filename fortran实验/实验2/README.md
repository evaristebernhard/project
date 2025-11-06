# 实验2 — 方程求解 (equation_solver)

说明
- `equation_solver.f90` 是一个求解一元二次方程 Ax^2 + Bx + C = 0 的程序。
- 程序会处理不同情况：A = 0 的线性情况；Δ>0、Δ=0、Δ<0（复根）的情况。

主要语法点（初学者友好）
- `IMPLICIT NONE`：推荐在所有代码中使用，强制声明变量类型。
- 条件判断：`IF ... THEN ... ELSE IF ... ELSE ... END IF`。
- 算术与函数：`**` 表示幂，`SQRT()` 取平方根，`ABS()` 取绝对值。

如何编译与运行
```bash
cd fortran实验/实验2
gfortran equation_solver.f90 -o solve
./solve
```

示例
- 输入 A B C，程序会输出解的类型（两个实根、重根、复根、线性方程或无解）。

小提示
- 对浮点数比较要小心，程序使用 `ABS(delta) < 1E-9` 作为判零的方法，这是一种常见做法。
