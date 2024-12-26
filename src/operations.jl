using Base.Iterators

include("tables.jl")

"""
    select(table::Set{Record{String,V}}, conditions::Vector{Function})::Set{Record{String,V}} where V<:Any 

Filters a set of records based on a list of conditions.

# Arguments
- `table::Set{Record{String,V}}`: Input set of records.
- `conditions::Vector{Function}`: List of conditions to apply to each record.

# Returns
- `Set{Record{String,V}}`: Filtered set of records that satisfy all conditions.
"""
function select(table::Set{Record{String,V}}, conditions::Vector{Function})::Set{Record{String,V}}  where V<:Any
    table_out = Set{Record{String,V}}([record for record in table if all([cond(record) for cond in conditions])])
    return table_out
end

"""
    project(table::Set{Record{String,V}}, columns::Vector{String})::Set{Record{String,V}} where V<:Any

Selects the given columns in the table.      

# Arguments
- `table::Set{Record{String,V}}`: Input set of records.
- `conditions::Vector{String}`: List of conditions to apply to each record.

# Returns:
- `Set{Record{String,V}}`: Filtered set of records that satisfy all conditions.   
"""
function project(table::Set{Record{String,V}}, columns::Vector{String})::Set{Record{String,V}} where V<:Any
    table_out = Set{Record{String,V}}([Record{String,V}(OrderedDict{String,V}(column => record[column] for column in columns)) for record in table])
    return table_out
end

"""
    rename(table::Set{Record{String,V}}, columns::Dict{String,String})::Set{Record{String,V}} where V<:Any

Renames columns in a set of records based on the `columns` mapping.

# Arguments
- `table`: Set of records with column names (`String`) and values (`V`).
- `columns`: Dictionary mapping old column names to new ones.

# Returns:
- `Set{Record{String,V}}`: Renamed table

NOTE: Sets in Julia are immutable, so in order to effectively change the `table` you should write `table = rename(table, columns)`
"""
function rename(table::Set{Record{String,V}}, columns::Dict{String,String})::Set{Record{String,V}} where V<:Any
    table_columns = __ordered_columns_intable(table)
  
    table_out = Set{Record{String,V}}([
        Record{String,V}(OrderedDict{String,V}(get(columns, old_column_name, old_column_name) => record[old_column_name] for old_column_name in table_columns)) for record in table
    ])

    return table_out
end

function __prefixrecord(row::Record{String,V}, prefix::String)::Record{String,V} where V<:Any
    return Record{String,V}(OrderedDict{String,V}("$(prefix).$(key)" => value for (key, value) in row.dict))
end

function __prefixcolumns(table::Set{Record{String,V}}, prefix::String)::Set{Record{String,V}} where V<:Any
    return Set{Record{String,V}}([__prefixrecord(row, prefix) for row in table])
end

"""
   cartesianproduct(left::Set{Record{String,V}}, right::Set{Record{String,V}})::Set{Record{String,V}} where V<:Any

Compute the cross product of two sets of records, prefixing column names with table names.

# Arguments
- `left::Set{Record{String,V}}`: The first set of records.
- `right::Set{Record{String,V}}`: The second set of records.

# Returns
`Set{Record{String,V}}`: A set of records representing the cartesian product, 
with column names prefixed by "left" and "right".
"""  
function cartesianproduct(left::Set{Record{String,V}}, right::Set{Record{String,V}})::Set{Record{String,V}} where V<:Any
    # prefixing columns with table name
    left = __prefixcolumns(left, "left")
    right = __prefixcolumns(right, "right")

    table_out = Set{Record{String,V}}([Record{String,V}(merge(row_l.dict,row_r.dict)) for (row_l, row_r) in Base.Iterators.product(left, right)])
    return table_out
end

function diference(left::Set{Record{String,V}}, right::Set{Record{String,V}})::Set{Record{String,V}} where V<:Any
   return setdiff(left, right)
end

"""
    intersection(left::Set{Record{String,V}}, right::Set{Record{String,V}})::Set{Record{String,V}} where V<:Any

Returns the intersection of the tables.

# Args:
- `left::Set{Record{String,V}}`: The first set of records.
- `right::Set{Record{String,V}}`: The second set of records

# Returns:
`Set{Record{String,V}}`: intersection of the input tables

Note: this does not add more expressive power to our already existing operations. Intersection can be written as 
the repeated application of the difference operator.
"""
function intersection(left::Set{Record{String,V}}, right::Set{Record{String,V}})::Set{Record{String,V}} where V<:Any
    table_out = difference(left, difference(left, right))
    return table_out
end

"""
   union!(left::Set{Record{String,V}}, right::Set{Record{String,V}})::Set{Record{String,V}} where V<:Any

Returns the union of the tables.

# Arguments
- `left::Set{Record{String,V}}`: The first set of records.
- `right::Set{Record{String,V}}`: The second set of records.

# Returns
`Set{Record{String,V}}`: A set of records representing the union, of the "left" and "right" tables.

Note: this is not the usual set-theoretic union, since duplicates are allowed.
"""
function union!(left::Set{Record{String,V}}, right::Set{Record{String,V}})::Set{Record{String,V}} where V<:Any
    # padding
    left_cols = __columnsintable(left)
    right_cols = __columnsintable(right)

    left = __padtable(left, setdiff(right_cols, left_cols))
    right = __padtable(right, setdiff(left_cols, right_cols))

    table_out = union(left, right)

    return table_out
end
