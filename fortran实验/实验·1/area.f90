    ! ------------------------------------------------------------
    ! 实验·1 — 计算五边形面积（把五边形分成三个三角形）
    ! 说明：
    ! - 程序从标准输入读取 a,b,c,d,e,m,n（五边形的五条边和两条对角线），
    !   将五边形分为三个三角形并分别计算面积后求和。
    ! - 推荐在输入时按顺序输入 7 个实数，以空格或回车分隔。
    !
    ! 编译：
    !   gfortran area.f90 -o area
    !   ./area
    ! ------------------------------------------------------------
    program area

        implicit none

    ! Variables
    real::a,b,m,c,n,e,d;
    real::area1,area2,area3,area_toal;
    logical isvalid_1,isvalid_2,isvalid_3;
    

    ! Body of area
    print *, '请输入五边形边长,a,b,c,d,e.对角线m,n'
    read *,a,b,c,d,e,m,n
    Call calc_area(a,b,m,area1,isvalid_1);
    Call calc_area(m,c,n,area2,isvalid_2);
    Call calc_area(e,d,n,area3,isvalid_3);
    
    if(isvalid_1 .and. isvalid_2 .and. isvalid_3)then
        area_toal=area1+area2+area3;
        print *,'area_toal=',area_toal
    else 
        print *,'有问题'
    end if
        
    CONTAINS
    SUBROUTINE calc_area(s1,s2,s3,cal,isvalid)
     implicit none
     real,intent(in)::s1,s2,s3;
     real,intent(out)::cal;
     logical,intent(out)::isvalid;
     real::s;
     ! 检查三角形边长是否满足三角形不等式
     if(s1+s2>s3 .and. s1+s3>s2 .and. s2+s3>s1)then
         s=(s1+s2+s3)/2.0
         ! 海伦公式：面积 = sqrt( s*(s-s1)*(s-s2)*(s-s3) )
         ! 注意：这里必须用局部参数 s1,s2,s3，而不是主程序中的变量名
         cal = sqrt( s * (s - s1) * (s - s2) * (s - s3) )
         isvalid =.True.
     else 
         isvalid=.False.
         cal=0
     end if
   end SUBROUTINE calc_area     

    end program area