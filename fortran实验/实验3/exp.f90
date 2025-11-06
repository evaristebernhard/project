! ------------------------------------------------------------
! 实验3 — 指数函数 e^x 的泰勒级数展开示例
! 说明：通过累加泰勒级数各项计算 e^x，直到项小于阈值或达到最大项数。
!
! 编译：
!   gfortran exp.f90 -o exp
!   ./exp
! ------------------------------------------------------------
PROGRAM exp_easiest
      implicit none
      
      REAL x, expx, term, eps, std_exp
      INTEGER n, nmax, iter_count

      WRITE(*,*) "================================================"
      WRITE(*,*) "  实验三：循环结构实验 (最简单输出)"
      WRITE(*,*) "================================================"

! --- 模型 (1): x=0.8, Nmax = 5 ---
      WRITE(*,*) "----------------------------------------"
      x = 0.8
      nmax = 5
      WRITE(*,*) "  测试模型: x = ", x, ", Nmax = ", nmax

      eps = 1.0E-7  
      n = 0         
      term = 1.0  
      expx = 1.0  
      iter_count = 0

      n = 1
      term = term * x / n 

      DO WHILE (ABS(term) > eps .AND. n <= nmax)
          iter_count = iter_count + 1
          expx = expx + term
          
          n = n + 1
          term = term * x / n  
      END DO

      std_exp = EXP(x) 
      WRITE(*,*) "  (1) 计算值 Expx   = ", expx
      WRITE(*,*) "  (2) 标准值 EXP(x) = ", std_exp
      WRITE(*,*) "  (3) 循环迭代次数  = ", iter_count

! --- 模型 (2): x = -0.8, Nmax = 10 ---
      WRITE(*,*) "----------------------------------------"
      x = -0.8
      nmax = 10
      WRITE(*,*) "  测试模型: x = ", x, ", Nmax = ", nmax
      
      eps = 1.0E-7
      n = 0
      term = 1.0
      expx = 1.0
      iter_count = 0

      n = 1
      term = term * x / n

      DO WHILE (ABS(term) > eps .AND. n <= nmax)
          iter_count = iter_count + 1
          expx = expx + term
          
          n = n + 1
          term = term * x / n
      END DO

      std_exp = EXP(x)
      WRITE(*,*) "  (1) 计算值 Expx   = ", expx
      WRITE(*,*) "  (2) 标准值 EXP(x) = ", std_exp
      WRITE(*,*) "  (3) 循环迭代次数  = ", iter_count

! --- 模型 (3): x = 50.0, Nmax = 100 ---
      WRITE(*,*) "----------------------------------------"
      x = 50.0
      nmax = 100
      WRITE(*,*) "  测试模型: x = ", x, ", Nmax = ", nmax
      
      eps = 1.0E-7
      n = 0
      term = 1.0
      expx = 1.0
      iter_count = 0

      n = 1
      term = term * x / n

      DO WHILE (ABS(term) > eps .AND. n <= nmax)
          iter_count = iter_count + 1
          expx = expx + term
          
          n = n + 1
          term = term * x / n
      END DO

      std_exp = EXP(x)
      WRITE(*,*) "  (1) 计算值 Expx   = ", expx
      WRITE(*,*) "  (2) 标准值 EXP(x) = ", std_exp
      WRITE(*,*) "  (3) 循环迭代次数  = ", iter_count

      WRITE(*,*) "================================================"

      END PROGRAM exp_easiest