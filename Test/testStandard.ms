/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
(
  -- clearListener()

  local nowTime = (DotNetClass "System.DateTime").Now.ToString "HH:mm:ss"
  local sw = DotNetObject "System.Diagnostics.Stopwatch"

  local environmentClass = DotNetClass "System.Environment"
  local pathClass = DotNetClass "System.IO.Path"

  local currentFile = getSourceFileName()
  local currentDir = pathClass.GetDirectoryName currentFile

  local getFullPath
  fn getFullPath path = (
    environmentClass.CurrentDirectory = currentDir
    pathClass.GetFullPath path
  )

  local actual
  local expected
  local testDef
  local testObj

  format "[run %]@\"%\"\n" nowTime currentFile
  /* Setup Start ------------------------------------------------------------ */
  local testStructDefinition
  fn testStructDefinition obj expectedStructName = (
    local passCount = 0
    actual = ::TestValueStruct (isStructDef obj)
    expected = ::TestValueStruct true
    if assert (actual.Equals expected == true) do passCount += 1
    actual = ::TestValueStruct (isProperty obj #StructName)
    expected = ::TestValueStruct true
    if assert (actual.Equals expected == true) do passCount += 1
    actual = ::TestValueStruct (classOf obj.StructName)
    expected = ::TestValueStruct MAXScriptFunction
    if assert (actual.Equals expected == true) do passCount += 1
    actual = ::TestValueStruct (obj.StructName())
    expected = ::TestValueStruct expectedStructName
    if assert (actual.Equals expected == true) do passCount += 1
    passCount == 4
  )

  local testStructInstance
  fn testStructInstance obj expectedStructName = (
    local passCount = 0
    actual = ::TestValueStruct (isStruct obj)
    expected = ::TestValueStruct true
    if assert (actual.Equals expected == true) do passCount += 1
    actual = ::TestValueStruct (isProperty obj #StructName)
    expected = ::TestValueStruct true
    if assert (actual.Equals expected == true) do passCount += 1
    actual = ::TestValueStruct (classOf obj.StructName)
    expected = ::TestValueStruct MAXScriptFunction
    if assert (actual.Equals expected == true) do passCount += 1
    actual = ::TestValueStruct (obj.StructName())
    expected = ::TestValueStruct expectedStructName
    if assert (actual.Equals expected == true) do passCount += 1
    passCount == 4
  )

  testDef = fileIn (getFullPath @"..\Standard.ms")
  testObj = testDef()
  /* Setup End -------------------------------------------------------------- */
  sw.Start()
  /* Test Start ------------------------------------------------------------- */
  /* AttributeUtility */
  assert (testStructInstance testObj.AttributeUtility #AttributeUtilityStruct)

  /* Comparer */
  assert (testStructInstance testObj.Comparer #ComparerStruct)

  /* ConfigStruct */
  assert (testStructDefinition testObj.ConfigStruct #ConfigStruct)

  /* DialogStruct */
  assert (testStructDefinition testObj.DialogStruct #DialogStruct)

  /* DotNetUtility */
  assert (testStructInstance testObj.DotNetUtility #DotNetUtilityStruct)

  /* EasingStruct */
  assert (testStructDefinition testObj.EasingStruct #EasingStruct)

  /* EncodingStruct */
  assert (testStructDefinition testObj.EncodingStruct #EncodingStruct)

  /* EnumStruct */
  assert (testStructDefinition testObj.EnumStruct #EnumStruct)

  /* FileUtility */
  assert (testStructInstance testObj.FileUtility #FileUtilityStruct)

  /* ObservableStruct */
  assert (testStructDefinition testObj.ObservableStruct #ObservableStruct)

  /* PathUtilityStruct */
  assert (testStructDefinition testObj.PathUtilityStruct #PathUtilityStruct)

  /* StringUtility */
  assert (testStructInstance testObj.StringUtility #StringUtilityStruct)

  /* TimerStruct */
  assert (testStructDefinition testObj.TimerStruct #TimerStruct)

  /* ViewportUtility */
  assert (testStructInstance testObj.ViewportUtility #ViewportUtilityStruct)
  /* Test End --------------------------------------------------------------- */
  sw.Stop()
  /* Teardown Start --------------------------------------------------------- */
  /* Teardown End ----------------------------------------------------------- */
  format "[end %]%ms\n" nowTime (sw.ElapsedMilliseconds as Integer)
  ok
)
