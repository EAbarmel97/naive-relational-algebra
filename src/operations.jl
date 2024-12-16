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

#= """
    project(table::Set{Record{U,V}}, columns::Vector{String})::Set{Record{U,V}}

    Args:
        table: Set[Row]
        columns: List[str], column names to select

    Returns:
        table_out: Set[Row] with only the selected columns.
        
Selects the given columns in the table.        
"""
function project(table::Set{Record{U,V}}, columns::Vector{String})::Set{Record{U,V}}
    table_out = Set{Record{U,V}}(Record({column: record[column] for column in columns}) for record in table)
    return table_out
end

"""
   
    Args:
        **tables: Set[Row]s for which cross-product is to be taken.

    Returns:
        table_out: Set[Row], cross-product of the tables.

Constructs the cross product of tables. Each columnn name will be prefixed with the source table name.
"""
function crossproduct(left::Set[Record], right::Set[Record])::Set[Record]
    # prefixing columns with table name
    left = __prefixcolumns(left, "left")
    right = __prefixcolumns(right, "right")

    table_out = {Record({**row_l, **row_r}) for row_l, row_r in product(left, right)}

    return table_out
end

""" 
    Note: this does not add more expressive power to our already existing operations.
        Intersection can be written as the repeated application of the difference
        operator.

    Args:
        left: Set[Row].
        right: Set[Row].

    Returns:
        table_out: Set[Row], intersection of the input Set[Row]s

Returns the intersection of the tables.        
"""
function intersection(left: Set[Record], right: Set[Record]) -> Set[Record]:
    
    table_out = difference(left, difference(left, right))
    return table_out
end =#