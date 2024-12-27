using OrderedCollections

include("../src/tables.jl")

function employe(id::Int64, name::String, position::String, salary::Int64)::Record{String, Any}
    return Record{String, Any}(OrderedDict{String,Any}("id" => id, "name" => name, "position"  => position, "salary"  => salary))
end

function task(id::Int64, employe_id::Int64, completed::Bool)::Record{String, Any}
    return Record{String, Any}(OrderedDict{String, Any}("id"  => id , "employe_id"  => employe_id, "completed"  => completed))
end

function client(id::Int64, name::String, contactid::Int64)::Record{String, Any}
    return Record{String, Any}(OrderedDict{String,Any}("id"  => id,  "name" => name, "contactid"  => contactid))
end

function food(item_id::Int64, item_name::String, item_unit::String, company_id)::Record{String, Any}
   return Record{String, Any}(OrderedDict{String, Any}("ITEM_ID" => item_id, "ITEM_NAME"  => item_name, "ITEM_UNIT" => item_unit, "COMPANY_ID" => company_id))
end

function company(company_id::Int64, company_name::String, company_city::String)::Record{String, Any}
   return Record{String, Any}(OrderedDict{String, Any}("COMPANY_ID" => company_id, "COMPANY_NAME"  => company_name, "COMPANY_CITY" => company_city))
end

employees = Set{Record{String, Any}}([employe(0, "Michael Scott", "Regional Manager", 100000),
             employe(1, "Dwight K. Schrute", "Assistant to the Regional Manager", 65000),
             employe(2, "Pamela Besly", "Sales", 40000),
             employe(3, "James Halpert", "Sales", 55000),
             employe(4, "Stanley Hudson", "Sales", 55000)])


tasks = Set{Record{String, Any}}([task(0, 0, false),
         task(1, 0, false),
         task(2, 1, true),
         task(3, 1, true),
         task(4, 1, true),
         task(5, 2, true),
         task(6, 3, false),
         task(7, 3, false),
         task(8, 3, true),
         task(9, 3, false)
        ])


clients = Set{Record{String, Any}}([client(0, "Dunmore High School", 3),
           client(1, "Lackawanna County", 0),
           client(2, "Mr. Deckert", 1),
           client(3, "Phil Maguire", 3),
           client(4, "Harper Collins", 1),
           client(5, "Apex Technology", 1)
        ])
           
marvel_movies = Set{Record{String,Any}}([
            Record{String, Any}(OrderedDict{String, Any}("name" => "Spider man 3", "revenue" => 3000000, "rotten_tomatos_score" => 2.3)),
            Record{String, Any}(OrderedDict{String, Any}("name" => "Iron man 1", "revenue" => 45000000, "rotten_tomatos_score" => 5.0 )),
            Record{String, Any}(OrderedDict{String, Any}("name" => "The Hulk 1", "revenue" => 23000000, "rotten_tomatos_score" => 4.4 ))
           ])          
            
netflix_series = Set{Record{String,Any}}([
            Record{String, Any}(OrderedDict{String, Any}("name" => "Rick & Morty", "number_of_seasons" => 6 , "is_available" => true)),
            Record{String, Any}(OrderedDict{String, Any}("name" => "The Office", "number_of_seasons" => 8, "is_available" => true )),
            Record{String, Any}(OrderedDict{String, Any}("name" => "The super ultra ultra Justice League", "number_of_seasons" => 0, "is_available" => false ))
           ])
           
foods =  Set{Record{String,Any}}([food(1,"Chex Mix", "Pcs", 16),
          food(6,"Cheez-It", "Pcs", 15),
          food(2,"BN Biscuit", "Pcs", 15),
          food(3,"Mighty Munch", "Pcs", 17),
          food(4,"Pot Rice", "Pcs", 15),
          food(5,"Jaffa Cakes", "Pcs", 18),
          food(7,"Salt n Shake", "Pcs", -1)
        ]) 

companies = Set{Record{String,Any}}([company(18, "Order All", "Boston"),
            company(15, "Jack Hill Ltd", "London"),
            company(16, "Akas Foods", "Delhi"),
            company(17, "Foodies.", "London"),
            company(19, "sip-n-Bite.", "New York")
        ]) 