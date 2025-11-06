# 实验4 — 数据裁剪 (cropper_hardcoded_eof)

说明
- `cropper_hardcoded_eof.f90` 是一个把输入网格/点数据按范围裁剪并写入新文件的程序。源文件名、输出文件名和裁剪范围在程序顶部以参数的形式硬编码。

主要步骤
1. 打开输入文件并统计行数。
2. 为数据分配动态数组（`ALLOCATE`）。
3. 读取所有数据到内存中。
4. 根据 X/Y 范围筛选并把结果写到新文件。
5. 释放内存并报告结果。

语法与注意点（课堂风格）
- `ALLOCATE` / `DEALLOCATE`：用于动态分配数组大小。
- 文件读写：`OPEN(UNIT=10, FILE=..., IOSTAT=io_status)` + `READ(..., IOSTAT=io_status)` 的组合能兼容不同实现，比直接用 `EOF()` 更健壮。
- 带标签和 `GOTO` 的古典写法在一些作业中会遇到，但推荐用结构化循环。

如何编译与运行
```bash
cd fortran实验/实验4
gfortran cropper_hardcoded_eof.f90 -o cropper
./cropper
```

文件格式
- 输入文件格式通常为：每行三个实数（X Y H）。程序示例使用 `Bxyzl.dat`。
