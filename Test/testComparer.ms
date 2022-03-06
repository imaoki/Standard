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
  local v1
  local v2

  testDef = fileIn (getFullPath @"..\Comparer.ms")
  testObj = testDef()
  /* Setup End -------------------------------------------------------------- */
  sw.Start()
  /* Test Start ------------------------------------------------------------- */
  /* CompareName */
  v1 = Point Name:"st1ring"
  v2 = Point Name:"st10ring"

  actual = ::TestValueStruct (testObj.CompareName v1 v2)
  expected = ::TestValueStruct -1
  assert (actual.Equals expected == true)

  delete v1
  delete v2

  /* CompareNodeHandle */
  v1 = Point()
  v2 = Point()

  actual = ::TestValueStruct (testObj.CompareNodeHandle v1 v2)
  expected = ::TestValueStruct -1
  assert (actual.Equals expected == true)

  delete v1
  delete v2

  /* CompareProperty */
  v1 = DataPair Foo:"st1ring" Bar:10
  v2 = DataPair Foo:"st10ring" Bar:1

  actual = ::TestValueStruct (
    testObj.CompareProperty v1 v2 propName:#Foo
  )
  expected = ::TestValueStruct -1
  assert (actual.Equals expected == true)

  actual = ::TestValueStruct (
    testObj.CompareProperty v1 v2 propName:#Bar
  )
  expected = ::TestValueStruct 1
  assert (actual.Equals expected == true)

  /* CompareStringLogical */
  v1 = "st1ring"
  v2 = "st10ring"

  actual = ::TestValueStruct (testObj.CompareStringLogical v1 v2)
  expected = ::TestValueStruct -1
  assert (actual.Equals expected == true)
  /* Test End --------------------------------------------------------------- */
  sw.Stop()
  /* Teardown Start --------------------------------------------------------- */
  /* Teardown End ----------------------------------------------------------- */
  format "[end %]%ms\n" nowTime (sw.ElapsedMilliseconds as Integer)
  ok
)
