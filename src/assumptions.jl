## Assumptions
## http://docs.sympy.org/0.7.2/modules/assumptions/index.html

"""
refine: http://docs.sympy.org/dev/modules/assumptions/refine.html
"""
refine(ex, assumpts...) = sympy_meth(:refine, ex, assumpts...)
export refine

"""

`ask`. Returns true, false or nothing

Example:

```
ask(Qinteger(x*y), And(Qinteger(x), Qinteger(y)))
## really slow isprime:
filter(x -> ask(Qprime(x)), [1:1000])
```

"""
ask(x::Sym, args...) = sympy_meth(:ask, x, args...)
export ask

## should we support & and | for (sym,sym) pairs? Not sure
## dependso on what happens to | (x==0) and ex == x usage for ==
## for now, we can combine terms logically with And, Or, Not...
## these are in logic module


## simple methods (x, args) -> y (y coercion happens via PyCall)
logic_sympy_methods = (
                     :And, :Or, :Not,
                     :Xor, :Nand, :Nor, :Implies,
                     :Equivalent,
                     :satisfiable
                     )


## We make a module Q to hold the assumptions
## this follows this page http://docs.sympy.org/0.7.5/_modules/sympy/assumptions/ask.html
module Q
import SymPy
import PyCall

##http://docs.sympy.org/dev/_modules/sympy/assumptions/ask.html#ask
Q_predicates = (:antihermitian,
                :bounded, :finite, # bounded deprecated
                :commutative,
#                :complex,
                :composite,
                :even,
                :extended_real,
                :hermitian,
                :imaginary,
                :infinitesimal,
                :infinity, :infinite, # :infinity deprecated
                :integer,
                :irrational,
                :rational,
                :algebraic,
                :transcendental,
                :negative,
                :nonzero, :zero,
                :positive,
                :prime,
                :real,
                :odd,
                :is_true,
                :nonpositive,
                :nonnegative,
                :symmetric,
                :invertible,
                :singular,
                :orthogonal,
                :unitary,
                :normal,
                :positive_definite,
                :upper_triangular,
                :lower_triangular,
                :diagonal,
                :triangular,
                :unit_triangular,
                :fullrank,
                :square,
                :real_elements,
                :complex_elements,
                :integer_elements)

for meth in Q_predicates
        nm = string(meth)
        @eval begin
            @doc """
`$($nm)`: a SymPy function.
The SymPy documentation can be found through: http://docs.sympy.org/latest/search.html?q=$($nm)
""" ->
            ($meth)(x) = PyCall.pycall(SymPy.sympy["Q"][$nm], SymPy.Sym, x)::SymPy.Sym
        end
    end
end




export Q
