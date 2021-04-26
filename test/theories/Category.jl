using Test

# Category
##########

A, B = Ob(FreeCategory, :A), Ob(FreeCategory, :B)
f, g = Hom(:f, A, B), Hom(:g, B, A)

# Expression types
@test isa(A, FreeCategory.Ob) && isa(f, FreeCategory.Hom)
@test isa(A, ObExpr) && isa(f, HomExpr)
@test isa(A, CategoryExpr) && isa(f, CategoryExpr)

# Domains and codomains
@test dom(f) == A
@test codom(f) == B
@test dom(compose(f,g)) == A
@test codom(compose(f,g)) == A
@test_throws SyntaxDomainError compose(f,f)

# Associativity
@test compose(compose(f,g),f) == compose(f,compose(g,f))

# Extra syntax
@test compose(f,g,f) == compose(compose(f,g),f)
@test compose([f,g,f]) == compose(compose(f,g),f)
@test f⋅g == compose(f,g)
@test f⋅g⋅f⋅g == compose(f,g,f,g)

# String format
@test string(A) == "A"
@test string(f) == "f"
@test string(compose(f,g)) == "compose(f,g)"
@test string(compose(f,g,f)) == "compose(f,g,f)"
@test string(Ob(FreeCategory, nothing)) != ""

# S-expressions
@test sexpr(A) == ":A"
@test sexpr(f) == ":f"
@test sexpr(compose(f,g)) == "(compose :f :g)"
@test sexpr(compose(f,g,f)) == "(compose :f :g :f)"

# Infix notation (Unicode)
@test unicode(A) == "A"
@test unicode(A, all=true) == "A"
@test unicode(f) == "f"
@test unicode(f, all=true) == "f: A → B"
@test unicode(id(A)) == "id{A}"
@test unicode(compose(f,g)) == "f⋅g"

# Infix notation (LaTeX)
@test latex(A) == "A"
@test latex(A, all=true) == raw"$A$"
@test latex(f) == "f"
@test latex(f, all=true) == raw"$f : A \to B$"
@test latex(id(A)) == "\\mathrm{id}_{A}"
@test latex(compose(f,g)) == "f \\cdot g"

@test latex(Ob(FreeCategory, "x")) == "x"
@test latex(Ob(FreeCategory, "sin")) == "\\mathrm{sin}"
@test latex(Ob(FreeCategory, "\\alpha")) == "\\alpha"

# (Co)presheaf
##############

A, B = Ob(FreePresheaf, :A, :B)
f = Hom(:f, A, B)
x = El(:x, B)
@test ob(x) == B
@test ob(coact(f, x)) == A
@test f ⋅ x == coact(f, x)

A, B = Ob(FreeCopresheaf, :A, :B)
f = Hom(:f, A, B)
x = El(:x, A)
@test ob(x) == A
@test ob(act(x, f)) == B
@test x ⋅ f == act(x, f)

# Infix notation (Unicode)
@test unicode(x) == "x"
@test unicode(x, all=true) == "x: A"
@test unicode(act(x, f)) == "x⋅f"
@test unicode(act(x, f), all=true) == "x⋅f: B"

# Infix notation (LaTeX)
@test latex(x) == "x"
@test latex(x, all=true) == raw"$x : A$"
@test latex(act(x, f)) == raw"x \cdot f"
@test latex(act(x, f), all=true) == raw"$x \cdot f : B$"
