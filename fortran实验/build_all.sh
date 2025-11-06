
#!/usr/bin/env bash
# build_all.sh
# 尝试编译每个实验；单个失败不会中断整个脚本，便于你逐个修复问题。

base_dir=$(dirname "$0")
cd "$base_dir" || exit 1

echo "Compiling experiments in $base_dir"

compile() {
	src="$1"
	out="$2"
	printf "Compiling %s -> %s ... " "$src" "$out"
	if gfortran "$src" -o "$out" 2>/tmp/fortran_build.log; then
		echo "OK"
	else
		echo "FAIL"
		echo "---- error output (tail) ----"
		tail -n 50 /tmp/fortran_build.log || true
		echo "-----------------------------"
	fi
}

compile "实验·1/area.f90" "实验·1/area"
compile "实验2/equation_solver.f90" "实验2/solve"
compile "实验3/exp.f90" "实验3/exp"
compile "实验4/cropper_hardcoded_eof.f90" "实验4/cropper_hardcoded_eof"
compile "实验5/test1.f90" "实验5/test1_exp5"
compile "实验6/test1.f90" "实验6/test1_exp6"
compile "实验7/test7.f90" "实验7/test7"
compile "实验8/test8.f90" "实验8/test8"

echo "Done. Check above for any FAIL entries."

