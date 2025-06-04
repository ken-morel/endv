"""
    function buildjcc()::Cint

build jcc library with clang.
"""
function buildjcc()::Cint
  jccsource = "lib/jcclib/jcclib.c"
  output = "endv/jcc/jcclib.so"
  println(Core.stdout, "Compiling jcclib.c...")
  try
    mkpath(dirname(output))
    run(
      `clang \
        -O3 -fPIC -Wall -Wextra -pedantic -shared $jccsource \
        -o $output -Wl,-soname,jcclib`
    )
    println(Core.stdout, "Compiled succescully, listing methods...")
    try
      run(`nm $output`)
      0
    catch
      println(Core.stdout, "Error listing methods in jcclib.o")
      5
    end
  catch
    println(Core.stdout, "Error compiling jcclib.c")
    1
  end
end

function runendv()::Cint
  try
    run(`julia src/main.jl`)
    0
  catch
    println(Core.stdout, "Error running Endv: ")
    3
  end
end

function trimpile()::Cint
  try
    run(`julia +nightly juliac/juliac.jl --experimental --output-exe endv --trim src/main.jl`)
    0
  catch
    println(Core.stdout, "Error running trimpile: ")
    4
  end
end

function (@main)(args::Vector{String})::Cint
  if length(args) < 1
    println(Core.stdout, "Usage: $(args[1]) command")
    1
  else
    command = args[end]
    if command == "buildjcc"
      buildjcc()
    elseif command == "run"
      runendv()
    elseif command == "trimpile"
      trimpile()
    else
      println(Core.stdout, "Unknown command: ", command)
      2
    end
  end

end
