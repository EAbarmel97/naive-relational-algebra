using Test

include("../src/tables.jl")
include("../src/operations.jl")
include("records.jl")


@testset "selection  operator test" begin
    @test isequal(select(employes, Function[x -> x["salary"] > 60000 ]), Set{Record{String,Any}}([Record{String, Any}(Dict{String, Any}("name" => "Michael Scott", "id" => 0, "position" => "Regional Manager", "salary" => 100000))
    Record{String, Any}(Dict{String, Any}("name" => "Dwight K. Schrute", "id" => 1, "position" => "Assistant to the Regional Manager", "salary" => 65000))
    ])) === true 

    @test isempty(select(employes, Function[x -> x["salary"] > 60000, x -> x["name"] == "Stanley Hudson"])) === true 
end

@testset "proyection operator tests" begin 
   
end    