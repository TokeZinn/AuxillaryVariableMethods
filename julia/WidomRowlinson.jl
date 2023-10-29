# Include the setup 
include("./setup.jl")

# Construct the State Space 
n = 42
S = collect(1:n) 

# For plotting 
r = 1 
θ(k) = 2 ⋅ k ⋅ π/n 

# Plot the circle 
plot(border = :none, aspect_ratio=:equal, legend = :topright)
scatter!([1.3, -1.3, 0, 0], [0, 0, 1.3, -1.3], alpha = 0., label = "")
for s in S
    scatter!([r ⋅ cos(θ(s))], [r ⋅ sin(θ(s))], color = :white, label = s == first(S) ? L"S" : "")
    annotate!([(r+0.1) ⋅ cos(θ(s))], [(r+0.1) ⋅ sin(θ(s))], text("$s", :black, 8))
end
title!("")

# Setup Metric 
d(s::Int, t::Int) =minimum(abs.([s-t,t-s, s+n-t,t+n-s]))
d(A::Vector{Int}, B::Vector{Int}) = ((length(A) == 0) | (length(B) == 0)) ? ((length(A) == 0) & (length(B) == 0)) == 0 ? 0. : Inf64 : minimum([d(s,t) for s in A, t in B])

# Setup ⊕ and \ 
⊕(A::Vector{Int}, R::Real) = [s for s in S if d(A,[s]) ≤ R]
\(S::Vector{Int}, A::Vector{Int}) = [s for s in S if s ∉ A]


Random.seed!(3)
A = rand(S, rand(S))
oplus_visualization = plot(border = :none, aspect_ratio=:equal, legend = :topright)
scatter!([1.3, -1.3, 0, 0], [0, 0, 1.3, -1.3], alpha = 0., label = "")
for s in A ⊕ 1
    scatter!([r ⋅ cos(θ(s))], [r ⋅ sin(θ(s))], color = 1, label = s ∈ A ⊕ 1 ? s == first(A ⊕ 1) ? L"A_{\oplus 1}" : "" : "", alpha = 0.2, markersize = 10.)
end

for s in S \ (A ⊕ 1)
    scatter!([r ⋅ cos(θ(s))], [r ⋅ sin(θ(s))], color = 2, label = s ∈ S \ (A ⊕ 1) ? s == first(S \ (A ⊕ 1)) ? L"S \backslash A_{\oplus 1}" : "" : "", alpha = 0.2, markersize = 10.)
end

for s in S
    scatter!([r ⋅ cos(θ(s))], [r ⋅ sin(θ(s))], color = s ∈ A ? 1 : :white, label = s ∈ A ? s == first(A) ? L"A" : "" : "")
    annotate!([(r+0.15) ⋅ cos(θ(s))], [(r+0.15) ⋅ sin(θ(s))], text("$s", :black, 8))
end

title!("")
savefig(oplus_visualization, "figures/oplus_visualization.pdf")

ξ(s, β) = begin
    ε = rand() 

    if ε > β/(1 + β) 
        return s 
    else
        return nothing
    end
end

𝒫(A::Vector{I}, β) where {I <: Int} = begin
    Y = I[]

    for s in A 
        if !isnothing(ξ(s, β))
            push!(Y, s)
        end
    end

    return Y
end


# Gibbs Sampler 
n = 64
R = 1
β₁ = 1.
β₂ = 1.
N = 1000

# Setup State Space 
S = collect(1:n) 

# Initial Sample
Random.seed!(14)
Y₁ = 𝒫(S, β₁)
Y₂ = 𝒫(S \ (Y₁ ⊕ R), β₂)

for _ in 1:N 
    Y₁ = 𝒫(S \ (Y₂ ⊕ R), β₁)
    Y₂ = 𝒫(S \ (Y₁ ⊕ R), β₂)
end

sample_plot = plot(border = :none, aspect_ratio=:equal, legend = :topright)
scatter!([1.3, -1.3, 0, 0], [0, 0, 1.3, -1.3], alpha = 0., label = "")
for s in S
    scatter!([r ⋅ cos(θ(s))], [r ⋅ sin(θ(s))], color = :white, label = s == first(S) ? L"S" : "")
    annotate!([(r+0.1) ⋅ cos(θ(s))], [(r+0.1) ⋅ sin(θ(s))], text("$s", :black, 5))
end

for s in Y₁ ⊕ R 
    scatter!([r ⋅ cos(θ(s))], [r ⋅ sin(θ(s))], color = 1, alpha = 0.25, label = s == first(Y₁) ? L"Y_{1 \oplus R} " : "")
end

for s in Y₁
    scatter!([r ⋅ cos(θ(s))], [r ⋅ sin(θ(s))], color = 1, label = s == first(Y₁) ? L"Y_1" : "")
end

for s in Y₂ ⊕ R 
    scatter!([r ⋅ cos(θ(s))], [r ⋅ sin(θ(s))], color = 2, alpha = 0.25, label = s == first(Y₂) ? L"Y_{1 \oplus R}" : "")
end

for s in Y₂
    scatter!([r ⋅ cos(θ(s))], [r ⋅ sin(θ(s))], color = 2, label = s == first(Y₂) ? L"Y_1" : "")
end

title!("")
savefig(sample_plot, "figures/sample_plot.pdf")