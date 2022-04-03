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
  testDef = ::standardDefinitionPool[@"Observable.ms"]
  testObj = testDef()
  /* Setup End -------------------------------------------------------------- */
  sw.Start()
  /* Test Start ------------------------------------------------------------- */
  /* Count */
  -- 既定値
  actual = ::TestValueStruct (testObj.Count())
  expected = ::TestValueStruct 0
  assert (actual.Equals expected == true)

  /* Subscribe */
  -- 無効な値
  actual = ::TestValueStruct (testObj.Subscribe 0)
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)
  -- 成功
  actual = ::TestValueStruct (testObj.Subscribe testNotification)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- 数を確認
  actual = ::TestValueStruct (testObj.Count())
  expected = ::TestValueStruct 1
  assert (actual.Equals expected == true)
  -- 重複登録は出来ないが登録済みなので成功
  actual = ::TestValueStruct (testObj.Subscribe testNotification)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- 数を確認
  actual = ::TestValueStruct (testObj.Count())
  expected = ::TestValueStruct 1
  assert (actual.Equals expected == true)

  /* Unsubscribe */
  -- 成功
  actual = ::TestValueStruct (testObj.Unsubscribe testNotification)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- 数を確認
  actual = ::TestValueStruct (testObj.Count())
  expected = ::TestValueStruct 0
  assert (actual.Equals expected == true)

  /* 購読 */
  actual = ::TestValueStruct (testObj.Subscribe testNotification)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)

  -- testObj.Dump()

  /* Notify */
  expectedParam = 0
  expectedType = #Test
  actual = ::TestValueStruct (testObj.Notify #Test 0)
  expected = ::TestValueStruct ok
  assert (actual.Equals expected == true)
  /* Test End --------------------------------------------------------------- */
  sw.Stop()
  /* Teardown Start --------------------------------------------------------- */
  /* Teardown End ----------------------------------------------------------- */
  format "[end %]%ms\n" nowTime (sw.ElapsedMilliseconds as Integer)
  ok
)
