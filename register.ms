/*! © 2021 imaoki | MIT License | https://github.com/imaoki */
(
  /* 依存無し */
  fileIn "AttributeUtility.ms"
  fileIn "Comparer.ms"
  fileIn "DotNetUtility.ms"
  fileIn "Easing.ms"
  fileIn "Observer.ms"
  fileIn "PathUtility.ms"
  fileIn "ViewportUtility.ms"

  /*
  DotNetUtility
  */
  fileIn "Enum.ms"
  fileIn "Timer.ms"

  /*
  DotNetUtility
  Enum
  */
  fileIn "StringUtility.ms"

  /*
  DotNetUtility
  StringUtility
  */
  fileIn "Encoding.ms"

  /*
  Observer
  StringUtility
  Timer
  */
  fileIn "SystemEventHandler.ms"

  /*
  Comparer
  DotNetUtility
  Encoding
  Enum
  PathUtility
  */
  fileIn "FileUtility.ms"

  if isProperty ::startupScriptLoader "RegisterScript" do (
    ::startupScriptLoader.RegisterScript (getSourceFileName())
    ::startupScriptLoader.Save()
  )
  ok
)
