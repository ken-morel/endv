"""
    module Jcc

A module to provide helpful tools compiling with juliac.
uses jcclib.
"""
module Jcc
export setjccpath, prompt, print, println

jccpath::String = "./jcclib.so"
function setjccpath(path::String)
  global jccpath = path
end

println(txt) = Base.println(Core.stdout, txt)
print(txt) = Base.print(Core.stdout, txt)


"""
    prompt(prompttext::String, buffersize::Int = 256)::Union{String, Nothing}

"""
function prompt(prompttext::String; buffersize::Int=256)::Union{String,Nothing}
  # inputα = C_NULL
  # @ccall printf(prompttext::String)::Cint
  # bufferbytesize = buffersize * sizeof(Cchar)
  # inputα = @ccall malloc(bufferbytesize)::Cstring
  # if inputα == C_NULL
  #   return nothing
  # end
  # fgetresult = @ccall fgets(inputα::Cstring, buffersize::Cint)
  inputα = C_NULL
  try
    inputα::Cstring = ccall(
      (:prompt, jccpath),
      Cstring,
      (Cstring, Cint),
      prompttext,
      buffersize
    )::Cstring
    if inputα == C_NULL
      println(Core.stdout, "Got no input from jcclib")
      nothing
    else
      input::String = unsafe_string(inputα)
      ccall( #free the C pointer, not knowing how to do in julia yet.
        (:free_prompt_input, jccpath),
        Cvoid,
        (Cstring,),
        inputα
      )
      input
    end
  catch
    println(Core.stdout, "An error occured calling c library, check it is at $jccpath")
    nothing
  end
end

"""
    function system(command::String)

just call c system.
"""
function system(command::String)
  @ccall system(command::Cstring)::Cvoid
end

shellescape(part::String)::String = "'$part'"

function system(cmd::Vector{<:Any})
  command = join(cmd .|> String .|> shellescape, " ")
  Base.println(Core.stdout, "running $command")

  system(command)
  0
end


end
