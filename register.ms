/*! © 2021 imaoki | MIT License | https://github.com/imaoki */
(
  fileIn "Standard.ms"

  if isProperty ::startupLoader "RegisterFile" do (
    ::startupLoader.RegisterFile (getSourceFileName())
  )
  ok
)
