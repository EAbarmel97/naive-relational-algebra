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
         task(9, 3, false)])


clients = Set{Record{String, Any}}([client(0, "Dunmore High School", 3),
           client(1, "Lackawanna County", 0),
           client(2, "Mr. Deckert", 1),
           client(3, "Phil Maguire", 3),
           client(4, "Harper Collins", 1),
           client(5, "Apex Technology", 1)])
