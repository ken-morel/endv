"""
    module Jcc

A module to provide helpful tools compiling with juliac.
uses jcclib.
"""
module Jcc
jccpath::String = "endv/jcc/jcclib.so"
function setjccpath(path::String)
  global jccpath = path
end


"""
    prompt(prompttext::String, buffersize::Int = 256)::Union{String, Nothing}

"""
function prompt(prompttext::String; buffersize::Int=256)::Union{String,Nothing}
  inputα = C_NULL
  try
    inputα = ccall(
      (:prompt, jccpath),
      Cstring,
      (Cstring, Cint),
      prompttext,
      buffersize
    )
    if inputα == C_NULL
      return nothing
    end
    input = unsafe_string(inputα)
    return input
  catch
    println(Core.stdout, "An error occured")
    return nothing
  finally
    if inputα != C_NULL
      ccall(
        (:free_prompt_input, jccpath),
        Cvoid,
        (Cstring,),
        inputα
      )
    end
  end
end

end
