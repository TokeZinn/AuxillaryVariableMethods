#= Packages =# 
using Distributions
using Plots
using LaTeXStrings
using NamedColors
using PGFPlotsX
using Random
using Colors

#= Setup PGFPlotsX =# 
pgfplotsx()
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\usepackage{mathtools}")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\usepackage{amssymb}")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\usepackage{amsthm}")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\usepackage{amsmath}")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\usepackage{bbm}")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\usepackage{bm}")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\usepackage[scr=euler]{mathalpha}")
pgfplotsx()

# Setup for notation 
⋅ = *
