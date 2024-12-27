using Test
using OrderedCollections 

include("../src/tables.jl")
include("../src/operations.jl")
include("records.jl")


@testset "selection  operator test" begin
    @test isequal(select(employees, Function[x -> x["salary"] > 60000 ]), Set{Record{String,Any}}([
        Record{String, Any}(OrderedDict{String, Any}("id" => 0, "name" => "Michael Scott", "position" => "Regional Manager", "salary" => 100000))
        Record{String, Any}(OrderedDict{String, Any}("id" => 1,"name" => "Dwight K. Schrute", "position" => "Assistant to the Regional Manager", "salary" => 65000))
    ]))
    
    @test isempty(select(employees, Function[x -> x["salary"] > 60000, x -> x["name"] == "Stanley Hudson"]))
end

@testset "projection operator tests" begin 
    @test isequal(project(employees, String["id", "name"]), Set{Record{String,Any}}([
        Record{String, Any}(OrderedDict{String, Any}("id" => 4, "name" => "Stanley Hudson")),
        Record{String, Any}(OrderedDict{String, Any}("id" => 1, "name" => "Dwight K. Schrute")),
        Record{String, Any}(OrderedDict{String, Any}("id" => 0, "name" => "Michael Scott")),
        Record{String, Any}(OrderedDict{String, Any}("id" => 2, "name" => "Pamela Besly")),
        Record{String, Any}(OrderedDict{String, Any}("id" => 3, "name" => "James Halpert"))])
    )

    #selecting non-exiting attribute
    @test_throws KeyError project(employees, String["name","gender"])
end

@testset "rename columns tests" begin
    @test isequal(rename(clients, Dict{String, String}("name" => "full_name")),  Set{Record{String,Any}}([
     Record{String, Any}(OrderedDict{String, Any}("id" => 0, "full_name" => "Dunmore High School", "contactid" => 3)),
     Record{String, Any}(OrderedDict{String, Any}("id" => 3, "full_name" => "Phil Maguire", "contactid" => 3)),
     Record{String, Any}(OrderedDict{String, Any}("id" => 1, "full_name" => "Lackawanna County", "contactid" => 0)),
     Record{String, Any}(OrderedDict{String, Any}("id" => 4, "full_name" => "Harper Collins", "contactid" => 1)),
     Record{String, Any}(OrderedDict{String, Any}("id" => 2, "full_name" => "Mr. Deckert", "contactid" => 1)),
     Record{String, Any}(OrderedDict{String, Any}("id" => 5, "full_name" => "Apex Technology", "contactid" => 1))
    ]))
    

    new_clients = Set{Record{String,Any}}([
        Record{String, Any}(OrderedDict{String, Any}("id" => 3, "full_name" => "Phil Maguire", "contactid" => 3)),
        Record{String, Any}(OrderedDict{String, Any}("id" => 1, "full_name" => "Lackawanna County", "contactid" => 0)),
        Record{String, Any}(OrderedDict{String, Any}("id" => 4, "full_name" => "Harper Collins", "contactid" => 1)),
        Record{String, Any}(OrderedDict{String, Any}("id" => 2, "full_name" => "Mr. Deckert", "contactid" => 1))
    ])

    new_clients = rename(new_clients, Dict{String, String}("full_name" => "client_full_name", "id" => "client_id"))
    
    #check rename is now persisted
   @test isequal(new_clients,  Set{Record{String,Any}}([
        Record{String, Any}(OrderedDict{String, Any}("client_id" => 3, "client_full_name" => "Phil Maguire", "contactid" => 3)),
        Record{String, Any}(OrderedDict{String, Any}("client_id" => 1, "client_full_name" => "Lackawanna County", "contactid" => 0)),
        Record{String, Any}(OrderedDict{String, Any}("client_id" => 4, "client_full_name" => "Harper Collins", "contactid" => 1)),
        Record{String, Any}(OrderedDict{String, Any}("client_id" => 2, "client_full_name" => "Mr. Deckert", "contactid" => 1))
    ]))
end

