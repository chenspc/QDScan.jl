using QDScan
using SparseArrays: sparse
using Test

@testset "QDScan.jl" begin
    @test raster_pattern(3, 3) == [1 4 7; 2 5 8; 3 6 9]
    @test serpentine_pattern(4, 3) == [1 8 9; 2 7 10; 3 6 11; 4 5 12]
    @test hilbert_pattern(4, 4) == [1 2 15 16; 4 3 14 13; 5 8 9 12; 6 7 10 11]
    @test spiral_pattern(4, 4; reverse=true) == [16 15 14 13; 5 4 3 12; 6 1 2 11; 7 8 9 10]
    @test spiral_pattern(4, 4; reverse=false) == [1 2 3 4; 12 13 14 5; 11 16 15 6; 10 9 8 7]
end

@testset "Up-sampling" begin
    @test upsample_matrix([1 2; 3 4], 2) == [1 0 2 0; 0 0 0 0; 3 0 4 0; 0 0 0 0]
    @test upsample_matrix([1 2; 3 4], 2; shift=(1, 1)) == [0 0 0 0; 0 1 0 2; 0 0 0 0; 0 3 0 4]
    @test upsample_matrix([1 2; 3 4], 2; shift=(-1, -1)) == [1 0 2 0; 0 0 0 0; 3 0 4 0; 0 0 0 0]
    @test upsample_matrix([1 2; 3 4], 3) == [0 0 0 0 0 0; 0 1 0 0 2 0; 0 0 0 0 0 0; 0 0 0 0 0 0; 0 3 0 0 4 0; 0 0 0 0 0 0]
    @test upsample_matrix([1 2; 3 4], 3; shift=(-1, -1)) == [1 0 0 2 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0; 3 0 0 4 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0]
    @test upsample_matrix([1 2; 3 4], 3; shift=(1, 1)) == [0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 1 0 0 2; 0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 3 0 0 4]
end

@testset "Offset" begin
    @test sequence_offset([1 2; 3 4], 1) == [2 3; 4 5]
    @test sequence_offset(sparse([1, 1, 2], [1, 2, 2], [7, 2, 4]), 1) == sparse([1, 1, 2], [1, 2, 2], [8, 3, 5])
end