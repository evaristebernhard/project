! =====================================================================
! 文件名: cropper_hardcoded_eof.f90
! 功能:   数据裁剪程序 (硬编码版)
!         使用 EOF() 函数判断文件结尾。
! =====================================================================
! ------------------------------------------------------------
! 实验4 — 数据裁剪程序（硬编码版，使用 EOF/IOSTAT）
! 说明：从输入文件读取 (x,y,h) 数据，按指定 X/Y 区间筛选并写入输出文件。
! 程序顶部使用参数硬编码输入/输出文件名与裁剪范围，初学者可直接修改这些参数练习。
!
! 编译：
!   gfortran cropper_hardcoded_eof.f90 -o cropper_hardcoded_eof
!   ./cropper_hardcoded_eof
! ------------------------------------------------------------
PROGRAM cropper_hardcoded_eof
    IMPLICIT NONE

    ! --- 1. 参数设置 (在这里修改) ---
    CHARACTER(LEN=80), PARAMETER :: INPUT_FILE  = "Bxyzl.dat"
    CHARACTER(LEN=80), PARAMETER :: OUTPUT_FILE = "Bxyzl_cj.dat"
    REAL, PARAMETER :: XMIN_VAL = -22.0
    REAL, PARAMETER :: XMAX_VAL = 10.0
    REAL, PARAMETER :: YMIN_VAL = -20.0
    REAL, PARAMETER :: YMAX_VAL = 18.0

    ! --- 2. 变量声明 ---
    REAL, ALLOCATABLE :: x(:), y(:), h(:)
    INTEGER :: num_lines, num_cropped, i
    REAL :: temp_x, temp_y, temp_h
    INTEGER :: io_status

    PRINT *, "--- Fortran 数据裁剪程序 (硬编码版, 使用EOF) ---"
    PRINT *, "输入文件:", INPUT_FILE
    PRINT *, "输出文件:", OUTPUT_FILE
    PRINT *, ""

    ! --- 3. 第一次扫描: 统计源文件行数 ---
    OPEN(UNIT=10, FILE=INPUT_FILE, STATUS='old', ACTION='read', IOSTAT=io_status)
    IF (io_status /= 0) THEN
        PRINT *, "错误: 无法打开输入文件 ", TRIM(INPUT_FILE)
        STOP
    END IF

    num_lines = 0
    ! 使用带 IOSTAT 的循环来统计行数，兼容性更好（避免对 EOF() 的实现依赖）
    io_status = 0
    DO
        READ(10, *, IOSTAT=io_status) temp_x, temp_y, temp_h
        IF (io_status /= 0) EXIT
        num_lines = num_lines + 1
    END DO
    PRINT *, "步骤 1: 文件扫描完毕, 总行数:", num_lines

    ! --- 4. 分配动态数组内存 ---
    ALLOCATE(x(num_lines), y(num_lines), h(num_lines))
    PRINT *, "步骤 2: 动态数组内存分配成功。"

    ! --- 5. 第二次扫描: 将数据读入数组 ---
    REWIND(10) ! 文件指针回到开头
    DO i = 1, num_lines
        READ(10, *) x(i), y(i), h(i)
    END DO
    CLOSE(10)
    PRINT *, "步骤 3: 数据已全部加载到内存。"

    ! --- 6. 在内存中筛选数据并写入新文件 ---
    OPEN(UNIT=20, FILE=OUTPUT_FILE, STATUS='unknown', ACTION='write')
    num_cropped = 0
    DO i = 1, num_lines
        IF (x(i) >= XMIN_VAL .AND. x(i) <= XMAX_VAL .AND. &
            y(i) >= YMIN_VAL .AND. y(i) <= YMAX_VAL) THEN
            WRITE(20, *) x(i), y(i), h(i)
            num_cropped = num_cropped + 1
        END IF
    END DO
    CLOSE(20)
    PRINT *, "步骤 4: 数据筛选完成, 结果已写入新文件。"

    ! --- 7. 释放内存并报告结果 ---
    DEALLOCATE(x, y, h)
    PRINT *, "步骤 5: 内存已释放。"
    PRINT *, "----------------------------------"
    PRINT *, "报告: 原始数据 ", num_lines, " 行, 裁剪后剩余 ", num_cropped, " 行。"
    PRINT *, "--- 程序结束 ---"

END PROGRAM cropper_hardcoded_eof