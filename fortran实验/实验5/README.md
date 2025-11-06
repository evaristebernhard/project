# 实验5 — 数据裁剪（可通过 cmd.par 配置）

说明
- `test1.f90` 在本实验中实现按给定范围裁剪点数据，并把符合条件的点写入新文件。程序通过 `cmd.par` 读取源文件名/输出文件名与范围。

程序流程（课堂风格）
1. 从 `cmd.par` 读取：原始数据文件名、输出文件名、Xmin/Xmax、Ymin/Ymax。
2. 第一次扫描文件统计记录数（用 `read(..., end=label)` 或 `EOF()` 判断文件结束）。
3. 分配数组并在第二次扫描中把数据读入内存。
4. 遍历数组并把满足范围的点写入输出文件。

注意与文件格式
- `cmd.par` 通常包含类似：
  ```
  A_file A.dat
  B_file B.dat
  C_file C.out
  ```
  （本程序按 `read(20,*) str, flie_origin` 这种格式读取 —— 每行第一个字段会被读到 `str` 并丢弃，第二个字段是文件名）
- 数据文件格式为每行 `X Y H`（空格或逗号分隔常被接受，取决于 `read(*,*)` 的解析）。

如何编译与运行
```bash
cd fortran实验/实验5
gfortran test1.f90 -o test1
./test1
```

课堂提示
- 如果你要严格按老师在课堂上展示的写法，可以使用 `READ(..., end=label)` 或 `DO WHILE (.NOT. EOF(unit))` 来统计行数；不过注意不同 Fortran 实现对 `EOF()` 的行为可能略有差别。
