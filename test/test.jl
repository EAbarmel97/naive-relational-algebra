using Test

include("../src/tables.jl")
include("../src/operations.jl")
include("records.jl")


@testset "selection  operator test" begin
    @test isequal(select(employees, Function[x -> x["salary"] > 60000 ]), Set{Record{String,Any}}([
        Record{String, Any}(Dict{String, Any}("name" => "Michael Scott", "id" => 0, "position" => "Regional Manager", "salary" => 100000))
        Record{String, Any}(Dict{String, Any}("name" => "Dwight K. Schrute", "id" => 1, "position" => "Assistant to the Regional Manager", "salary" => 65000))
    ])
    )

    @test isempty(select(employees, Function[x -> x["salary"] > 60000, x -> x["name"] == "Stanley Hudson"]))
end

@testset "projection operator tests" begin 
    @test isequal(project(employees, String["id", "name"]), Set{Record{String,Any}}([
        Record{String, Any}(Dict{String, Any}("name" => "Stanley Hudson", "id" => 4)),
        Record{String, Any}(Dict{String, Any}("name" => "Dwight K. Schrute", "id" => 1)),
        Record{String, Any}(Dict{String, Any}("name" => "Michael Scott", "id" => 0)),
        Record{String, Any}(Dict{String, Any}("name" => "Pamela Besly", "id" => 2)),
        Record{String, Any}(Dict{String, Any}("name" => "James Halpert", "id" => 3))])
    )

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
    ]))

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
    ]))
end

@testset "crossproduct operator tests" begin 
    marvel_movies = Set{Record{String,Any}}([
    Record{String, Any}(Dict{String, Any}("name" => "Spider man 3", "revenue" => 3000000, "rotten tomatos score" => 2.3)),
    Record{String, Any}(Dict{String, Any}("name" => "Iron man 1", "revenue" => 45000000, "rotten tomatos score" => 5.0 )),
    Record{String, Any}(Dict{String, Any}("name" => "The Hulk 1", "revenue" => 23000000, "rotten tomatos score" => 4.4 ))
   ])
    
    netflix_series = Set{Record{String,Any}}([
    Record{String, Any}(Dict{String, Any}("name" => "Rick & Morty", "number_of_seasons" => 6 , "is_available" => true)),
    Record{String, Any}(Dict{String, Any}("name" => "The Office", "number_of_seasons" => 8, "is_available" => true )),
    Record{String, Any}(Dict{String, Any}("name" => "The super ultra ultra Justice League", "number_of_seasons" => 0, "is_available" => false ))
   ])

   @test isequal(length(crossproduct(marvel_movies, netflix_series)), 9)

   @test isequal(crossproduct(marvel_movies, netflix_series),Set{Record{String, Any}}([
    Record{String, Any}(Dict{String, Any}("right.is_available" => false, "left.name" => "Iron man 1", "left.revenue" => 45000000, "right.number_of_seasons" => 0, "left.rotten tomatos score" => 5.0, "right.name" => "The super ultra ultra Justice League")), 
    Record{String, Any}(Dict{String, Any}("right.is_available" => true, "left.name" => "The Hulk 1", "left.revenue" => 23000000, "right.number_of_seasons" => 6, "left.rotten tomatos score" => 4.4, "right.name" => "Rick & Morty")), 
    Record{String, Any}(Dict{String, Any}("right.is_available" => true, "left.name" => "Iron man 1", "left.revenue" => 45000000, "right.number_of_seasons" => 8, "left.rotten tomatos score" => 5.0, "right.name" => "The Office")), 
    Record{String, Any}(Dict{String, Any}("right.is_available" => false, "left.name" => "Spider man 3", "left.revenue" => 3000000, "right.number_of_seasons" => 0, "left.rotten tomatos score" => 2.3, "right.name" => "The super ultra ultra Justice League")), 
    Record{String, Any}(Dict{String, Any}("right.is_available" => true, "left.name" => "Iron man 1", "left.revenue" => 45000000, "right.number_of_seasons" => 6, "left.rotten tomatos score" => 5.0, "right.name" => "Rick & Morty")), 
    Record{String, Any}(Dict{String, Any}("right.is_available" => true, "left.name" => "Spider man 3", "left.revenue" => 3000000, "right.number_of_seasons" => 8, "left.rotten tomatos score" => 2.3, "right.name" => "The Office")), 
    Record{String, Any}(Dict{String, Any}("right.is_available" => false, "left.name" => "The Hulk 1", "left.revenue" => 23000000, "right.number_of_seasons" => 0, "left.rotten tomatos score" => 4.4, "right.name" => "The super ultra ultra Justice League")),
    Record{String, Any}(Dict{String, Any}("right.is_available" => true, "left.name" => "Spider man 3", "left.revenue" => 3000000, "right.number_of_seasons" => 6, "left.rotten tomatos score" => 2.3, "right.name" => "Rick & Morty")), 
    Record{String, Any}(Dict{String, Any}("right.is_available" => true, "left.name" => "The Hulk 1", "left.revenue" => 23000000, "right.number_of_seasons" => 8, "left.rotten tomatos score" => 4.4, "right.name" => "The Office"))]))
end