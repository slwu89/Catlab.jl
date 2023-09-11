# we want to do this to be able to visualize Diagrams as homomorphisms
# of labeled graphs.

using Revise
using Catlab

const SchSGraph = SchSymmetricGraph

# --------------------------------------
# 1. fixing to_graphviz for Diagram type

# Diagram for paths of length 2.
C = FinCat(@acset Graph begin
    V = 3
    E = 2
    src = [1,2]
    tgt = [3,3]
  end)
  D = FinDomFunctor([:E,:E,:V], [:tgt,:src], C, FinCat(SchSGraph))
  d = Diagram{id}(D)

# the old version wont work here because the objects in the 
# indexing category J are not labeled (anonymous). (D: J->C)
to_graphviz(d,node_labels=true,edge_labels=true)

# ---------------------------------------------
# 2. drawing FinFunctors as graph homomorphisms

# this is the info we have in the FinFunctor
dom(diagram(d))
codom(diagram(d))
ob_map(diagram(d))
hom_map(diagram(d))

# furthermore we can get a graph from the dom by
graph(dom(diagram(d)))

# need a function to go from Presentation to Graph
# steal the approach from to_graphviz_property_graph(pres::Presentation...)

pres = presentation(codom(diagram(d)))

g = NamedGraph{String,String}()
obs = generators(pres, :Ob)
add_parts!(g, :V, length(obs), vname=string.(first.(obs)))

homs = generators(pres, :Hom)
add_parts!(
  g, :E, length(homs),
  src=map(f -> generator_index(pres, first(gat_type_args(f))), homs),
  tgt=map(f -> generator_index(pres, last(gat_type_args(f))), homs),
  ename=string.(first.(homs))
)

# now we have a named graph

# -----------------------------------------------------
# 3. drawing natural transformation between FinFunctors