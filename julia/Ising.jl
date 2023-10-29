# Packages 
using Plots
using Random

# Setup 
n = 64
m = 64
S = [(i,j) for i ∈ 1:n, j in 1:m]

norm(s::Tuple{Int,Int}) = sqrt((s[1])^2 + (s[2])^2)

function ~(s::Tuple{Int,Int}, t::Tuple{Int,Int}) 
    0 < norm(s .- t) ≤ 1 ? (return true) : (return false)
end

∂(s::Tuple{Int, Int}) = begin
    Nₛ = Tuple{Int,Int}[]
    for t in S 
        if (t ~ s) 
            push!(Nₛ, t)
        end
    end
    
    Nₛ
end
𝛛 = [∂(s) for s in S]
ℰ = Set([Set([s,t]) for s in S for t in S if (s ~ t)])
𝒳ₛ = [1, -1]


x = [rand([-1,1]) for i ∈ 1:n, j ∈ 1:m]
plot(border = :none, aspect_ratio=:equal, legend = :topright)
heatmap!(x)

β = 0.1
p(xₛ, s; x) = exp(β ⋅ xₛ ⋅ sum(x[t...] for t ∈ ∂(s))) 
sample(s; x) = begin
    pₛ = cumsum([p(xₛ, s; x = x) for xₛ in 𝒳ₛ])
    Z = pₛ[end]
    u = Z * rand() 
    
    for i in eachindex(pₛ)
        if i == 1
            if 0 ≤ u ≤ pₛ[i]
                return 𝒳ₛ[i]
            end
        elseif pₛ[i-1] ≤ u ≤ pₛ[i]
                return 𝒳ₛ[i]
        end
    end
end

gr()
x = [rand([-1,1]) for i ∈ 1:n, j ∈ 1:m]
@gif for i in 1:25
    for s in S 
        x[s...] = sample(s; x = x)
    end
    plot(border = :none, aspect_ratio=:equal, legend = :topright)
    heatmap!(x)
end
