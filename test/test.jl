using Test

include("../src/tables.jl")
include("../src/operations.jl")
include("records.jl")


@testset "selection  operator test" begin
    @test isequal(select(employees, Function[x -> x["salary"] > 60000 ]), Set{Record{String,Any}}([
        Record{String, Any}(Dict{String, Any}("name" => "Michael Scott", "id" => 0, "position" => "Regional Manager", "salary" => 100000))
        Record{String, Any}(Dict{String, Any}("name" => "Dwight K. Schrute", "id" => 1, "position" => "Assistant to the Regional Manager", "salary" => 65000))
    ])
    ) === true 

    @test isempty(select(employees, Function[x -> x["salary"] > 60000, x -> x["name"] == "Stanley Hudson"])) === true 
end

@testset "projection operator tests" begin 
    @test isequal(project(employees, String["id", "name"]), Set{Record{String,Any}}([
        Record{String, Any}(Dict{String, Any}("name" => "Stanley Hudson", "id" => 4)),
        Record{String, Any}(Dict{String, Any}("name" => "Dwight K. Schrute", "id" => 1)),
        Record{String, Any}(Dict{String, Any}("name" => "Michael Scott", "id" => 0)),
        Record{String, Any}(Dict{String, Any}("name" => "Pamela Besly", "id" => 2)),
        Record{String, Any}(Dict{String, Any}("name" => "James Halpert", "id" => 3))])
    ) === true

    @test_throws KeyError project(employees, String["name","gender"])
end

@testset "rename columns tests" begin
    @test isequal(rename(clients, Dict{String, String}("name" => "full name")),  Set{Record{String,Any}}([
     Record{String, Any}(Dict{String, Any}("full name" => "Dunmore High School", "id" => 0, "contactid" => 3)),
     Record{String, Any}(Dict{String, Any}("full name" => "Phil Maguire", "id" => 3, "contactid" => 3)),
     Record{String, Any}(Dict{String, Any}("full name" => "Lackawanna County", "id" => 1, "contactid" => 0)),
     Record{String, Any}(Dict{String, Any}("full name" => "Harper Collins", "id" => 4, "contactid" => 1)),
     Record{String, Any}(Dict{String, Any}("full name" => "Mr. Deckert", "id" => 2, "contactid" => 1)),
     Record{String, Any}(Dict{String, Any}("full name" => "Apex Technology", "id" => 5, "contactid" => 1))
    ])) === true

     new_clients = Set{Record{String,Any}}([
     Record{String, Any}(Dict{String, Any}("full name" => "Phil Maguire", "id" => 3, "contactid" => 3)),
     Record{String, Any}(Dict{String, Any}("full name" => "Lackawanna County", "id" => 1, "contactid" => 0)),
     Record{String, Any}(Dict{String, Any}("full name" => "Harper Collins", "id" => 4, "contactid" => 1)),
     Record{String, Any}(Dict{String, Any}("full name" => "Mr. Deckert", "id" => 2, "contactid" => 1)),
    ])

    new_clients = rename(new_clients, Dict{String, String}("full name" => "client full name"))

    @test isequal(new_clients,  Set{Record{String,Any}}([
     Record{String, Any}(Dict{String, Any}("client full name" => "Phil Maguire", "id" => 3, "contactid" => 3)),
     Record{String, Any}(Dict{String, Any}("client full name" => "Lackawanna County", "id" => 1, "contactid" => 0)),
     Record{String, Any}(Dict{String, Any}("client full name" => "Harper Collins", "id" => 4, "contactid" => 1)),
     Record{String, Any}(Dict{String, Any}("client full name" => "Mr. Deckert", "id" => 2, "contactid" => 1)),
    ])) === true
end