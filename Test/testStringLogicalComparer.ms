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
  local strings

  testObj = fileIn (getFullPath @"..\StringLogicalComparer.ms")
  /* Setup End -------------------------------------------------------------- */
  sw.Start()
  /* Test Start ------------------------------------------------------------- */
  /* 定義 */
  actual = ::TestValueStruct testObj
  assert (actual.IsDotNetMethod() == true)

  /* 比較 */
  strings = #(
    "20string",
    "2string",
    "3string",
    "st20ring",
    "st2ring",
    "st3ring",
    "string2",
    "string20",
    "string3"
  )
  qsort strings testObj
  actual = ::TestValueStruct strings
  expected = ::TestValueStruct #(
    "2string",
    "3string",
    "20string",
    "st2ring",
    "st3ring",
    "st20ring",
    "string2",
    "string3",
    "string20"
  )
  assert (actual.Equals expected == true)
  /* Test End --------------------------------------------------------------- */
  sw.Stop()
  /* Teardown Start --------------------------------------------------------- */
  /* Teardown End ----------------------------------------------------------- */
  format "[end %]%ms\n" nowTime (sw.ElapsedMilliseconds as Integer)
  ok
)