@testset "crossproduct operator tests" begin 

   output_relation = cartesianproduct(marvel_movies, netflix_series)

    #checking the cartesian product has the correct cardinality
   @test isequal(length(output_relation), 9)

    #checking correct order of attributes
   @test isequal(collect(keys(first(output_relation).dict)), String["left.name", "left.revenue", "left.rotten_tomatos_score", "right.name", "right.number_of_seasons", "right.is_available"])

   @test isequal(output_relation, Set{Record{String, Any}}([
    Record{String, Any}(OrderedDict{String, Any}("left.name" => "Spider man 3", "left.revenue" => 3000000, "left.rotten_tomatos_score" => 2.3, "right.name" => "Rick & Morty", "right.number_of_seasons" => 6 , "right.is_available" => true )), 
    Record{String, Any}(OrderedDict{String, Any}("left.name" => "Spider man 3", "left.revenue" => 3000000, "left.rotten_tomatos_score" => 2.3, "right.name" => "The Office", "right.number_of_seasons" => 8, "right.is_available" => true )),
    Record{String, Any}(OrderedDict{String, Any}("left.name" => "Spider man 3", "left.revenue" => 3000000, "left.rotten_tomatos_score" => 2.3, "right.name" => "The super ultra ultra Justice League", "right.number_of_seasons" => 0, "right.is_available" => false )),
    Record{String, Any}(OrderedDict{String, Any}("left.name" => "Iron man 1", "left.revenue" => 45000000, "left.rotten_tomatos_score" => 5.0,  "right.name" => "Rick & Morty", "right.number_of_seasons" => 6 , "right.is_available" => true)),
    Record{String, Any}(OrderedDict{String, Any}("left.name" => "Iron man 1", "left.revenue" => 45000000, "left.rotten_tomatos_score" => 5.0, "right.name" => "The Office", "right.number_of_seasons" => 8, "right.is_available" => true )),
    Record{String, Any}(OrderedDict{String, Any}("left.name" => "Iron man 1", "left.revenue" => 45000000, "left.rotten_tomatos_score" => 5.0, "right.name" => "The super ultra ultra Justice League", "right.number_of_seasons" => 0, "right.is_available" => false)),
    Record{String, Any}(OrderedDict{String, Any}("left.name" => "The Hulk 1", "left.revenue" => 23000000, "left.rotten_tomatos_score" => 4.4, "right.name" => "Rick & Morty", "right.number_of_seasons" => 6 , "right.is_available" => true)),
    Record{String, Any}(OrderedDict{String, Any}("left.name" => "The Hulk 1", "left.revenue" => 23000000, "left.rotten_tomatos_score" => 4.4, "right.name" => "The Office", "right.number_of_seasons" => 8, "right.is_available" => true)),
    Record{String, Any}(OrderedDict{String, Any}("left.name" => "The Hulk 1", "left.revenue" => 23000000, "left.rotten_tomatos_score" => 4.4, "right.name" => "The super ultra ultra Justice League", "right.number_of_seasons" => 0, "right.is_available" => false))
    ]))
end

@testset "union operator tests" begin 
   series_and_movies = union!(project(netflix_series,String["name"]), project(marvel_movies,String["name"]))

   #check the union ha ste correct cardinality
   @test isequal(length(series_and_movies), 6)

   @test isequal(series_and_movies, Set{Record{String,Any}}([
    Record{String, Any}(OrderedDict{String, Any}("name" => "Spider man 3")),
    Record{String, Any}(OrderedDict{String, Any}("name" => "Iron man 1")),
    Record{String, Any}(OrderedDict{String, Any}("name" => "The Hulk 1")),
    Record{String, Any}(OrderedDict{String, Any}("name" => "Rick & Morty")),
    Record{String, Any}(OrderedDict{String, Any}("name" => "The Office")),
    Record{String, Any}(OrderedDict{String, Any}("name" => "The super ultra ultra Justice League"))
   ]))
end

