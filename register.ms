/*! © 2021 imaoki | MIT License | https://github.com/imaoki */
(
  global comparer = (fileIn "Comparer.ms")()
  format "[define]::comparer\n"

  fileIn "PathUtility.ms"
  format "[define]::PathUtilityStruct\n"

  global dotNetUtility = (fileIn "DotNetUtility.ms")()
  format "[define]::dotNetUtility\n"

  fileIn "Enum.ms"
  format "[define]::EnumStruct\n"

  global stringUtility = (fileIn "StringUtility.ms")()
  format "[define]::stringUtility\n"

  fileIn "Encoding.ms"
  format "[define]::EncodingStruct\n"

  global fileUtility = (fileIn "FileUtility.ms")()
  format "[define]::fileUtility\n"

  fileIn "Observer.ms"
  format "[define]::ObserverStruct\n"

  fileIn "Easing.ms"
  format "[define]::EasingStruct\n"

  global viewportUtility = (fileIn "ViewportUtility.ms")()
  format "[define]::viewportUtility\n"

  if isProperty ::startupScriptLoader "RegisterScript" do (
    ::startupScriptLoader.RegisterScript (getSourceFileName())
    ::startupScriptLoader.Save()
  )
  ok
)
