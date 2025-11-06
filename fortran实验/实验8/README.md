# 实验8 — 网格数据处理 (test8)

说明
- `test8.f90` 是一个对网格/格点数据进行处理的程序：从 `cmd.par` 读取参数（输入文件、要修改的行范围、步长、输出文件等），计算点距（dx, dy），在指定行范围内把高度值 `H` 增加一个步长 `step`，然后写出新的网格文件（例如 `output.grd`）。

工作流程
1. 读取 `cmd.par`（程序按行读取多个标签与参数，例子里 `inputfile: Bxyzl.grd`，`line1,line2: 5,10`，`step 1.5`，`outputfile: output.grd`）。
2. 读取输入网格头信息（点数、范围），计算 `dx=(Xmax-Xmin)/(point_x-1)`、`dy=(Ymax-Ymin)/(line_y-1)` 并打印。
3. 读入网格数据到二维数组 `input(point_x,line_y)`。
4. 对指定行区间 `line1..line2`（索引以 1 起）把高度加上 `step`。
5. 计算修改后的最小/最大值并写到输出文件（格式为 `DSAA` 风格的网格头 + 数据）。

如何编译与运行
```bash
cd fortran实验/实验8
gfortran test8.f90 -o test8
./test8
```

关于输出文件
- 程序会把结果写入 `output.grd`（或你在 `cmd.par` 指定的文件）。示例输出已生成为 `output.grd`，可以用文本查看或用支持 `DSAA` 网格的可视化软件打开。

初学者注意事项
- 循环变量（x,y,i,j）应声明为 `integer`，否则编译器会给出 “Legacy Extension” 警告或行为不确定。
- 程序使用多行 `read(30,*)` 来跳过头部，确保你的输入文件格式与程序读取的行数一致。
