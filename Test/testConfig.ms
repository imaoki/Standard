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
  local TestToolStruct
  struct TestToolStruct (
    private directoryClass = DotNetClass "System.IO.Directory",
    private fileClass = DotNetClass "System.IO.File",
    private shiftJisObject = (DotNetClass "System.Text.Encoding").GetEncoding "shift_jis",
    private utf8nObject = DotNetObject "System.Text.UTF8Encoding" false,

    public fn CloseFile fs = (
      if classOf fs == FileStream do (
        close fs
      )
      ok
    ),

    public fn CreateDirectory path = (
      this.directoryClass.CreateDirectory path
      this.DirectoryExists path
    ),

    public fn CreateShiftJisFile path contents = (
      this.WriteAllText path contents this.shiftJisObject
    ),

    public fn CreateUtf8nFile path contents = (
      this.WriteAllText path contents this.utf8nObject
    ),

    public fn DeleteDirectory path = (
      if this.DirectoryExists path do (
        this.directoryClass.Delete path true
      )
      not this.DirectoryExists path
    ),

    public fn DeleteFile path = (
      if this.FileExists path do (
        this.fileClass.Delete path
      )
      not this.FileExists path
    ),

    public fn DirectoryExists path = (
      this.directoryClass.Exists path
    ),

    public fn FileExists path = (
      this.fileClass.Exists path
    ),

    public fn IsDateTimeType obj = (
      (classOf obj == DotNetClass or classOf obj == DotNetObject) \
          and (DotNet.GetType obj).FullName == "System.DateTime"
    ),

    public fn ReadAllText path encodingObject = (
      local result = undefined
      if this.FileExists path do (
        result = this.fileClass.readAllText path encodingObject
      )
      result
    ),

    public fn ReadShiftJisFile path = (
      this.ReadAllText path this.shiftJisObject
    ),

    public fn ReadUtf8nFile path = (
      this.ReadAllText path this.utf8nObject
    ),

    public fn WriteAllText path contents encodingObject = (
      this.fileClass.WriteAllText path contents encodingObject
      this.FileExists path
    ),

    on Create do ()
  )
  local testTool = TestToolStruct()

  local testConfigFile = getFullPath @".\Data\test.mxsconfig"
  if testTool.FileExists testConfigFile do (
    testTool.DeleteFile testConfigFile
  )

  local count1 = 0
  local count2 = 0
  local keys1 = #()
  local keys2 = #()
  local testObj2 = undefined

  fileIn (getFullPath @"..\definitionPool.ms")
  testDef = ::standardDefinitionPool[@"Config.ms"]
  /* Setup End -------------------------------------------------------------- */
  sw.Start()
  /* Test Start ------------------------------------------------------------- */
  /* 空インスタンス作成 */
  testObj = testDef()

  /* Count */
  -- 存在しない
  actual = ::TestValueStruct (testObj.Count())
  expected = ::TestValueStruct 0
  assert (actual.Equals expected == true)

  /* GetFilePath */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetFilePath())
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)

  /* GetKeys */
  -- 存在しない
  actual = ::TestValueStruct (testObj.GetKeys())
  expected = ::TestValueStruct #()
  assert (actual.Equals expected == true)

  /* GetValue */
  -- 存在しない
  actual = ::TestValueStruct (testObj.GetValue #Foo)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 存在しない（既定値を指定）
  actual = ::TestValueStruct (testObj.GetValue #Foo default:0)
  expected = ::TestValueStruct 0
  assert (actual.Equals expected == true)

  /* HasValue */
  -- 存在しない
  actual = ::TestValueStruct (testObj.HasValue #Foo)
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)

  /* SetFilePath */
  -- 無効な値
  actual = ::TestValueStruct (testObj.SetFilePath 0)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 無効な値
  actual = ::TestValueStruct (testObj.SetFilePath #Foo)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 無効な値（拡張子が無い）
  actual = ::TestValueStruct (testObj.SetFilePath @"C:\Foo\Bar")
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- 成功
  actual = ::TestValueStruct (testObj.SetFilePath @"C:\Foo\Bar.mxsconfig")
  expected = ::TestValueStruct @"C:\Foo\Bar.mxsconfig"
  assert (actual.Equals expected == true)
  -- 成功（拡張子置き換え）
  actual = ::TestValueStruct (testObj.SetFilePath @"C:\Foo\Bar.txt")
  expected = ::TestValueStruct @"C:\Foo\Bar.mxsconfig"
  assert (actual.Equals expected == true)

  /* 作成パラメータ */
  testObj = testDef testConfigFile
  -- パスを確認
  actual = ::TestValueStruct (testObj.GetFilePath())
  expected = ::TestValueStruct testConfigFile
  assert (actual.Equals expected == true)

  /* AddValue */
  -- AngleAxis
  actual = ::TestValueStruct (testObj.AddValue #AngleAxis (AngleAxis 0 [0, 0, 1]))
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- Array
  actual = ::TestValueStruct (testObj.AddValue #Array #("foo", #fooBar))
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- BigMatrix
  actual = ::TestValueStruct (testObj.AddValue #BigMatrix (BigMatrix 2 3))
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- BitArray
  actual = ::TestValueStruct (testObj.AddValue #BitArray #{1..3, 5})
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- BooleanClass（true）
  actual = ::TestValueStruct (testObj.AddValue #BooleanClass1 true)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- BooleanClass（false）
  actual = ::TestValueStruct (testObj.AddValue #BooleanClass2 false)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- Box2
  actual = ::TestValueStruct (testObj.AddValue #Box2 (Box2 0 5 10 20))
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- Box3
  actual = ::TestValueStruct (testObj.AddValue #Box3 (Box3 [0, 0, 0] [5, 5, 5]))
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- Color
  actual = ::TestValueStruct (testObj.AddValue #Color (Color 0 5 10))
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- DataPair（名前未指定）
  actual = ::TestValueStruct (testObj.AddValue #DataPair1 (DataPair 0 1))
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- DataPair（名前指定）
  actual = ::TestValueStruct (
    testObj.AddValue #DataPair2 (DataPair Name:"foo" Value:#fooBar)
  )
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- Dictionary（Integer）
  actual = ::TestValueStruct (
    testObj.AddValue #Dictionary1 (Dictionary #Integer #(1, #Foo) #(2, "Bar"))
  )
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- Dictionary（Name）
  actual = ::TestValueStruct (
    testObj.AddValue #Dictionary2 (Dictionary #Name #(#Aaa, 1) #(#Bbb, 2))
  )
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- Dictionary（String）
  actual = ::TestValueStruct (
    testObj.AddValue #Dictionary3 (Dictionary #String #("Aaa", 1) #("Bbb", 2))
  )
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- EulerAngles
  actual = ::TestValueStruct (testObj.AddValue #EulerAngles (EulerAngles 0 0 0))
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- Float
  actual = ::TestValueStruct (testObj.AddValue #Float 0.0)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- Integer
  actual = ::TestValueStruct (testObj.AddValue #Integer 0)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- Interval（整数指定）
  actual = ::TestValueStruct (testObj.AddValue #Interval1 (Interval 0 10))
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- Interval（Time値指定）
  actual = ::TestValueStruct (testObj.AddValue #Interval2 (Interval 0f 10f))
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- Matrix3
  actual = ::TestValueStruct (testObj.AddValue #Matrix3 (Matrix3 1))
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- Name
  actual = ::TestValueStruct (testObj.AddValue #Name1 #fooBar)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- Name（引用符）
  actual = ::TestValueStruct (testObj.AddValue #Name2 ("#fooBar" as Name))
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- OkClass
  actual = ::TestValueStruct (testObj.AddValue #OkClass ok)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- Point2
  actual = ::TestValueStruct (testObj.AddValue #Point2 [0, 0])
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- Point3
  actual = ::TestValueStruct (testObj.AddValue #Point3 [0, 0, 0])
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- Point4
  actual = ::TestValueStruct (testObj.AddValue #Point4 [0, 0, 0, 0])
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- Quat
  actual = ::TestValueStruct (testObj.AddValue #Quat (Quat 1))
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- Ray
  actual = ::TestValueStruct (testObj.AddValue #Ray (Ray [0, 0, 0] [0, 0, 1]))
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- String
  actual = ::TestValueStruct (testObj.AddValue #String "fooBar")
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- StringStream
  actual = ::TestValueStruct (testObj.AddValue #StringStream (StringStream "fooBar"))
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- Time
  actual = ::TestValueStruct (testObj.AddValue #Time 1f)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- UndefinedClass
  actual = ::TestValueStruct (testObj.AddValue #UndefinedClass undefined)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- UnsuppliedClass
  actual = ::TestValueStruct (testObj.AddValue #UnsuppliedClass unsupplied)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)

  /* Count */
  actual = ::TestValueStruct (testObj.Count())
  expected = ::TestValueStruct 33
  assert (actual.Equals expected == true)

  /* GetKeys */
  actual = ::TestValueStruct (testObj.GetKeys())
  expected = ::TestValueStruct #(
    #AngleAxis,
    #Array,
    #BigMatrix,
    #BitArray,
    #BooleanClass1,
    #BooleanClass2,
    #Box2,
    #Box3,
    #Color,
    #DataPair1,
    #DataPair2,
    #Dictionary1,
    #Dictionary2,
    #Dictionary3,
    #EulerAngles,
    #Float,
    #Integer,
    #Interval1,
    #Interval2,
    #Matrix3,
    #Name1,
    #Name2,
    #OkClass,
    #Point2,
    #Point3,
    #Point4,
    #Quat,
    #Ray,
    #String,
    #StringStream,
    #Time,
    #UndefinedClass,
    #UnsuppliedClass
  )
  assert (actual.Equals expected == true)

  /* GetValue */
  -- AngleAxis
  actual = ::TestValueStruct (testObj.GetValue #AngleAxis)
  expected = ::TestValueStruct (AngleAxis 0 [0, 0, 1])
  assert (actual.Equals expected == true)
  -- Array
  actual = ::TestValueStruct (testObj.GetValue #Array)
  expected = ::TestValueStruct #("foo", #fooBar)
  assert (actual.Equals expected == true)
  -- BigMatrix
  actual = ::TestValueStruct (testObj.GetValue #BigMatrix)
  expected = ::TestValueStruct (BigMatrix 2 3)
  assert (actual.Equals expected == true)
  -- BitArray
  actual = ::TestValueStruct (testObj.GetValue #BitArray)
  expected = ::TestValueStruct #{1..3, 5}
  assert (actual.Equals expected == true)
  -- BooleanClass（true）
  actual = ::TestValueStruct (testObj.GetValue #BooleanClass1)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- BooleanClass（false）
  actual = ::TestValueStruct (testObj.GetValue #BooleanClass2)
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)
  -- Box2
  actual = ::TestValueStruct (testObj.GetValue #Box2)
  expected = ::TestValueStruct (Box2 0 5 10 20)
  assert (actual.Equals expected == true)
  -- Box3
  actual = ::TestValueStruct (testObj.GetValue #Box3)
  expected = ::TestValueStruct (Box3 [0, 0, 0] [5, 5, 5])
  assert (actual.Equals expected == true)
  -- Color
  actual = ::TestValueStruct (testObj.GetValue #Color)
  expected = ::TestValueStruct (Color 0 5 10)
  assert (actual.Equals expected == true)
  -- DataPair（名前未指定）
  actual = ::TestValueStruct (testObj.GetValue #DataPair1)
  expected = ::TestValueStruct (DataPair 0 1)
  assert (actual.Equals expected == true)
  -- DataPair（名前指定）
  actual = ::TestValueStruct (testObj.GetValue #DataPair2)
  expected = ::TestValueStruct (DataPair Name:"foo" Value:#fooBar)
  assert (actual.Equals expected == true)
  -- Dictionary（Integer）
  actual = ::TestValueStruct (testObj.GetValue #Dictionary1)
  expected = ::TestValueStruct (Dictionary #Integer #(1, #Foo) #(2, "Bar"))
  assert (actual.Equals expected == true)
  -- Dictionary（Name）
  actual = ::TestValueStruct (testObj.GetValue #Dictionary2)
  expected = ::TestValueStruct (Dictionary #Name #(#Aaa, 1) #(#Bbb, 2))
  assert (actual.Equals expected == true)
  -- Dictionary（String）
  actual = ::TestValueStruct (testObj.GetValue #Dictionary3)
  expected = ::TestValueStruct (Dictionary #String #("Aaa", 1) #("Bbb", 2))
  assert (actual.Equals expected == true)
  -- EulerAngles
  actual = ::TestValueStruct (testObj.GetValue #EulerAngles)
  expected = ::TestValueStruct (EulerAngles 0 0 0)
  assert (actual.Equals expected == true)
  -- Float
  actual = ::TestValueStruct (testObj.GetValue #Float)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- Integer
  actual = ::TestValueStruct (testObj.GetValue #Integer)
  expected = ::TestValueStruct 0
  assert (actual.Equals expected == true)
  -- Interval（整数指定）
  actual = ::TestValueStruct (testObj.GetValue #Interval1)
  expected = ::TestValueStruct (Interval 0 10)
  assert (actual.Equals expected == true)
  -- Interval（Time値指定）
  actual = ::TestValueStruct (testObj.GetValue #Interval2)
  expected = ::TestValueStruct (Interval 0f 10f)
  assert (actual.Equals expected == true)
  -- Matrix3
  actual = ::TestValueStruct (testObj.GetValue #Matrix3)
  expected = ::TestValueStruct (Matrix3 1)
  assert (actual.Equals expected == true)
  -- Name
  actual = ::TestValueStruct (testObj.GetValue #Name1)
  expected = ::TestValueStruct #fooBar
  assert (actual.Equals expected == true)
  -- Name（引用符）
  actual = ::TestValueStruct (testObj.GetValue #Name2)
  expected = ::TestValueStruct ("#fooBar" as Name)
  assert (actual.Equals expected == true)
  -- OkClass
  actual = ::TestValueStruct (testObj.GetValue #OkClass)
  expected = ::TestValueStruct ok
  assert (actual.Equals expected == true)
  -- Point2
  actual = ::TestValueStruct (testObj.GetValue #Point2)
  expected = ::TestValueStruct [0, 0]
  assert (actual.Equals expected == true)
  -- Point3
  actual = ::TestValueStruct (testObj.GetValue #Point3)
  expected = ::TestValueStruct [0, 0, 0]
  assert (actual.Equals expected == true)
  -- Point4
  actual = ::TestValueStruct (testObj.GetValue #Point4)
  expected = ::TestValueStruct [0, 0, 0, 0]
  assert (actual.Equals expected == true)
  -- Quat
  actual = ::TestValueStruct (testObj.GetValue #Quat)
  expected = ::TestValueStruct (Quat 1)
  assert (actual.Equals expected == true)
  -- Ray
  actual = ::TestValueStruct (testObj.GetValue #Ray)
  expected = ::TestValueStruct (Ray [0, 0, 0] [0, 0, 1])
  assert (actual.Equals expected == true)
  -- String
  actual = ::TestValueStruct (testObj.GetValue #String)
  expected = ::TestValueStruct "fooBar"
  assert (actual.Equals expected == true)
  -- StringStream
  actual = ::TestValueStruct (testObj.GetValue #StringStream)
  expected = ::TestValueStruct (StringStream "fooBar")
  assert (actual.Equals expected == true)
  -- Time
  actual = ::TestValueStruct (testObj.GetValue #Time)
  expected = ::TestValueStruct 1f
  assert (actual.Equals expected == true)
  -- UndefinedClass
  actual = ::TestValueStruct (testObj.GetValue #UndefinedClass)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)
  -- UnsuppliedClass
  actual = ::TestValueStruct (testObj.GetValue #UnsuppliedClass)
  expected = ::TestValueStruct unsupplied
  assert (actual.Equals expected == true)

  -- testObj.Dump()

  /* Read */
  actual = ::TestValueStruct (testObj.Read())
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)

  /* Write */
  actual = ::TestValueStruct (testObj.Write())
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- 保存先ファイルの存在を確認
  actual = ::TestValueStruct (testTool.FileExists testConfigFile)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)

  /* 読み込み確認用オブジェクト作成 */
  testObj2 = testDef testConfigFile

  /* Read */
  actual = ::TestValueStruct (testObj2.Read())
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- 数の同一性を確認
  count1 = testObj.Count()
  count2 = testObj2.Count()
  actual = ::TestValueStruct count1
  expected = ::TestValueStruct count2
  assert (actual.Equals expected == true)
  -- キーの同一性を確認
  keys1 = testObj.GetKeys()
  keys2 = testObj2.GetKeys()
  actual = ::TestValueStruct keys1
  expected = ::TestValueStruct keys2
  assert (actual.Equals expected == true)
  -- 値の同一性を確認
  for i = 1 to count1 do (
    local value1 = testObj.GetValue keys1[i]
    local value2 = testObj2.GetValue keys2[i]
    actual = ::TestValueStruct value1
    expected = ::TestValueStruct value2
    assert (actual.Equals expected == true)
  )

  /* Clear */
  actual = ::TestValueStruct (testObj.Clear())
  expected = ::TestValueStruct ok
  assert (actual.Equals expected == true)
  -- 数を確認
  actual = ::TestValueStruct (testObj.Count())
  expected = ::TestValueStruct 0
  assert (actual.Equals expected == true)
  /* Test End --------------------------------------------------------------- */
  sw.Stop()
  /* Teardown Start --------------------------------------------------------- */
  if testTool.FileExists testConfigFile do (
    testTool.DeleteFile testConfigFile
  )
  /* Teardown End ----------------------------------------------------------- */
  format "[end %]%ms\n" nowTime (sw.ElapsedMilliseconds as Integer)
  ok
)
