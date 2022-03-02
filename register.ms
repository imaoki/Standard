/*! © 2021 imaoki | MIT License | https://github.com/imaoki */
(
  fileIn "Standard.ms"

  if isProperty ::startupLoader "RegisterScript" do (
    ::startupLoader.RegisterScript (getSourceFileName())
  )
  ok
)
