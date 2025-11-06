! ------------------------------------------------------------
! 实验8 — 网格数据处理（增加行区间高度值并输出新的网格文件）
PROGRAM test8  ! 程序入口：网格数据处理（为指定行区间增加高度并输出新网格）
    implicit none  ! 禁用隐式类型
    Character*80 cmd_file,input_file,output_file  ! cmd 参数文件与输入/输出文件名
    Real,allocatable::input(:,:),output(:,:)  ! 输入与输出二维数组
    Integer line1,line2,point_x,line_y  ! 行区间与网格尺寸
    Real step,Xmin,Xmax,Ymin,Ymax,Zmin1,Zmax  ! 增量与坐标范围及 Z 的最小/最大值
    
    cmd_file="cmd.par"  ! 参数文件名
    Call Read_cmdfile(cmd_file,input_file,output_file,line1,line2,step)  ! 读取参数
    
    Call Read_inputfile_head(input_file,point_x,line_y,Xmin,Xmax,Ymin,Ymax)  ! 读取输入文件头信息
    
    Allocate(input(point_x,line_y),output(point_x,line_y))  ! 分配输入/输出数组
    Call output_dxy(point_x,line_y,Xmin,Xmax,Ymin,Ymax)  ! 计算并输出 dx, dy
    
    Call Read_inputfile_data(input_file,input,point_x,line_y)  ! 读取网格数据到 input
    
    Call Add_step(input,output,point_x,line_y,line1,line2,step)  ! 在指定行区间增加 step
    
    Call find_maxmin(output,point_x,line_y,Zmin1,Zmax)  ! 查找更改后 Z 的最小/最大值
    
    Call Write_outputfile(output_file,output,point_x,line_y,Xmin,Xmax,Ymin,Ymax,Zmin1,Zmax)  ! 写出新的网格文件
    Deallocate(input,output)  ! 释放数组
    
END PROGRAM  ! 程序结束
    
Subroutine Read_cmdfile(cmd_file,input_file,output_file,line1,line2,step)  ! 读取 cmd 参数文件
    implicit none
    Character*80 cmd_file,input_file,output_file,str,str1  ! 参数字符串
    Integer line1,line2  ! 行区间
    Real step  ! 增加的步长
    
    Open(20,file=cmd_file,status="old")  ! 打开 cmd 参数文件
    read(20,*)str  ! 读取并忽略可能的注释或标签
    read(20,*)str
    read(20,*)str
    read(20,*)str
    read(20,*)str,input_file  ! 读取输入文件名
    write(*,*)str,input_file  ! 打印确认
    read(20,*)str,line1,line2  ! 读取行区间
    write(*,*)str,line1,line2  ! 打印确认
    read(20,*)str,step  ! 读取 step
    write(*,*)str,step  ! 打印确认
    read(20,*)str,output_file  ! 读取输出文件名
    write(*,*)str,output_file  ! 打印确认
    close(20)  ! 关闭 cmd 文件
    End Subroutine  ! 子程序结束
    
Subroutine Read_inputfile_head(input_file,point_x,line_y,Xmin,Xmax,Ymin,Ymax)  ! 读取输入文件头信息
    implicit none
    Character*80 input_file,str  ! 输入文件名与临时字符串
    Integer point_x,line_y  ! 网格尺寸
    Real Xmin,Xmax,Ymin,Ymax  ! 坐标范围
    
    open(30,file=input_file,status="old")  ! 打开输入文件
    read(30,*)str  ! 读取并忽略首行注释
    read(30,*)point_x,line_y  ! 读取网格点数（x方向）与行数（y方向）
    read(30,*)Xmin,Xmax  ! 读取 X 范围
    read(30,*)Ymin,Ymax  ! 读取 Y 范围
    write(*,*)"文件大小：",point_x,line_y  ! 打印网格大小
    write(*,*)"X范围：",Xmin,Xmax  ! 打印 X 范围
    write(*,*)"Y范围：",Ymin,Ymax  ! 打印 Y 范围
    close(30)  ! 关闭输入文件
End Subroutine  ! 子程序结束
    
