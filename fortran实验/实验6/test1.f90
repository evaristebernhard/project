! ------------------------------------------------------------
! 实验6 — 与实验5类似的数据裁剪示例
! 说明：通过 cmd.par 指定输入/输出文件和裁剪范围，统计记录并筛选写入新文件。
! ------------------------------------------------------------
Program test1
    implicit none
    Character*80 file_par,file_origin,file_cjdat
    Integer record1,record2
    Real Xmin,Xmax,Ymin,Ymax,X1,Y1,H1
    record1=0;record2=0
    
    call readpar(file_par,file_origin,file_cjdat,Xmin,Xmax,Ymin,Ymax)
    
    call check(file_origin,record1)
    
    call output(file_origin,record1,file_cjdat,Xmax,Xmin,Ymax,Ymin)
    
END Program
    
Subroutine readpar(file_par,file_origin,file_cjdat,Xmin,Xmax,Ymin,Ymax)
    Character*80 file_par,file_origin,file_cjdat
    Real Xmin,Xmax,Ymin,Ymax
    Character*80 str

    file_par='cmd.par'
    Open(unit=10,file=file_par,status="old")
    Read(10,*)str,file_origin
    Read(10,*)str,file_cjdat
    Read(10,*)str,Xmin,Xmax
    Read(10,*)str,Ymin,Ymax
    Write(*,*)str,file_origin
    Write(*,*)str,file_cjdat
    Write(*,*)str,Xmin,Xmax
    Write(*,*)str,Ymin,Ymax
    Close(10)
End Subroutine
    
Subroutine check(file_origin,record1)
    Character*(*) file_origin
    Real X1,Y1,H1
    Integer record1
    Open(unit=20,file=file_origin,status="old")
    record1 = 0
10  continue
    read(20,*,end=20) X1, Y1, H1
    record1 = record1 + 1
    goto 10
20  continue
    Write(*,*)'record1=',record1
    Close(20)
    End Subroutine

Subroutine output(file_origin,record1,file_cjdat,Xmax,Xmin,Ymax,Ymin)
    Integer record2,i,record1
    Character*80 file_origin,file_cjdat
    Real X1,Y1,H1
    Real,allocatable:: X(:),Y(:),H(:)
    record2=0

    Allocate(X(record1),Y(record1),H(record1))
    Open(unit=30,file=file_origin,status="old")
    i=1
    Do While(i<=record1)
        Read(30,*)X1,Y1,H1
        X(i)=X1;Y(i)=Y1;H(i)=H1
        i=i+1
    ENDDO
    
!    file_cjdat='Bxyzl_cj.dat'
    Open(unit=50,file=file_cjdat,status="unknown")
    i=1
    Do While(i<=record1)
        IF( (X(i)<=Xmax).AND.(X(i)>=Xmin).AND.(Y(i)<=Ymax).AND.(Y(i)>=Ymin) )then
            X1=X(i);Y1=Y(i);H1=H(i)
            Write(40,*)X1,Y1,H1
            record2=record2+1
        EndIF
        i=i+1
    EndDo
    
    Deallocate(X,Y,H)
    close(50)
    close(30)
    Write(*,*)"record2=",record2
END Subroutine