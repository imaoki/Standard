/*! © 2021 imaoki | MIT License | https://github.com/imaoki */
(
  ::comparer = (fileIn "Comparer.ms")()
  format "[define]::comparer\n"

  fileIn "PathUtility.ms"
  format "[define]::PathUtilityStruct\n"

  ::dotNetUtility = (fileIn "DotNetUtility.ms")()
  format "[define]::dotNetUtility\n"

  fileIn "Enum.ms"
  format "[define]::EnumStruct\n"

  ::stringUtility = (fileIn "StringUtility.ms")()
  format "[define]::stringUtility\n"

  fileIn "Encoding.ms"
  format "[define]::EncodingStruct\n"

  ::fileUtility = (fileIn "FileUtility.ms")()
  format "[define]::fileUtility\n"

  fileIn "Observer.ms"
  format "[define]::ObserverStruct\n"

  fileIn "Easing.ms"
  format "[define]::EasingStruct\n"

  fileIn "Timer.ms"
  format "[define]::mxsDotNetTimerTickHandler\n"
  format "[define]::TimerStruct\n"

  (fileIn "SystemEventObserver.ms")()

  ::viewportUtility = (fileIn "ViewportUtility.ms")()
  format "[define]::viewportUtility\n"

  ::attributeUtility = (fileIn "AttributeUtility.ms")()
  format "[define]::attributeUtility\n"

  if isProperty ::startupScriptLoader "RegisterScript" do (
    ::startupScriptLoader.RegisterScript (getSourceFileName())
    ::startupScriptLoader.Save()
  )
  ok
)