@testset "theta join operator tests" begin
   output_table = thetajoin(clients, tasks, Function[(x,y) -> x["left.id"] == y["right.employe_id"]])

   @test isequal(output_table,Set(Record{String, Any}[Record{String, Any}(OrderedDict{String, Any}("left.id" => 3, "left.name" => "Phil Maguire", 
                                                                    "left.contactid" => 3, "right.id" => 7, "right.employe_id" => 3, "right.completed" => false)), 
                                                      Record{String, Any}(OrderedDict{String, Any}("left.id" => 1, "left.name" => "Lackawanna County", "left.contactid" => 0, 
                                                                    "right.id" => 2, "right.employe_id" => 1, "right.completed" => true)), 
                                                      Record{String, Any}(OrderedDict{String, Any}("left.id" => 1, "left.name" => "Lackawanna County", 
                                                                    "left.contactid" => 0, "right.id" => 4, "right.employe_id" => 1, "right.completed" => true)), 
                                                      Record{String, Any}(OrderedDict{String, Any}("left.id" => 3, "left.name" => "Phil Maguire", "left.contactid" => 3, 
                                                                    "right.id" => 9, "right.employe_id" => 3, "right.completed" => false)), 
                                                      Record{String, Any}(OrderedDict{String, Any}("left.id" => 0, "left.name" => "Dunmore High School", "left.contactid" => 3, 
                                                                    "right.id" => 1, "right.employe_id" => 0, "right.completed" => false)), 
                                                      Record{String, Any}(OrderedDict{String, Any}("left.id" => 3, "left.name" => "Phil Maguire", "left.contactid" => 3, 
                                                                    "right.id" => 8, "right.employe_id" => 3, "right.completed" => true)), 
                                                      Record{String, Any}(OrderedDict{String, Any}("left.id" => 0, "left.name" => "Dunmore High School", "left.contactid" => 3, 
                                                                    "right.id" => 0, "right.employe_id" => 0, "right.completed" => false)), 
                                                      Record{String, Any}(OrderedDict{String, Any}("left.id" => 2, "left.name" => "Mr. Deckert", "left.contactid" => 1, 
                                                                    "right.id" => 5, "right.employe_id" => 2, "right.completed" => true)), 
                                                      Record{String, Any}(OrderedDict{String, Any}("left.id" => 3, "left.name" => "Phil Maguire", "left.contactid" => 3, 
                                                                    "right.id" => 6, "right.employe_id" => 3, "right.completed" => false)), 
                                                      Record{String, Any}(OrderedDict{String, Any}("left.id" => 1, "left.name" => "Lackawanna County", "left.contactid" => 0, 
                                                                    "right.id" => 3, "right.employe_id" => 1, "right.completed" => true))]))

   @test isequal(length(output_table),10)
end

@testset "natural join operator tests" begin
    output_table = naturaljoin(companies,foods)
    #check natural join contains correct attributes
    @test isequal(__ordered_columns_intable(output_table), 
                OrderedSet{String}(String["left.COMPANY_ID", "left.COMPANY_NAME", "left.COMPANY_CITY", "right.ITEM_ID", "right.ITEM_NAME", "right.ITEM_UNIT", "right.COMPANY_ID"]))
    
    @test isequal(output_table, Set{Record{String, Any}}([Record{String, Any}(OrderedDict{String, Any}("left.COMPANY_ID" => 16,"left.COMPANY_NAME" => "Akas Foods",  "left.COMPANY_CITY" => "Delhi" , 
    "right.ITEM_ID" => 1 , "right.ITEM_NAME" =>  "Chex Mix", "right.ITEM_UNIT" => "Pcs" , "right.COMPANY_ID" => 16)),
    Record{String, Any}(OrderedDict{String, Any}("left.COMPANY_ID" => 15,"left.COMPANY_NAME" => "Jack Hill Ltd", "left.COMPANY_CITY" => "London",
                                                 "right.ITEM_ID" => 6, "right.ITEM_NAME" => "Cheez-It", "right.ITEM_UNIT" => "Pcs", "right.COMPANY_ID" => 15)),
    Record{String, Any}(OrderedDict{String, Any}("left.COMPANY_ID" => 15,"left.COMPANY_NAME" => "Jack Hill Ltd", "left.COMPANY_CITY" => "London",
                                                  "right.ITEM_ID" => 2, "right.ITEM_NAME" => "BN Biscuit", "right.ITEM_UNIT" => "Pcs", "right.COMPANY_ID" => 15)),
    Record{String, Any}(OrderedDict{String, Any}("left.COMPANY_ID" => 17,"left.COMPANY_NAME" => "Foodies.", "left.COMPANY_CITY" => "London",
                                                  "right.ITEM_ID" => 3, "right.ITEM_NAME" => "Mighty Munch", "right.ITEM_UNIT" => "Pcs", "right.COMPANY_ID" => 17)),
    Record{String, Any}(OrderedDict{String, Any}("left.COMPANY_ID" => 15,"left.COMPANY_NAME" => "Jack Hill Ltd", "left.COMPANY_CITY" => "London",
                                                  "right.ITEM_ID" => 4, "right.ITEM_NAME" => "Pot Rice", "right.ITEM_UNIT" => "Pcs", "right.COMPANY_ID" => 15)),
    Record{String, Any}(OrderedDict{String, Any}("left.COMPANY_ID" => 18,"left.COMPANY_NAME" => "Order All", "left.COMPANY_CITY" => "Boston",
                                                  "right.ITEM_ID" => 5, "right.ITEM_NAME" => "Jaffa Cakes", "right.ITEM_UNIT" => "Pcs", "right.COMPANY_ID" => 18))
]))
end

