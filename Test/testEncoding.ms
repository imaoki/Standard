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
  local shiftJisObject = (DotNetClass "System.Text.Encoding").GetEncoding "shift_jis"
  local utf8nObject = DotNetObject "System.Text.UTF8Encoding" false

  fileIn (getFullPath @"..\definitionPool.ms")
  testDef = fileIn (getFullPath @"..\Encoding.ms")
  /* Setup End -------------------------------------------------------------- */
  sw.Start()
  /* Test Start ------------------------------------------------------------- */
  /* DecodeHexString */
    -- utf8N
  testObj = testDef()
  actual = ::TestValueStruct (
    testObj.DecodeHexString "E3-81-82-E3-81-84-E3-81-86-E3-81-88-E3-81-8A"
  ) IgnoreCase:true
  expected = ::TestValueStruct "あいうえお"
  assert (actual.Equals expected == true)

  -- shift_jis
  testObj = testDef "shift_jis"
  actual = ::TestValueStruct (
    testObj.DecodeHexString "82-A0-82-A2-82-A4-82-A6-82-A8"
  ) IgnoreCase:true
  expected = ::TestValueStruct "あいうえお"
  assert (actual.Equals expected == true)

  /* EncodeToHexString */
  -- utf8N
  testObj = testDef()
  actual = ::TestValueStruct (testObj.EncodeToHexString "あいうえお") IgnoreCase:true
  expected = ::TestValueStruct "E3-81-82-E3-81-84-E3-81-86-E3-81-88-E3-81-8A"
  assert (actual.Equals expected == true)

  -- shift_jis
  testObj = testDef "shift_jis"
  actual = ::TestValueStruct (testObj.EncodeToHexString "あいうえお") IgnoreCase:true
  expected = ::TestValueStruct "82-A0-82-A2-82-A4-82-A6-82-A8"
  assert (actual.Equals expected == true)

  /* GetBytes */
  -- utf8N
  testObj = testDef()
  actual = ::TestValueStruct (testObj.GetBytes "あいうえお")
  expected = ::TestValueStruct #(227, 129, 130, 227, 129, 132, 227, 129, 134, 227, 129, 136, 227, 129, 138)
  assert (actual.Equals expected == true)

  -- shift_jis
  testObj = testDef "shift_jis"
  actual = ::TestValueStruct (testObj.GetBytes "あいうえお")
  expected = ::TestValueStruct #(130, 160, 130, 162, 130, 164, 130, 166, 130, 168)
  assert (actual.Equals expected == true)

  /* GetCodePage */
  -- utf8N
  testObj = testDef()
  actual = ::TestValueStruct (testObj.GetCodePage())
  expected = ::TestValueStruct 65001
  assert (actual.Equals expected == true)

  -- shift_jis
  testObj = testDef "shift_jis"
  actual = ::TestValueStruct (testObj.GetCodePage())
  expected = ::TestValueStruct 932
  assert (actual.Equals expected == true)

  /* GetDisplayName */
  -- utf8N
  testObj = testDef()
  actual = ::TestValueStruct (testObj.GetDisplayName()) IgnoreCase:true
  expected = ::TestValueStruct "Unicode (UTF-8)"
  assert (actual.Equals expected == true)

  -- shift_jis
  testObj = testDef "shift_jis"
  actual = ::TestValueStruct (testObj.GetDisplayName()) IgnoreCase:true
  expected = ::TestValueStruct "Japanese (Shift-JIS)"
  assert (actual.Equals expected == true)

  /* GetEncodingObject */
  -- utf8N
  testObj = testDef()
  actual = ::TestValueStruct (testObj.GetEncodingObject())
  expected = ::TestValueStruct utf8nObject
  assert (actual.Equals expected == true)

  -- shift_jis
  testObj = testDef "shift_jis"
  actual = ::TestValueStruct (testObj.GetEncodingObject())
  expected = ::TestValueStruct shiftJisObject
  assert (actual.Equals expected == true)

  /* GetName */
  -- utf8N
  testObj = testDef()
  actual = ::TestValueStruct (testObj.GetName()) IgnoreCase:true
  expected = ::TestValueStruct "utf-8"
  assert (actual.Equals expected == true)

  -- shift_jis
  testObj = testDef "shift_jis"
  actual = ::TestValueStruct (testObj.GetName()) IgnoreCase:true
  expected = ::TestValueStruct "shift_jis"
  assert (actual.Equals expected == true)

  /* GetString */
  -- utf8N
  testObj = testDef()
  actual = ::TestValueStruct (
    testObj.GetString #(227, 129, 130, 227, 129, 132, 227, 129, 134, 227, 129, 136, 227, 129, 138)
  )
  expected = ::TestValueStruct "あいうえお"
  assert (actual.Equals expected == true)

  -- shift_jis
  testObj = testDef "shift_jis"
  actual = ::TestValueStruct (
    testObj.GetString #(130, 160, 130, 162, 130, 164, 130, 166, 130, 168)
  )
  expected = ::TestValueStruct "あいうえお"
  assert (actual.Equals expected == true)

  /* IsValidEncoding */
  -- True
  testObj = testDef()
  actual = ::TestValueStruct (testObj.IsValidEncoding())
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)

  -- True
  testObj = testDef "shift_jis"
  actual = ::TestValueStruct (testObj.IsValidEncoding())
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)

  -- False
  testObj = testDef "abc"
  actual = ::TestValueStruct (testObj.IsValidEncoding())
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)

  /* SetEncoding */
  testObj = testDef ""

  -- 状態確認
  actual = ::TestValueStruct (testObj.IsValidEncoding())
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)

  -- utf8N
  actual = ::TestValueStruct (testObj.SetEncoding "utf-8")
  expected = ::TestValueStruct utf8nObject
  assert (actual.Equals expected == true)

  -- shift_jis
  actual = ::TestValueStruct (testObj.SetEncoding "shift_jis")
  expected = ::TestValueStruct shiftJisObject
  assert (actual.Equals expected == true)

  /* Test End --------------------------------------------------------------- */
  sw.Stop()
  /* Teardown Start --------------------------------------------------------- */
  /* Teardown End ----------------------------------------------------------- */
  format "[end %]%ms\n" nowTime (sw.ElapsedMilliseconds as Integer)
  ok
)
