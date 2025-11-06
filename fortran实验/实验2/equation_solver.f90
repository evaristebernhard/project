! ------------------------------------------------------------
! 实验2 — 一元二次方程求解器
! 说明：读取系数 A, B, C 并求解 Ax^2 + Bx + C = 0。程序会
! - 处理 A=0 的线性情况
! - 判别 Δ 的正负，分别处理两实根、重根和复根的情况
!
! 编译：
!   gfortran equation_solver.f90 -o solve
!   ./solve
! ------------------------------------------------------------
PROGRAM SolveQuadraticEquation
    IMPLICIT NONE

    ! Declare variables
    REAL :: A, B, C      ! Coefficients
    REAL :: delta        ! Discriminant (B^2 - 4AC)
    REAL :: x1, x2       ! Real roots
    REAL :: real_part, imag_part ! Parts of complex roots

    ! Prompt the user to enter the coefficients
    PRINT *, '请输入一元二次方程 Ax^2 + Bx + C = 0 的系数'
    PRINT *, '---------------------------------------------------'
    PRINT *, '请输入 A, B, C (用空格或回车分隔):'
    READ *, A, B, C

    PRINT *, ' ' ! Add a blank line for better readability
    PRINT *, '方程: (', A, ')x^2 + (', B, ')x + (', C, ') = 0'
    PRINT *, '---------------------------------------------------'
    PRINT *, '求解结果:'


    ! Check if A is zero (or very close to zero for floating point)
    ! If A = 0, the equation is linear: Bx + C = 0
    IF (ABS(A) < 1E-9) THEN
        ! Case 1: A = 0, B != 0 (Linear equation with one solution)
        IF (ABS(B) > 1E-9) THEN
            x1 = -C / B
            PRINT *, '这是一个线性方程 (A=0, B≠0)。'
            PRINT *, '方程只有一个解: x = ', x1
        ! A = 0 and B = 0
        ELSE
            ! Case 2: A = 0, B = 0, C = 0 (Infinite solutions)
            IF (ABS(C) < 1E-9) THEN
                PRINT *, '方程有无穷多个解 (A=0, B=0, C=0)。'
            ! Case 3: A = 0, B = 0, C != 0 (No solution)
            ELSE
                PRINT *, '方程无解 (A=0, B=0, C≠0)。'
            END IF
        END IF

    ! If A is not zero, it's a quadratic equation
    ELSE
        ! Calculate the discriminant
        delta = B**2 - 4.0 * A * C

        ! Case 4: Delta > 0 (Two distinct real roots)
        IF (delta > 0) THEN
            x1 = (-B + SQRT(delta)) / (2.0 * A)
            x2 = (-B - SQRT(delta)) / (2.0 * A)
            PRINT *, '方程有两个不同的实数根 (Δ > 0)。'
            PRINT *, '根 1: x1 = ', x1
            PRINT *, '根 2: x2 = ', x2
        ! Case 5: Delta = 0 (Two equal real roots)
        ELSE IF (ABS(delta) < 1E-9) THEN
            x1 = -B / (2.0 * A)
            PRINT *, '方程有两个相同的实数根 (Δ = 0)。'
            PRINT *, '解: x1 = x2 = ', x1
        ! Case 6: Delta < 0 (Two distinct complex roots)
        ELSE
            real_part = -B / (2.0 * A)
            imag_part = SQRT(-delta) / (2.0 * A)
            PRINT *, '方程有两个不同的复数根 (Δ < 0)。'
            PRINT *, '根 1: x1 = ', real_part, ' + ', imag_part, 'i'
            PRINT *, '根 2: x2 = ', real_part, ' - ', imag_part, 'i'
        END IF
    END IF

    PRINT *, '---------------------------------------------------'

END PROGRAM SolveQuadraticEquation