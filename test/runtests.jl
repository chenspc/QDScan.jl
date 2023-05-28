using QDScan
using SparseArrays: sparse
using SparseArrays
using Test

@testset "Basic patterns" begin
    @test raster_pattern(3, 3) == [1 4 7; 2 5 8; 3 6 9]
    @test serpentine_pattern(4, 3) == [1 8 9; 2 7 10; 3 6 11; 4 5 12]
    @test hilbert_pattern(4, 4) == [1 2 15 16; 4 3 14 13; 5 8 9 12; 6 7 10 11]
    @test spiral_pattern(4, 4; reverse=true) == [16 15 14 13; 5 4 3 12; 6 1 2 11; 7 8 9 10]
    @test spiral_pattern(4, 4; reverse=false) == [1 2 3 4; 12 13 14 5; 11 16 15 6; 10 9 8 7]
    @test interleave_pattern(4, 4, 2) == [1 9 3 11; 5 13 7 15; 2 10 4 12; 6 14 8 16]
    @test interleave_pattern(6, 6, 3) == [1 13 25 3 15 27; 5 17 29 7 19 31; 9 21 33 11 23 35; 2 14 26 4 16 28; 6 18 30 8 20 32; 10 22 34 12 24 36]
    @test interleave_pattern(6, 6, (2, 3)) == [1 13 25 4 16 28; 7 19 31 10 22 34; 2 14 26 5 17 29; 8 20 32 11 23 35; 3 15 27 6 18 30; 9 21 33 12 24 36]

    @test make_pattern((3, 3); pattern="raster") == [(0, 0), (1, 0), (2, 0), (0, 1), (1, 1), (2, 1), (0, 2), (1, 2), (2, 2)]
    @test make_pattern((4, 3); pattern="serpentine") == [(0, 0), (1, 0), (2, 0), (3, 0), (3, 1), (2, 1), (1, 1), (0, 1), (0, 2), (1, 2), (2, 2), (3, 2)]
    @test make_pattern((4, 4); pattern="hilbert") == [(0, 0), (0, 1), (1, 1), (1, 0), (2, 0), (3, 0), (3, 1), (2, 1), (2, 2), (3, 2), (3, 3), (2, 3), (1, 3), (1, 2), (0, 2), (0, 3)]
    @test make_pattern((4, 4); pattern="spiral", reverse=true) == [(2, 1), (2, 2), (1, 2), (1, 1), (1, 0), (2, 0), (3, 0), (3, 1), (3, 2), (3, 3), (2, 3), (1, 3), (0, 3), (0, 2), (0, 1), (0, 0)]
    @test make_pattern((4, 4); pattern="spiral", reverse=false) == [(0, 0), (0, 1), (0, 2), (0, 3), (1, 3), (2, 3), (3, 3), (3, 2), (3, 1), (3, 0), (2, 0), (1, 0), (1, 1), (1, 2), (2, 2), (2, 1)]
    @test make_pattern((4, 4, 2); pattern="interleave") == [(0, 0), (2, 0), (0, 2), (2, 2), (1, 0), (3, 0), (1, 2), (3, 2), (0, 1), (2, 1), (0, 3), (2, 3), (1, 1), (3, 1), (1, 3), (3, 3)]
    @test make_pattern((6, 6, (2, 3)); pattern="interleave") == [(0, 0), (2, 0), (4, 0), (0, 3), (2, 3), (4, 3), (1, 0), (3, 0), (5, 0), (1, 3), (3, 3), (5, 3), (0, 1), (2, 1), (4, 1), (0, 4), (2, 4), (4, 4), (1, 1), (3, 1), (5, 1), (1, 4), (3, 4), (5, 4), (0, 2), (2, 2), (4, 2), (0, 5), (2, 5), (4, 5), (1, 2), (3, 2), (5, 2), (1, 5), (3, 5), (5, 5)]

    @test make_pattern(sparse([1, 1, 2], [1, 2, 2], [1, 2, 4]); pattern="premade") == [(0, 0), (0, 1), (1, 1)]

    @test make_pattern((3, 3); pattern="raster", linear_index=true) == [0, 1, 2, 3, 4, 5, 6, 7, 8]
    @test make_pattern((4, 3); pattern="serpentine", linear_index=true) == [0, 1, 2, 3, 7, 6, 5, 4, 8, 9, 10, 11]
    @test make_pattern((4, 4); pattern="hilbert", linear_index=true) == [0, 4, 5, 1, 2, 3, 7, 6, 10, 11, 15, 14, 13, 9, 8, 12]
    @test make_pattern((4, 4); pattern="spiral", linear_index=true, reverse=true) == [6, 10, 9, 5, 1, 2, 3, 7, 11, 15, 14, 13, 12, 8, 4, 0]
    @test make_pattern((4, 4); pattern="spiral", linear_index=true, reverse=false) == [0, 4, 8, 12, 13, 14, 15, 11, 7, 3, 2, 1, 5, 9, 10, 6]
    @test make_pattern((4, 4, 2); pattern="interleave", linear_index=true) == [0, 2, 8, 10, 1, 3, 9, 11, 4, 6, 12, 14, 5, 7, 13, 15]
    @test make_pattern((6, 6, (2, 3)); pattern="interleave", linear_index=true) == [0, 2, 4, 18, 20, 22, 1, 3, 5, 19, 21, 23, 6, 8, 10, 24, 26, 28, 7, 9, 11, 25, 27, 29, 12, 14, 16, 30, 32, 34, 13, 15, 17, 31, 33, 35]
    @test make_pattern(sparse([1, 1, 2], [1, 2, 2], [1, 2, 4]); pattern="premade", linear_index=true) == [0, 2, 3]
