/*! © 2021 imaoki | MIT License | https://github.com/imaoki */
(
  -- clearListener()

  local nowTime = (DotNetClass "System.DateTime").Now.ToString "HH:mm:ss"
  local sw = DotNetObject "System.Diagnostics.Stopwatch"

  local currentFile = getSourceFileName()
  local pathUtility = ::std.PathUtilityStruct currentFile

  local actual
  local expected
  local testDef
  local testObj

  format "[run %]@\"%\"\n" nowTime currentFile
  /* Setup Start ------------------------------------------------------------ */
  local fileClass = DotNetClass "System.IO.File"

  local enumDir = pathUtility.GetFullPath @".\Data\Enum"
  local readOnlyFile = pathUtility.GetFullPath @".\Data\Enum\ReadOnly.txt"

  local enumDirAttributes = fileClass.GetAttributes enumDir
  local readOnlyFileAttributes = fileClass.GetAttributes readOnlyFile
  local selfAttributes = fileClass.GetAttributes currentFile

  testDef = fileIn (pathUtility.GetFullPath @"..\Enum.ms")
  testObj = testDef "System.IO.FileAttributes"
  /* Setup End -------------------------------------------------------------- */
  sw.Start()
  /* Test Start ------------------------------------------------------------- */
  /* Create */
  -- 成功
  actual = ::TestValueStruct (
    testObj.Create #(#Archive)
  )
  expected = ::TestValueStruct selfAttributes
  assert (actual.Equals expected == true)

  -- 失敗
  actual = ::TestValueStruct (
    testObj.Create #(#None)
  )
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)

  /* GetFlags */
  -- 通常のディレクトリ
  actual = ::TestValueStruct (testObj.GetFlags enumDirAttributes)
  expected = ::TestValueStruct #(#Directory)
  assert (actual.Equals expected == true)

  -- 読み取り専用のテキストファイル
  actual = ::TestValueStruct (testObj.GetFlags readOnlyFileAttributes)
  expected = ::TestValueStruct #(#ReadOnly, #Archive)
  assert (actual.Equals expected == true)

  -- 通常のMAXScriptファイル
  actual = ::TestValueStruct (testObj.GetFlags selfAttributes)
  expected = ::TestValueStruct #(#Archive)
  assert (actual.Equals expected == true)

  /* GetNames */
  actual = ::TestValueStruct (testObj.GetNames())
  expected = ::TestValueStruct #(
    #ReadOnly,
    #Hidden,
    #System,
    #Directory,
    #Archive,
    #Device,
    #Normal,
    #Temporary,
    #SparseFile,
    #ReparsePoint,
    #Compressed,
    #Offline,
    #NotContentIndexed,
    #Encrypted,
    #IntegrityStream,
    #NoScrubData
  )
  assert (actual.Equals expected == true)

  /* HasFlag */
  -- 成功
  actual = ::TestValueStruct (
    testObj.HasFlag selfAttributes #Archive
  )
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)

  -- 失敗
  actual = ::TestValueStruct (
    testObj.HasFlag selfAttributes #Directory
  )
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)

  /* IsValidEnum */
  -- False
  local notEnumObject = testDef "System.IO.File"
  actual = ::TestValueStruct (notEnumObject.IsValidEnum())
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)

  -- True
  local enumObject = testDef "System.Text.RegularExpressions.RegexOptions"
  actual = ::TestValueStruct (enumObject.IsValidEnum())
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  /* Test End --------------------------------------------------------------- */
  sw.Stop()
  /* Teardown Start --------------------------------------------------------- */
  /* Teardown End ----------------------------------------------------------- */
  format "[end %]%ms\n" nowTime (sw.ElapsedMilliseconds as Integer)
  ok
)
