include("./Jcc.jl")
include("./Endv.jl")

using .Jcc

function (@main)(args::Vector{String})
  println(Core.stdout, Jcc.prompt("enter text> "))
  # if length(args) < 2
  #   println("Usage: julia main.jl <input_file>")
  #   return
  # end
  # input_file = args[2]
  # try
  #   data = read(input_file, String)
  #   println("File content:")
  #   println(data)
  # catch e
  #   println("Error reading file: ", e)
  # end
end