end

@testset "Repeat" begin
    @test make_pattern([[1+1im, 2+2im] [3, 4+1im]] ; pattern="premade") == [(0, 0), (0, 0), (1, 0), (1, 0), (1, 0), (0, 1), (1, 1), (1, 1)]
    @test make_pattern([[1+1im, 2+2im] [3, 4+1im]] ; pattern="premade", linear_index=true) == [0, 0, 1, 1, 1, 2, 3, 3]
    @test make_pattern([[1+1im, 2+2im] [3, 4+1im]] ; pattern="premade", multipass=2) == [(0, 0), (0, 0), (1, 0), (1, 0), (1, 0), (0, 1), (1, 1), (1, 1), (0, 0), (0, 0), (1, 0), (1, 0), (1, 0), (0, 1), (1, 1), (1, 1)]
    @test make_pattern([[1+1im, 2+2im] [3, 4+1im]] ; pattern="premade", multipass=2, linear_index=true) == [0, 0, 1, 1, 1, 2, 3, 3, 0, 0, 1, 1, 1, 2, 3, 3]
    @test make_pattern(sparse([1, 1, 2], [1, 2, 2], [1+3im, 2, 4+1im]); pattern="premade", multipass=2) == [(0, 0), (0, 0), (0, 0), (0, 0), (0, 1), (1, 1), (1, 1), (0, 0), (0, 0), (0, 0), (0, 0), (0, 1), (1, 1), (1, 1)]
    @test make_pattern(sparse([1, 1, 2], [1, 2, 2], [1+3im, 2, 4+1im]); pattern="premade", multipass=2, linear_index=true) == [0, 0, 0, 0, 2, 3, 3, 0, 0, 0, 0, 2, 3, 3]
    @test make_pattern(sparse([1, 1, 2], [1, 2, 2], [1+3im, 2, 4+1im]); pattern="premade", multipass=2) == [(0, 0), (0, 0), (0, 0), (0, 0), (0, 1), (1, 1), (1, 1), (0, 0), (0, 0), (0, 0), (0, 0), (0, 1), (1, 1), (1, 1)]
    @test make_pattern(sparse([1, 1, 2], [1, 2, 2], [1+3im, 2, 4+1im]); pattern="premade", multipass=2, linear_index=true) == [0, 0, 0, 0, 2, 3, 3, 0, 0, 0, 0, 2, 3, 3]
end

@testset "Up-sampling" begin
    @test upsample_matrix([1 2; 3 4], 2) == [1 0 2 0; 0 0 0 0; 3 0 4 0; 0 0 0 0]
    @test upsample_matrix([1 2; 3 4], 2; shift=(1, 1)) == [0 0 0 0; 0 1 0 2; 0 0 0 0; 0 3 0 4]
    @test upsample_matrix([1 2; 3 4], 2; shift=(-1, -1)) == [1 0 2 0; 0 0 0 0; 3 0 4 0; 0 0 0 0]
    @test upsample_matrix([1 2; 3 4], 3) == [0 0 0 0 0 0; 0 1 0 0 2 0; 0 0 0 0 0 0; 0 0 0 0 0 0; 0 3 0 0 4 0; 0 0 0 0 0 0]
    @test upsample_matrix([1 2; 3 4], 3; shift=(-1, -1)) == [1 0 0 2 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0; 3 0 0 4 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0]
    @test upsample_matrix([1 2; 3 4], 3; shift=(1, 1)) == [0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 1 0 0 2; 0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 3 0 0 4]
    @test upsample_matrix([1 2; 3 4], (2, 3)) == [0 1 0 0 2 0; 0 0 0 0 0 0; 0 3 0 0 4 0; 0 0 0 0 0 0]
    @test upsample_matrix([1 2; 3 4], (2, 3); shift=(-1, -1)) == [1 0 0 2 0 0; 0 0 0 0 0 0; 3 0 0 4 0 0; 0 0 0 0 0 0]
    @test upsample_matrix([1 2; 3 4], (2, 3); shift=(1, 1)) == [0 0 0 0 0 0; 0 0 1 0 0 2; 0 0 0 0 0 0; 0 0 3 0 0 4]
end

@testset "Offset" begin
    @test sequence_offset([1 2; 3 4], 1) == [2 3; 4 5]
    @test sequence_offset(sparse([1, 1, 2], [1, 2, 2], [7, 2, 4]), 1) == sparse([1, 1, 2], [1, 2, 2], [8, 3, 5])
end