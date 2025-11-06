! ------------------------------------------------------------
! 实验8 — 网格数据处理（增加行区间高度值并输出新的网格文件）
! 说明：从 cmd.par 读取 inputfile、line1,line2、step、outputfile，
! 读入网格数据，对指定行区间加上 step，然后写出新网格（DSAA 格式）。
! ------------------------------------------------------------
PROGRAM test8
    implicit none
    Character*80 cmd_file,input_file,output_file
    Real,allocatable::input(:,:),output(:,:)
    Integer line1,line2,point_x,line_y
    Real step,Xmin,Xmax,Ymin,Ymax,Zmin1,Zmax
    
    cmd_file="cmd.par"
    Call Read_cmdfile(cmd_file,input_file,output_file,line1,line2,step)
    
    Call Read_inputfile_head(input_file,point_x,line_y,Xmin,Xmax,Ymin,Ymax)
    
    Allocate(input(point_x,line_y),output(point_x,line_y))
    Call output_dxy(point_x,line_y,Xmin,Xmax,Ymin,Ymax)
    
    Call Read_inputfile_data(input_file,input,point_x,line_y)
    
    Call Add_step(input,output,point_x,line_y,line1,line2,step)
    
    Call find_maxmin(output,point_x,line_y,Zmin1,Zmax)
    
    Call Write_outputfile(output_file,output,point_x,line_y,Xmin,Xmax,Ymin,Ymax,Zmin1,Zmax)
    Deallocate(input,output)
    
END PROGRAM
    
Subroutine Read_cmdfile(cmd_file,input_file,output_file,line1,line2,step)
    implicit none
    Character*80 cmd_file,input_file,output_file,str,str1
    Integer line1,line2
    Real step
    
    Open(20,file=cmd_file,status="old")
    read(20,*)str
    read(20,*)str
    read(20,*)str
    read(20,*)str
    read(20,*)str,input_file
    write(*,*)str,input_file
    read(20,*)str,line1,line2
    write(*,*)str,line1,line2
    read(20,*)str,step
    write(*,*)str,step
    read(20,*)str,output_file
    write(*,*)str,output_file
    close(20)
    End Subroutine
    
Subroutine Read_inputfile_head(input_file,point_x,line_y,Xmin,Xmax,Ymin,Ymax)
    implicit none
    Character*80 input_file,str
    Integer point_x,line_y
    Real Xmin,Xmax,Ymin,Ymax
    
    open(30,file=input_file,status="old")
    read(30,*)str
    read(30,*)point_x,line_y
    read(30,*)Xmin,Xmax
    read(30,*)Ymin,Ymax
    write(*,*)"文件大小：",point_x,line_y
    write(*,*)"X范围：",Xmin,Xmax
    write(*,*)"Y范围：",Ymin,Ymax
    close(30)
End Subroutine
    
Subroutine output_dxy(point_x,line_y,Xmin,Xmax,Ymin,Ymax)
    implicit none
    Integer point_x,line_y
    Real Xmin,Xmax,Ymin,Ymax,dx,dy
    
    dx=(Xmax-Xmin)/(point_x-1)
    dy=(Ymax-Ymin)/(line_y-1)
    write(*,*)"点距dx，dy为：",dx,dy
End Subroutine
    
Subroutine Read_inputfile_data(input_file,input,point_x,line_y)
    implicit none
    Character*(*) input_file
    Integer point_x,line_y,i,j
    Real input(point_x,line_y)
    
    open(40,file=input_file,status="old")
    read(40,*)
    read(40,*)
    read(40,*)
    read(40,*)
    read(40,*)
    read(40,*) ((input(i,j),i=1,point_x),j=1,line_y)
!    write(*,*) ((input(i,j),i=1,point_x),j=1,line_y)
    close(40)
    End Subroutine
    
Subroutine Add_step(input,output,point_x,line_y,line1,line2,step)
    implicit none
    Integer line1,line2,point_x,line_y,x,y
    Real step
    Real input(point_x,line_y),output(point_x,line_y)
    
    do y=1,line_y
        do x=1,point_x
            if( (y>=line1).and.(y<=line2) )then
                output(x,y)=input(x,y)+step
            else
                output(x,y)=input(x,y)
            endif
        end do
    end do
!    write(*,*) ((output(i,j),i=1,point_x),j=1,line_y)
    end Subroutine

Subroutine find_maxmin(output,point_x,line_y,Zmin1,Zmax)
    implicit none
    Integer point_x,line_y,x,y
    Real Zmin1,Zmax
    Real output(point_x,line_y)
    
    Zmin1=output(2,1)
    Zmax=output(1,1)
    do x=1,point_x
        do y=1,line_y
            if(output(x,y)<Zmin1)then
                Zmin1=output(x,y)
            endif
            
            if(Zmax<output(x,y))then
                Zmax=output(x,y)
            endif
            
        end do
    end do
    write(*,*)"更改后Z的范围:",Zmin1,"~",Zmax
    end Subroutine
    
Subroutine Write_outputfile(output_file,output,point_x,line_y,Xmin,Xmax,Ymin,Ymax,Zmin1,Zmax)
    implicit none
    Character*(*) output_file
    Integer point_x,line_y,i,j
    Real Xmin,Xmax,Ymin,Ymax,Zmin1,Zmax
    Real output(point_x,line_y)
    
    open(40,file=output_file,status="unknown")
    Write(40,*)"DSAA"
    Write(40,*)point_x,line_y
    Write(40,*)Xmin,Xmax
    Write(40,*)Ymin,Ymax
    Write(40,*)Zmin1,Zmax
    do j=1,line_y
        Write(40,*)(output(i,j),i=1,point_x)
    end do
    close(40)
End Subroutine