transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+F:/quartus/Cpu/rtl {F:/quartus/Cpu/rtl/z.v}
vlog -vlog01compat -work work +incdir+F:/quartus/Cpu/rtl {F:/quartus/Cpu/rtl/x.v}
vlog -vlog01compat -work work +incdir+F:/quartus/Cpu/rtl {F:/quartus/Cpu/rtl/tr.v}
vlog -vlog01compat -work work +incdir+F:/quartus/Cpu/rtl {F:/quartus/Cpu/rtl/top.v}
vlog -vlog01compat -work work +incdir+F:/quartus/Cpu/rtl {F:/quartus/Cpu/rtl/ram.v}
vlog -vlog01compat -work work +incdir+F:/quartus/Cpu/rtl {F:/quartus/Cpu/rtl/r1.v}
vlog -vlog01compat -work work +incdir+F:/quartus/Cpu/rtl {F:/quartus/Cpu/rtl/r0.v}
vlog -vlog01compat -work work +incdir+F:/quartus/Cpu/rtl {F:/quartus/Cpu/rtl/qtsj.v}
vlog -vlog01compat -work work +incdir+F:/quartus/Cpu/rtl {F:/quartus/Cpu/rtl/pc.v}
vlog -vlog01compat -work work +incdir+F:/quartus/Cpu/rtl {F:/quartus/Cpu/rtl/light_show.v}
vlog -vlog01compat -work work +incdir+F:/quartus/Cpu/rtl {F:/quartus/Cpu/rtl/ir.v}
vlog -vlog01compat -work work +incdir+F:/quartus/Cpu/rtl {F:/quartus/Cpu/rtl/dr.v}
vlog -vlog01compat -work work +incdir+F:/quartus/Cpu/rtl {F:/quartus/Cpu/rtl/CPU_Controller.v}
vlog -vlog01compat -work work +incdir+F:/quartus/Cpu/rtl {F:/quartus/Cpu/rtl/cpu.v}
vlog -vlog01compat -work work +incdir+F:/quartus/Cpu/rtl {F:/quartus/Cpu/rtl/control.v}
vlog -vlog01compat -work work +incdir+F:/quartus/Cpu/rtl {F:/quartus/Cpu/rtl/clk_div.v}
vlog -vlog01compat -work work +incdir+F:/quartus/Cpu/rtl {F:/quartus/Cpu/rtl/ar.v}
vlog -vlog01compat -work work +incdir+F:/quartus/Cpu/rtl {F:/quartus/Cpu/rtl/alu.v}

vlog -vlog01compat -work work +incdir+F:/quartus/Cpu/simulation/modelsim {F:/quartus/Cpu/simulation/modelsim/top.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  top_vlg_tst

add wave *
view structure
view signals
run -all
