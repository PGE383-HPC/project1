#!/usr/bin/env julia
#
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
module project1

using DifferentialEquations
using LaTeXStrings
using Plots


function lorenz!(du, u, params, t)
    σ, β, ρ = params
    x, y, z = u

    du[1] = σ * (y - x)
    du[2] = x * (ρ - z) - y
    du[3] = x * y - β * z
    nothing
end

function lorenz_solver(x₀::Real, ρ::Real)
    prob = ODEProblem(lorenz!, [x₀; 1.0; 0.0],  (0.0, 100.0), [10.0, 8.0/3.0, ρ])
    solve(prob)
end

function plot3(ρ::Real)
    theme(:default, xformatter= x -> L"%$x", yformatter= x -> L"%$x")
    t = 0.0:0.01:100.0
    sol1 = lorenz_solver(0.0, ρ)(t)
    sol2 = lorenz_solver(1e-5, ρ)(t)

    x₁ = getindex.(sol1.u, 1)
    x₂ = getindex.(sol2.u, 1)
    z₁ = getindex.(sol1.u, 3)

    p1 = plot(t, [x₁, x₂], label=nothing, xlabel=L"t", ylabel=L"x_1, x_2", 
              title=L"\rho = %$ρ", xformatter= x -> L"%$x", yformatter= x -> L"%$x")
    p2 = plot(t, abs.(x₁ .- x₂), label=nothing, xlabel=L"t", ylabel=L"\vert x_1 - x_2\vert")
    p3 = plot(x₁, z₁, label=nothing, xlabel=L"x_1", ylabel=L"z_1")

    (p1, p2, p3)
end

function lorenz_plot()
    p1, p2, p3 = project1.plot3(14.0)
    p4, p5, p6 = project1.plot3(28.0)
    p1 = plot!(p1, xlabel="", xformatter= _ -> "")
    p4 = plot!(p4, xlabel="", ylabel="", xformatter= _ -> "", yformatter= _ -> "")
    p5 = plot!(p5, ylabel="", yformatter= _ -> "")
    p6 = plot!(p6, ylabel="", yformatter= _ -> "")
    p7 = plot(p1, p4, p2, p5, layout=(2,2), link=:both)
    p8 = plot(p3, p6, layout=(1,2), link=:y)

    l = @layout [
        a{0.6666h}
        b{0.3333h}]
    plot(p7, p8, layout=l)
end

export lorenz_solver, lorenz_plot

end
