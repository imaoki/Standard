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
  local items = #()

  fileIn (getFullPath @"..\definitionPool.ms")
  testDef = ::standardDefinitionPool[@"ArrayUtility.ms"]
  testObj = testDef()
  /* Setup End -------------------------------------------------------------- */
  sw.Start()
  /* Test Start ------------------------------------------------------------- */
  /* MoveItems */
  -- 無効な値（items）
  actual = ::TestValueStruct (testDef.MoveItems 0 #() 1)
  expected = ::TestValueStruct #()
  assert (actual.Equals expected == true)
  -- 無効な値（itemsの要素数が一つ以下）
  actual = ::TestValueStruct (testDef.MoveItems #(1) #() 1)
  expected = ::TestValueStruct #()
  assert (actual.Equals expected == true)
  -- 無効な値（targetIndices）
  actual = ::TestValueStruct (testDef.MoveItems #(1, 2) 0 1)
  expected = ::TestValueStruct #()
  assert (actual.Equals expected == true)
  -- 無効な値（destination）
  actual = ::TestValueStruct (testDef.MoveItems #(1, 2) #() #Foo)
  expected = ::TestValueStruct #()
  assert (actual.Equals expected == true)
  -- 無効な値（destinationが範囲外）
  actual = ::TestValueStruct (testDef.MoveItems #(1, 2) #() 0)
  expected = ::TestValueStruct #()
  assert (actual.Equals expected == true)
  -- 成功
  items = #(1, 2, 3)
  actual = ::TestValueStruct (testDef.MoveItems items #(2) 1)
  expected = ::TestValueStruct #(1)
  assert (actual.Equals expected == true)
  actual = ::TestValueStruct items
  expected = ::TestValueStruct #(2, 1, 3)
  assert (actual.Equals expected == true)
  -- 成功
  items = #(1, 2, 3, 4, 5, 6, 7)
  actual = ::TestValueStruct (testDef.MoveItems items #(2, 5, 6) 4)
  expected = ::TestValueStruct #(3, 4, 5)
  assert (actual.Equals expected == true)
  actual = ::TestValueStruct items
  expected = ::TestValueStruct #(1, 3, 2, 5, 6, 4, 7)
  assert (actual.Equals expected == true)
  -- 成功
  items = #(1, 2, 3, 4, 5, 6, 7)
  actual = ::TestValueStruct (testDef.MoveItems items #(2, 5, 6) 9)
  expected = ::TestValueStruct #(6, 7, 8)
  assert (actual.Equals expected == true)
  actual = ::TestValueStruct items
  expected = ::TestValueStruct #(1, 3, 4, 7, undefined, 2, 5, 6)
  assert (actual.Equals expected == true)
  /* Test End --------------------------------------------------------------- */
  sw.Stop()
  /* Teardown Start --------------------------------------------------------- */
  /* Teardown End ----------------------------------------------------------- */
  format "[end %]%ms\n" nowTime (sw.ElapsedMilliseconds as Integer)
  ok
)
