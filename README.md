# QDScan

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://chenspc.github.io/QDScan.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://chenspc.github.io/QDScan.jl/dev/)
[![Build Status](https://github.com/chenspc/QDScan.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/chenspc/QDScan.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/chenspc/QDScan.jl?svg=true)](https://ci.appveyor.com/project/chenspc/QDScan-jl)
[![Coverage](https://codecov.io/gh/chenspc/QDScan.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/chenspc/QDScan.jl)

## Installation

### Install Julia
[Downloads](https://julialang.org/downloads/) and [Documentation](https://docs.julialang.org/)

### Install QDScan.jl
Press `[` in a Julia REPL to access package mode, then for using the package:
```juila
pkg> add git@github.com:chenspc/QDScan.jl.git
```
or for development:
```juila
pkg> dev git@github.com:chenspc/QDScan.jl.git
```

## Patterns

### Raster
```julia
p = make_pattern(8, 8; pattern="raster", visual="lineplot");
```
<img width="633" alt="qdscan_example_raster" src="https://github.com/chenspc/QDScan.jl/assets/10161227/e916711a-f074-4ccd-ac25-566f257730eb">

### Serpentine
```julia 
p = make_pattern(8, 8; pattern="serpentine", visual="lineplot");
```
<img width="633" alt="qdscan_example_serpentine" src="https://github.com/chenspc/QDScan.jl/assets/10161227/e5d64136-0635-4a22-b1e4-cf6b4c255bc4">

### Hilbert
```julia
p = make_pattern(8, 8; pattern="hilbert", visual="lineplot");
```
<img width="633" alt="qdscan_example_hilbert" src="https://github.com/chenspc/QDScan.jl/assets/10161227/ca61e716-0f10-4c26-a14b-c0ec7c88fa50">

### Spiral
```julia
p = make_pattern(8, 8; pattern="spiral", visual="lineplot");
```
<img width="633" alt="qdscan_example_spiral" src="https://github.com/chenspc/QDScan.jl/assets/10161227/3ccfaab5-1dab-4ff3-8c3b-1e88ee1912f2">

### Interleave
```julia
p = make_pattern(8, 8, 2; pattern="interleave", visual="heatmap");
p = make_pattern(9, 9, 3; pattern="interleave", visual="heatmap");
p = make_pattern(6, 6, (2, 3); pattern="interleave", visual=["matrix", "heatmap"]);
```
<img width="759" alt="qdscan_example_interleave" src="https://github.com/chenspc/QDScan.jl/assets/10161227/18c49817-0351-45fe-8a4f-68c0ddcd5d1d">

### Random
`julia> p = make_pattern(16, 16; pattern="random", visual="heatmap", seed=1234);`
<img width="682" alt="qdscan_example_random" src="https://github.com/chenspc/QDScan.jl/assets/10161227/d2479824-73e1-4b1e-b6af-42f88058dacd">

### Sparse
```julia
p = make_pattern(10, 10, 0.1; pattern="sparse", visual=["matrix", "heatmap"], seed=1234);

make_pattern(10, 10; pattern="sparse", visual="heatmap") == make_pattern(10, 10, 0.5; pattern="sparse", visual="heatmap", seed=2023)
```
<img width="1095" alt="qdscan_example_sparse" src="https://github.com/chenspc/QDScan.jl/assets/10161227/056f7d8c-83bf-4198-b4c0-8524d89113d6">

### Premade patterns
* Any matrix with positive integer elements that do not repeat can be converted into a pattern. Simply give the matrix as the first input to `make_pattern`. 
* Julia matrices are column major, counting first from top to bottom, while scan patterns are typically displayed from left to right first, hence appearing transposed after the `make_pattern` function. 
* QD Scan Engine use 0-based index, so the pattern coordinates need to subtract 1, or (1, 1). 
* QD Scan Engine accepts either coordinates as `(x, y)` or `x + y*x_size`. Use the optional `linear_index` variable to toggle the output. 
```julia
julia> A = random_pattern(2, 3)
2×3 Matrix{Int64}:
 5  4  1
 6  3  2

julia> p = make_pattern(A; pattern="premade")
3×2 adjoint(::Matrix{Int64}) with eltype Int64:
 5  6
 4  3
 1  2
6-element Vector{Tuple{Int64, Int64}}:
 (0, 2)
 (1, 2)
 (1, 1)
 (0, 1)
 (0, 0)
 (1, 0)

julia> p = make_pattern(A; pattern="premade", linear_index=true)
3×2 adjoint(::Matrix{Int64}) with eltype Int64:
 5  6
 4  3
 1  2
6-element Vector{Int64}:
 4
 5
 3
 2
 0
 1
```
## Repeat a pattern
### Repeat at the same position before moving on to the next position
The `make_pattern` function can accept a complex matrix as input. When an element is real, the probe will stop for one dwell period before moving onto the next. A complex element in the matrix, e.g. `4 + 2im` means dwelling at position `4` for 3 periods (1 default + 2 additional). 
```julia
julia> B = A .+ 2im
2×3 Matrix{Complex{Int64}}:
 5+2im  4+2im  1+2im
 6+2im  3+2im  2+2im

julia> ppp = make_pattern(B; pattern="premade", linear_index=true)
3×2 adjoint(::Matrix{Int64}) with eltype Int64:
 5  6
 4  3
 1  2
18-element Vector{Int64}:
 4
 4
 4
 5
 5
 5
 3
 3
 3
 2
 2
 2
 0
 0
 0
 1
 1
 1
```
### Multiple passes of the same pattern (including multiple frames if the matrix is complex)
One can also simply repeat the whole pattern by providing the optional `multipass` variable
```julia
julia> px3 = make_pattern(A; pattern="premade", linear_index=true, multipass=3)
3×2 adjoint(::Matrix{Int64}) with eltype Int64:
 5  6
 4  3
 1  2
18-element Vector{Int64}:
 4
 5
 3
 2
 0
 1
 4
 5
 3
 2
 0
 1
 4
 5
 3
 2
 0
 1
```

## Save pattern to file
```julia
save_pattern("test_pattern.csv", p)
```
