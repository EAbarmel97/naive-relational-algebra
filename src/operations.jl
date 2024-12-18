include("tables.jl")

"""
    select(table::Set{Record{U,V}}, conditions::Vector{Function})::Set{Record{U,V}} where {U<:Any, V<:Any}

Filters a set of records based on a list of conditions.

# Arguments
- `table::Set{Record{U,V}}`: Input set of records.
- `conditions::Vector{Function}`: List of conditions to apply to each record.

# Returns
- `Set{Record{U,V}}`: Filtered set of records that satisfy all conditions.
"""
function select(table::Set{Record{U,V}}, conditions::Vector{Function})::Set{Record{U,V}}  where {U<:Any, V<:Any}
    table_out = Set{Record{U,V}}([record for record in table if all([cond(record) for cond in conditions])])
    return table_out
end

"""
    project(table::Set{Record{U,V}}, columns::Vector{String})::Set{Record{U,V}} where {U<:Any, V<:Any}

Selects the given columns in the table.      

# Arguments
- `table::Set{Record{U,V}}`: Input set of records.
- `conditions::Vector{String}`: List of conditions to apply to each record.

# Returns:
- `Set{Record{U,V}}`: Filtered set of records that satisfy all conditions.   
"""
function project(table::Set{Record{U,V}}, columns::Vector{String})::Set{Record{U,V}} where {U<:Any, V<:Any}
    table_out = Set{Record{U,V}}([Record{U,V}(Dict{U,V}(column => record[column] for column in columns)) for record in table])
    return table_out
end

"""
    rename(table::Set{Record{U,V}}, columns::Dict{U,U})::Set{Record{U,V}}

Renames columns in a set of records based on the `columns` mapping.

# Arguments
- `table`: Set of records with column names (`U`) and values (`V`).
- `columns`: Dictionary mapping old column names to new ones.

# Returns
# Returns:
- `Set{Record{U,V}}`: Renamed table

NOTE: Sets in Julia are immutable, so in order to effectively change the `table` you should write table = rename(table, columns)
"""
function rename(table::Set{Record{U,V}}, columns::Dict{U,U})::Set{Record{U,V}} where {U<:Any, V<:Any}
    table_columns = __columnsintable(table)
    table_out = Set{Record{U,V}}([
        Record{U,V}(Dict{U,V}(get(columns, old_column_name, old_column_name) => record[old_column_name] for old_column_name in table_columns)) for record in table
    ])

    return table_out
end

