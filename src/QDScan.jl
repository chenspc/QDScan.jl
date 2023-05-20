module QDScan

export make_pattern, save_pattern
export raster_pattern, serpentine_pattern, hilbert_pattern, spiral_pattern, random_pattern, sparse_pattern
export upsample_matrix, sequence_offset

using BijectiveHilbert: Simple2D, encode_hilbert
using Random: randperm, seed!
using SparseArrays: sprand, nnz, spzeros, issparse
using UnicodePlots: heatmap, lineplot

function make_pattern(dims; pattern="raster", offset::Int=0, visual="matrix", kwargs...)
    p = if pattern == "raster"
            raster_pattern(dims...; kwargs...)
        elseif pattern == "serpentine"
            serpentine_pattern(dims...; kwargs...)
        elseif pattern == "hilbert"
            hilbert_pattern(dims...; kwargs...)
        elseif pattern == "spiral"
            spiral_pattern(dims...; kwargs...)
        elseif pattern == "random"
            random_pattern(dims...; kwargs...)
        elseif pattern == "sparse"
            sparse_pattern(dims...; kwargs...)
        elseif pattern == "premade"
            dims # dims is a matrix
        else
            error("pattern must be one of raster, serpentine, hilbert, spiral, random, sparse, or premade.")
        end

    p = sequence_offset(p, offset)
    xy_list = map(x -> x.I, CartesianIndices(size(p))[last(sortperm(vec(p)), count(!iszero, p))])

    occursin("matrix", join(visual)) ? display(p') : nothing
    occursin("heatmap", join(visual)) ? display(heatmap(p; colormap=:rainbow)) : nothing
    occursin("lineplot", join(visual)) ? display(lineplot(first.(xy_list), last.(xy_list))) : nothing

    return xy_list
end

function save_pattern(filename, xy_list)
    open(filename, "w") do io
        [write(io, "$x,$y\n") for (x, y) in xy_list]
    end
    return nothing
end

function raster_pattern(x, y)
    reshape(collect(1:x*y), (x, y))
end

function serpentine_pattern(x, y)
    xy = reshape(collect(1:x*y), (x, y))
    for i in 2:2:x
        xy[:, i] = reverse(xy[:, i])
    end
    return xy
end

function hilbert_pattern(x, y)
    map(c -> encode_hilbert(Simple2D(Int), collect(Tuple(c))), CartesianIndices((x, y)))
end

function spiral_pattern(x, y; reverse=true)
    matrix = reshape(collect(1:x*y), (x, y))
    result = []
    top = 1
    bottom = x
    left = 1
    right = y

    while top <= bottom && left <= right
        [push!(result, matrix[top, j]) for j in left:right] # left to right
        top += 1

        if top <= bottom
            [push!(result, matrix[i, right]) for i in top:bottom] # top to bottom
            right -= 1
        end

        if left <= right
            [push!(result, matrix[bottom, j]) for j in right:-1:left] # right to left
            bottom -= 1
        end

        if top <= bottom
            [push!(result, matrix[i, left]) for i in bottom:-1:top] # bottom to top
            left += 1
        end
    end

    reverse ? reverse!(result) : nothing
    spiral_matrix = matrix
    spiral_matrix[result] = collect(1:length(result))
    return spiral_matrix
end

function random_pattern(x, y; offset=0, seed=2023)
    seed!(seed)
    reshape(randperm(x*y), (x, y)) .+ offset
end

function sparse_pattern(x, y; offset=0, p=0.5, seed=2023, ordered=true)
    seed!(seed)
    s = sprand(Int, x, y, p)
    if ordered
        s.nzval[:] = collect(1:nnz(s)) .+ offset
    else
        s.nzval[:] = randperm(nnz(s)) .+ offset
    end
    return s
end

function upsample_matrix(A::AbstractMatrix, k::Int; shift=(0, 0))
    m, n = size(A)
    B = spzeros(eltype(A), m * k, n * k)
    s = mod.(Int.(trunc.(shift .+ (k-1)/2)), k)

    for i in 1:m
        for j in 1:n
            B[(i-1)*k+1+s[1], (j-1)*k+1+s[2]] = A[i, j]
        end
    end

    return B
end

function sequence_offset(A::AbstractMatrix, offset::Int)
    B = copy(A)
    if issparse(A)
        B.nzval[:] = collect(1:nnz(B)) .+ offset
    else
        B = map(x -> !iszero(x) ? x + offset : nothing, A)
    end
    return B
end

end