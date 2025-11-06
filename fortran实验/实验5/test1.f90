Program test1
    implicit none
    ! ------------------------------------------------------------
    ! 实验5 — 数据裁剪（通过 cmd.par 指定文件和范围）
    ! 说明：程序从 cmd.par 读取原始文件名、裁剪后文件名、X范围和Y范围，
    ! 并把满足范围的点写入输出文件。
    ! ------------------------------------------------------------
    Real,allocatable:: X(:),Y(:),Data1(:)
    Character*80 flie_par,flie_origin,flie_cjdat,str
    Integer record1,record2,i
    Real Xmin,Xmax,Ymin,Ymax,X1,Y1,H
    record1=0;record2=0
    
    flie_par='cmd.par'
    Open(unit=10,file=flie_par,status="old")
    Read(10,*)str,flie_origin
    Read(10,*)str,flie_cjdat
    Read(10,*)str,Xmin,Xmax
    Read(10,*)str,Ymin,Ymax
    Write(*,*)str,flie_origin
    Write(*,*)str,flie_cjdat
    Write(*,*)str,Xmin,Xmax
    Write(*,*)str,Ymin,Ymax
    Close(10)
    
        Open(unit=20,file=flie_origin,status="old")
        record1 = 0
    10  continue
        Read(20,*,end=20) X1, Y1, H
        record1 = record1 + 1
        goto 10
    20  continue
    Write(*,*)'record1=',record1
    Close(20)
    Allocate(X(record1),Y(record1),Data1(record1))
    
    Open(unit=30,file=flie_origin,status="old")
    i=1
    Do While(i<=record1)
        Read(30,*)X1,Y1,H
        X(i)=X1;Y(i)=Y1;Data1(i)=H
        i=i+1
    ENDDO
    Open(unit=40,file=flie_cjdat,status="unknown")
    i=1
    Do While(i<=record1)
        IF( (X(i)<=Xmax).AND.(X(i)>=Xmin).AND.(Y(i)<=Ymax).AND.(Y(i)>=Ymin) )then
            X1=X(i);Y1=Y(i);H=Data1(i)
            Write(40,*)X1,Y1,H
            record2=record2+1
        EndIF
        i=i+1
    EndDo
    Deallocate(X,Y,Data1)
    close(30)
    close(40)
    
    Write(*,*)"record2=",record2
    
END Program