using OrderedCollections

struct Record{U<:Any, V<:Any} 
    dict::OrderedDict{U,V}
end

function Base.hash(r::Record{U, V}) where {U<:Any, V<:Any}
    proxy = collect(r.dict)
    return hash(proxy)
end

function Base.getindex(r::Record{U, V}, key::U)::V where {U<:Any, V<:Any}
   return r.dict[key]
end

function Base.keys(r::Record{U, V})::Set{U} where {U<:Any, V<:Any}
    return keys(r.dict)
end

function Base.:(==)(r1::Record{U, V}, r2::Record{U, V})::Bool where {U<:Any, V<:Any}
   return r1.dict == r2.dict 
end

function __columnsintable(table::Set{Record{U,V}})::Set{U} where {U<:Any, V<:Any}
    return union!([keys(record) for record in table])
end 

function __ordered_columns_intable(table::Set{Record{U,V}})::OrderedSet{U} where {U<:Any, V<:Any}
    return OrderedSet{U}(collect(keys(first(table).dict)))
end

function __padtable(table::Set{Record{U,V}}, with_cols::Vector{U})::Set{Set{Record{U,V}}} where {U<:Any, V<:Any}
    padding_row = Dict{U, Any}(col =>  nothing for col in with_cols)
    padded_table = Set{Record{U,V}}([Record{U,V}(merge(row, padding_row)) for row in table])
    return padded_table
end   