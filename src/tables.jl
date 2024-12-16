using Printf

struct Record{U<:Any, V<:Any} 
    dict::Dict{U,V}
end

function Base.hash(r::Record{U, V}) where {U<:Any, V<:Any}
    proxy = collect(r.dict)
    return hash(proxy)
end

function Base.getindex(r::Record{U, V}, key::U)::V where {U<:Any, V<:Any}
   return r.dict[key]
end

function Base.:(==)(r1::Record{U, V}, r2::Record{U, V})::Bool where {U<:Any, V<:Any}
   return r1.dict == r2.dict 
end

#= function __columnsintable(table::Set{Record{U,V}})::Set{Record{U,V}}
    return union!([Set{Record{U,V}}([record.keys()]) for record in table]...)
end

function __prefixrecord(row::Dict, prefix::String)::Record
    return Record({f"{prefix}.{key}": value for key, value in row.items()})
end

function __prefixcolumns(table::Set[Record], prefix::String)::Set{Record{U,V}}
    return Set{Record{U,V}}(__prefixrecord(row, prefix) for row in table)
end

function __padtable(table::Set{Record{U,V}}, withcols::Vector{U})::Set{Record{U,V}}
    padding_row = Set{Record{U,V}}(col::Nothing for col in with_cols)
    padded_table = Set{Record({**row, **padding_row}) for row in table}
    return padded_table
end   =#  