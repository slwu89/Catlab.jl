module TestNamedGraphs
using Test

using Catlab.Graphs

# Basic graphs
##############

g = path_graph(Graph, 3)
@test !has_vertex_names(g)
@test !has_edge_names(g)
@test vertex_name(g, 2) == 2
@test vertex_named(g, 2) == 2
@test edge_name(g, 1) == 1
@test edge_named(g, 1) == 1

# Named graphs
##############

g = path_graph(NamedGraph{Symbol,Symbol}, 3,
               V=(vname=[:x,:y,:z],), E=(ename=[:f,:g],))
@test has_vertex_names(g)
@test has_edge_names(g)
@test vertex_name(g, 2) == :y
@test vertex_named(g, :y) == 2
@test edge_name(g, 1) == :f
@test edge_named(g, :f) == 1

# Named graph from Presentation
###############################

g = NamedGraphs.graph(SchWeightedGraph)
@test g isa NamedGraph
@test vertex_name(g) == [:V,:E]
@test edge_name(g) == [:src,:tgt]
@test g[:,:src] = [2,2]
@test g[:,:tgt] = [1,1]

g = NamedGraphs.graph(SchWeightedGraph, :Ob, :Hom)
@test g isa NamedGraph
@test vertex_name(g) == [:V,:E]
@test edge_name(g) == [:src,:tgt]
@test g[:,:src] = [2,2]
@test g[:,:tgt] = [1,1]

end
