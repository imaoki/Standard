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
  local fooDef = attributes FooAttribute version:1 (
    parameters FooParameter (
      Param Animatable:false Default:0 Type:#Integer
    )
  )

  local barDef = attributes BarAttribute version:1 (
    parameters BarParameter (
      Param Animatable:false Default:0 Type:#Integer
    )
  )

  local n1 = Point()
  local n2 = Point()
  CustAttributes.Add n1 fooDef baseObject:true
  CustAttributes.Add n1 barDef baseObject:true

  testDef = fileIn (getFullPath @"..\AttributeUtility.ms")
  testObj = testDef()
  /* Setup End -------------------------------------------------------------- */
  sw.Start()
  /* Test Start ------------------------------------------------------------- */
  /* GetAttribute */
  -- 成功
  actual = ::TestValueStruct (classOf (testObj.GetAttribute n1 #FooAttribute))
  expected = ::TestValueStruct fooDef
  assert (actual.Equals expected == true)
  -- 成功
  actual = ::TestValueStruct (classOf (testObj.GetAttribute n1 #BarAttribute))
  expected = ::TestValueStruct barDef
  assert (actual.Equals expected == true)
  -- 失敗
  actual = ::TestValueStruct (classOf (testObj.GetAttribute n2 #FooAttribute))
  expected = ::TestValueStruct UndefinedClass
  assert (actual.Equals expected == true)

  /* GetAttributeNames */
  -- 成功
  actual = ::TestValueStruct (testObj.GetAttributeNames n1)
  expected = ::TestValueStruct #(#FooAttribute, #BarAttribute)
  assert (actual.Equals expected == true)
  -- 失敗
  actual = ::TestValueStruct (testObj.GetAttributeNames n2)
  expected = ::TestValueStruct #()
  assert (actual.Equals expected == true)

  /* HasAttribute */
  -- 成功
  actual = ::TestValueStruct (testObj.HasAttribute n1 #FooAttribute)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- 失敗
  actual = ::TestValueStruct (testObj.HasAttribute n2 #FooAttribute)
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)

  /* IsAttribute */
  -- アトリビュート定義
  actual = ::TestValueStruct (testObj.IsAttribute fooDef)
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)
  -- アトリビュート定義
  actual = ::TestValueStruct (testObj.IsAttribute (CustAttributes.GetDef n1 1 baseObject:true))
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)
  -- アトリビュートインスタンス
  actual = ::TestValueStruct (testObj.IsAttribute n1.BaseObject.FooAttribute)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- アトリビュートインスタンス
  actual = ::TestValueStruct (testObj.IsAttribute (CustAttributes.Get n1 1 baseObject:true))
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  /* Test End --------------------------------------------------------------- */
  sw.Stop()
  /* Teardown Start --------------------------------------------------------- */
  delete n1
  delete n2
  /* Teardown End ----------------------------------------------------------- */
  format "[end %]%ms\n" nowTime (sw.ElapsedMilliseconds as Integer)
  ok
)
