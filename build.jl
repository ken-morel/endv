"""
    function buildjcc()::Cint

build jcc library with clang.
"""
function buildjcc()::Cint
  jccsource = "lib/jcclib/jcclib.c"
  output = "jcclib.so"
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

function buildnrun(args::Vector{String})::Cint
  buildjcc()
  @time trimpile()
  println(Core.stdout, "Running endv with args $args")
  try
    run(`./endv $args`)
    0
  catch
    println(Core.stdout, "could not run endv")
    10
  end
end

function runendv()::Cint
  println(Core.stdout, "running with julia")
  try
    run(`julia src/main.jl`)
    0
  catch
    println(Core.stdout, "Error running Endv: ")
    3
  end
end

function trimpile()::Cint
  println(Core.stdout, "trimpiling")
  try
    run(`julia +nightly juliac/juliac.jl --experimental --output-exe endv --trim=safe src/main.jl`)
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
    command = args[1]
    @time if command == "buildjcc"
      buildjcc()
    elseif command == "run"
      runendv()
    elseif command == "trimpile"
      trimpile()
    elseif command == "buildnrun"
      buildnrun(args[2:end])
    else
      println(Core.stdout, "Unknown command: ", command)
      2
    end
  end

end