Subroutine output_dxy(point_x,line_y,Xmin,Xmax,Ymin,Ymax)  ! 计算 dx, dy 并输出
    implicit none
    Integer point_x,line_y  ! 网格尺寸
    Real Xmin,Xmax,Ymin,Ymax,dx,dy  ! 坐标范围与步距
    
    dx=(Xmax-Xmin)/(point_x-1)  ! 计算点距 dx
    dy=(Ymax-Ymin)/(line_y-1)  ! 计算点距 dy
    write(*,*)"点距dx，dy为：",dx,dy  ! 打印 dx, dy
End Subroutine  ! 子程序结束
    
Subroutine Read_inputfile_data(input_file,input,point_x,line_y)  ! 读取网格数据到二维数组
    implicit none
    Character*(*) input_file  ! 文件名（可变长度）
    Integer point_x,line_y,i,j  ! 网格尺寸与索引
    Real input(point_x,line_y)  ! 输入数组
    
    open(40,file=input_file,status="old")  ! 打开输入文件
    read(40,*)  ! 读取并忽略头部行（多行格式依赖原文件）
    read(40,*)
    read(40,*)
    read(40,*)
    read(40,*)
    read(40,*) ((input(i,j),i=1,point_x),j=1,line_y)  ! 使用数组语句读取所有网格点数据
!    write(*,*) ((input(i,j),i=1,point_x),j=1,line_y)  ! 可选打印数据，原为注释
    close(40)  ! 关闭输入文件
    End Subroutine  ! 子程序结束
    
Subroutine Add_step(input,output,point_x,line_y,line1,line2,step)  ! 在指定行区间对 Z 加上 step
    implicit none
    Integer line1,line2,point_x,line_y,x,y  ! 行区间、网格尺寸与循环索引
    Real step  ! 增加量
    Real input(point_x,line_y),output(point_x,line_y)  ! 输入和输出数组
    
    do y=1,line_y  ! 遍历每一行
        do x=1,point_x  ! 遍历每一列
            if( (y>=line1).and.(y<=line2) )then  ! 如果行索引在指定区间内
                output(x,y)=input(x,y)+step  ! 对该点加上 step
            else
                output(x,y)=input(x,y)  ! 否则保持不变
            endif
        end do
    end do
!    write(*,*) ((output(i,j),i=1,point_x),j=1,line_y)  ! 可选打印输出网格，原为注释
    end Subroutine  ! 子程序结束

Subroutine find_maxmin(output,point_x,line_y,Zmin1,Zmax)  ! 查找输出数组的最小和最大值
    implicit none
    Integer point_x,line_y,x,y  ! 网格尺寸与索引
    Real Zmin1,Zmax  ! 返回的最小值与最大值
    Real output(point_x,line_y)  ! 输出数组
    
    Zmin1=output(2,1)  ! 初始化最小值（选择一个有效位置作为初值）
    Zmax=output(1,1)  ! 初始化最大值
    do x=1,point_x  ! 遍历所有点以寻找 min/max
        do y=1,line_y
            if(output(x,y)<Zmin1)then
                Zmin1=output(x,y)  ! 更新最小值
            endif
            
            if(Zmax<output(x,y))then
                Zmax=output(x,y)  ! 更新最大值
            endif
            
        end do
    end do
    write(*,*)"更改后Z的范围:",Zmin1,"~",Zmax  ! 打印范围
    end Subroutine  ! 子程序结束
    
Subroutine Write_outputfile(output_file,output,point_x,line_y,Xmin,Xmax,Ymin,Ymax,Zmin1,Zmax)  ! 写出 DSAA 格式文件
    implicit none
    Character*(*) output_file  ! 输出文件名
    Integer point_x,line_y,i,j  ! 网格尺寸与索引
    Real Xmin,Xmax,Ymin,Ymax,Zmin1,Zmax  ! 范围信息
    Real output(point_x,line_y)  ! 输出数组
    
    open(40,file=output_file,status="unknown")  ! 打开输出文件
    Write(40,*)"DSAA"  ! 写入 DSAA 标识
    Write(40,*)point_x,line_y  ! 写入网格尺寸
    Write(40,*)Xmin,Xmax  ! 写入 X 范围
    Write(40,*)Ymin,Ymax  ! 写入 Y 范围
    Write(40,*)Zmin1,Zmax  ! 写入 Z 范围
    do j=1,line_y  ! 写入每一行的数据
        Write(40,*)(output(i,j),i=1,point_x)  ! 按行写入点值
    end do
    close(40)  ! 关闭输出文件
End Subroutine  ! 子程序结束
    end do
    close(40)
End Subroutine