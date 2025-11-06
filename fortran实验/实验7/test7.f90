! ------------------------------------------------------------
! 实验7 — 矩阵乘法示例
! 说明：程序读取 A、B 两个矩阵（文件名由 cmd.par 指定），计算 C = A * B，
! 并把结果写入指定输出文件。
! 文件格式：矩阵文件第一行应为 "m,n"（行数, 列数），随后是 m 行每行 n 个数。
! ------------------------------------------------------------
Program test7
    implicit none
    character*80 cmdfile,A_file,B_file,C_file
    integer A_m,A_n,B_m,B_n
    real,allocatable::A(:,:),B(:,:),C(:,:)
    
    cmdfile="cmd.par"
    call read_par(cmdfile,A_file,B_file,C_file)
    call read_mn(A_file,A_m,A_n)
    call read_mn(B_file,B_m,B_n)
    
    allocate(A(A_m,A_n),B(B_m,B_n),C(A_m,B_n))
    call read_data(A_file,A,A_m,A_n)
    call read_data(B_file,B,B_m,B_n)
    if(A_n==B_m)then
        call mul(A,B,C,A_m,A_n,B_n)
        call output(C,A_m,B_n,C_file)
    else
        write(*,*)"矩阵格式不对，请重新输入"
    endif
    deallocate(A,B,C)
    
end Program
    
Subroutine read_par(cmdfile,A_file,B_file,C_file)
    implicit none
    character*80 cmdfile,A_file,B_file,C_file,str
    
    open(20,file=cmdfile,status="old")
    read(20,*)str,A_file
    read(20,*)str,B_file
    read(20,*)str,C_file
    write(20,*)"文件名：",A_file,B_file,C_file
    close(20)
    end Subroutine
    
Subroutine read_mn(file_name,m,n)
    implicit none
    integer m,n
    character*80 file_name
    
    open(30,file=file_name,status="old")
    read(30,*)m,n
    close(30)
end Subroutine
    
Subroutine read_data(file_name,ABC,m,n)
    implicit none
    character*80 file_name
    integer m,n
    Real ABC(m,n),r1,r2
    integer i,j
    
    open(40,file=file_name,status="old")
    read(40,*)r1,r2
    i=1;j=1
    do while(i<=m)
        read(40,*)(ABC(i,j),j=1,n)
        i=i+1
    end do
    close(40)
end subroutine
    
Subroutine mul(A,B,C,A_m,A_n,B_n)
    implicit none
    integer A_m,A_n,B_n,i,j
    integer r
    real A(A_m,A_n),B(A_n,B_n),C(A_m,B_n)
    
    do j=1,B_n
        do i=1,A_m
            C(i,j)=0.0
            do r=1,A_n
                C(i,j)=C(i,j)+A(i,r)*B(r,j)
            end do
        end do
    end do
end Subroutine
    
Subroutine output(A,A_m,A_n,A_file)
    implicit none
    character*80 A_file
    integer A_m,A_n,i
    integer j
    Real A(A_m,A_n)
    
    open(50,file=A_file,status="unknown")
    do i=1,A_m
        write(50,*)(A(i,j),j=1,A_n)
    end do
    close(50)
    
    write(*,*)"矩阵相乘结果为："
    do i=1,A_m
        write(*,*)(A(i,j),j=1,A_n)
    end do
end Subroutine