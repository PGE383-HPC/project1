#!/usr/bin/env julia

# Copyright 2022 John T. Foster
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
import project1
using Test
using ImageQualityIndexes
using Images, FileIO
using Plots

@testset "project1.jl" begin
    sol = project1.lorenz_solver(0.0, 14)(0.0:20.0:100.0).u
    x = getindex.(sol, 1)
    y = getindex.(sol, 2)
    z = getindex.(sol, 3)
    @test all(isapprox.(x, [0.0, -5.886, -5.887, -5.887, -5.887, -5.887], atol=1.0e-3))
    @test all(isapprox.(y, [1.0, -5.875, -5.887, -5.887, -5.887, -5.887], atol=1.0e-3))
    @test all(isapprox.(z, [0.0, 13.017, 13.000, 13.000, 13.000, 13.000], atol=1.0e-3))
    ENV["GKSwstype"]="nul"
    savefig(project1.lorenz_plot(), "lorenz.png")
    goldfile_path = realpath(dirname(@__FILE__)*"/../images/lorenz_gold.png")
    imgfile_path = realpath(dirname(@__FILE__)*"/../test/lorenz.png")
    img1 = load(goldfile_path)
    img2 = load(imgfile_path)
    @test assess_ssim(img1, img2) >= 0.8
end
