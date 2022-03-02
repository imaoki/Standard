/*! © 2021 imaoki | MIT License | https://github.com/imaoki */
(
  fileIn "Standard.ms"

  if isProperty ::startupScriptLoader "RegisterScript" do (
    ::startupScriptLoader.RegisterScript (getSourceFileName())
  )
  ok
)
