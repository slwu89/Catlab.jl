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

F = diagram(d)

# furthermore we can get a graph from the dom by
g = graph(dom(F))
g_named = NamedGraph{Symbol,Symbol}()
add_vertices!(g_named, nv(g), vname=Symbol.(1:nv(g)))
add_edges!(g_named, src(g), tgt(g), ename=Symbol.(1:ne(g)))

# need a function to go from Presentation to Graph
# steal the approach from to_graphviz_property_graph(pres::Presentation...)

# h is the named graph representing the codom
pres = presentation(codom(F))

h = NamedGraph{Symbol,Symbol}()
obs = generators(pres, :Ob)
add_parts!(h, :V, length(obs), vname=first.(obs))

homs = generators(pres, :Hom)
add_parts!(
  h, :E, length(homs),
  src=map(f -> generator_index(pres, first(gat_type_args(f))), homs),
  tgt=map(f -> generator_index(pres, last(gat_type_args(f))), homs),
  ename=first.(homs)
)

# now we have a named graph, what can we do with it?
# I guess we can make a graph homomorphism

F_ob_map = only.(incident(h,first.(ob_map(F)),:vname))
F_hom_map = only.(incident(h,first.(hom_map(F)),:ename))

g_2_h = ACSetTransformation(
  g_named,h;
  V=FinFunction(F_ob_map, nv(g), nv(h)),
  E=FinFunction(F_hom_map, ne(g), ne(h))
)

# kind of works
to_graphviz(g_2_h,node_labels=:vname,edge_labels=:ename,node_colors=true,edge_colors=true)

# -----------------------------------------------------
# 3. drawing natural transformation between FinFunctors