/*! © 2021 imaoki | MIT License | https://github.com/imaoki */
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
  local stringObject = DotNetObject "System.String" ""
  local utf8Object = DotNetObject "System.Text.UTF8Encoding" false
  local shiftJisObject = (DotNetClass "System.Text.Encoding").GetEncoding "shift_jis"

  testDef = fileIn (getFullPath @"..\DotNetUtility.ms")
  testObj = testDef()
  /* Setup End -------------------------------------------------------------- */
  sw.Start()
  /* Test Start ------------------------------------------------------------- */
  /* IsInstanceOf */
  -- True
  actual = ::TestValueStruct (
    testDef.IsInstanceOf "System.String" stringObject
  )
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)

  -- False
  actual = ::TestValueStruct (
    testDef.IsInstanceOf "System.Enum" stringObject
  )
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)

  /* IsSubclassOf */
  -- True
  actual = ::TestValueStruct (
    testDef.IsSubclassOf "System.Text.Encoding" utf8Object
  )
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)

  -- True
  actual = ::TestValueStruct (
    testDef.IsSubclassOf "System.Text.Encoding" shiftJisObject
  )
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)

  -- False
  actual = ::TestValueStruct (
    testDef.IsSubclassOf "System.String" utf8Object
  )
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)

  /* TypeOf */
  -- DotNetClass
  actual = ::TestValueStruct (
    testDef.TypeOf (DotNetClass "System.String")
  ) IgnoreCase:true
  expected = ::TestValueStruct "System.String"
  assert (actual.Equals expected == true)

  -- DotNetObject
  actual = ::TestValueStruct (
    testDef.TypeOf (DotNetObject "System.String" "")
  ) IgnoreCase:true
  expected = ::TestValueStruct "System.String"
  assert (actual.Equals expected == true)

  -- DotNetObject以外
  actual = ::TestValueStruct (testDef.TypeOf "") IgnoreCase:true
  expected = ::TestValueStruct "String"
  assert (actual.Equals expected == true)
  /* Test End --------------------------------------------------------------- */
  sw.Stop()
  /* Teardown Start --------------------------------------------------------- */
  /* Teardown End ----------------------------------------------------------- */
  format "[end %]%ms\n" nowTime (sw.ElapsedMilliseconds as Integer)
  ok
)
