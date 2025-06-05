include("./Jcc.jl")
include("./Endv.jl")

using .Jcc: print, println, prompt, setjccpath
using .Endv: viewfile

function @main(args::Vector{String})::Cint
  if length(args) < 2
    println("Usage: $(args[1]) <input_file>")
    1
  else
    input_file = args[2]
    setjccpath(joinpath(first(splitdir(args[1])), "jcclib.so"))
    viewfile(input_file)
  end
end
