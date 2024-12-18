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

function Base.keys(r::Record{U, V})::Set{U} where {U<:Any, V<:Any}
    return keys(r.dict)
end

function Base.:(==)(r1::Record{U, V}, r2::Record{U, V})::Bool where {U<:Any, V<:Any}
   return r1.dict == r2.dict 
end

function __columnsintable(table::Set{Record{U,V}})::Set{U} where {U<:Any, V<:Any}
    return union!([keys(record) for record in table]...)
end 