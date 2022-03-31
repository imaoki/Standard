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
  local expectedParam = undefined
  local expectedType = undefined

  local testNotification
  fn testNotification type param = (
    -- format "testNotification type:% param:%\n" type param
    actual = ::TestValueStruct type
    expected = ::TestValueStruct expectedType
    assert (actual.Equals expected == true)
    case type of (
      (#Test): (
        actual = ::TestValueStruct param
        expected = ::TestValueStruct expectedParam
        assert (actual.Equals expected == true)
      )
      default: ()
    )
    ok
  )

  fileIn (getFullPath @"..\definitionPool.ms")
  testDef = ::standardDefinitionPool[@"Observer.ms"]
  testObj = testDef testNotification
  /* Setup End -------------------------------------------------------------- */
  sw.Start()
  /* Test Start ------------------------------------------------------------- */
  /* Update */
  expectedParam = 0
  expectedType = #Test
  actual = ::TestValueStruct (testObj.Update #Test 0)
  expected = ::TestValueStruct ok
  assert (actual.Equals expected == true)

  /* Equals */
  -- 等しくない
  actual = ::TestValueStruct testObj
  expected = ::TestValueStruct (testDef())
  assert (actual.Equals expected == false)
  -- 等しい
  actual = ::TestValueStruct testObj
  expected = ::TestValueStruct (testDef testNotification)
  assert (actual.Equals expected == true)
  /* Test End --------------------------------------------------------------- */
  sw.Stop()
  /* Teardown Start --------------------------------------------------------- */
  /* Teardown End ----------------------------------------------------------- */
  format "[end %]%ms\n" nowTime (sw.ElapsedMilliseconds as Integer)
  ok
)
