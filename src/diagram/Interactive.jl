module Interactive
export TikzPicture

import Base: show
using ...Catlab

import ..TikZ
@optional_import import TikzPictures: TikzPicture

""" Convert our TikZ picture type to `TikzPicture`'s picture type. 
"""
function TikzPicture(pic::TikZ.Picture; preamble::String="", usePDF2SVG=true)::TikzPicture
  data = join(sprint(TikZ.pprint, stmt) for stmt in pic.stmts)
  options = join((sprint(TikZ.pprint, prop) for prop in pic.props), ",")
  preamble = join([
    preamble,
    "\\usepackage{amssymb}",
    # FIXME: These TikZ library dependencies should be stored in TikZ.Picture.
    "\\usetikzlibrary{arrows.meta}",
    "\\usetikzlibrary{calc}",
    "\\usetikzlibrary{decorations.markings}",
    "\\usetikzlibrary{positioning}",
    "\\usetikzlibrary{shapes.geometric}",
  ], "\n")
  TikzPicture(data; options=options, preamble=preamble, usePDF2SVG=usePDF2SVG)
end

function show(io::IO, ::MIME"image/svg+xml", pic::TikZ.Picture)
  show(io, MIME"image/svg+xml"(), TikzPicture(pic))
end

end
