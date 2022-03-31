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
  local TestObserverStruct
  struct TestObserverStruct (
    public Update,

    public fn StructName = #TestObserverStruct,

    public fn Equals obj = (
      local isEqualStructName = isStruct obj \
          and isProperty obj #StructName \
          and classOf obj.StructName == MAXScriptFunction \
          and obj.StructName() == this.StructName()

      local isEqualProperties = isProperty obj #Update \
          and obj.Update == this.Update

      isEqualStructName and isEqualProperties
    ),

    on Create do ()
  )

  local expectedEnabled = false
  local expectedInterval = 100
  local expectedTicks = 0

  local testNotification
  fn testNotification type param = (
    -- format "testNotification type:% param:%\n" type param
    case type of (
      (#Interval): (
        actual = ::TestValueStruct (testObj.GetInterval())
        expected = ::TestValueStruct expectedInterval
        assert (actual.Equals expected == true)
      )
      (#Ticks): (
        actual = ::TestValueStruct (testObj.IsEnabled())
        expected = ::TestValueStruct expectedEnabled
        assert (actual.Equals expected == true)

        local actualTicks = testObj.GetTicks()
        actual = ::TestValueStruct actualTicks
        expected = ::TestValueStruct expectedTicks
        assert (actual.Equals expected == true)

        if actualTicks > 0 do (
          /* Stop */
          actual = ::TestValueStruct (testObj.Stop())
          expected = ::TestValueStruct ok
          assert (actual.Equals expected == true)
          -- Enabled確認
          actual = ::TestValueStruct (testObj.IsEnabled())
          expected = ::TestValueStruct false
          assert (actual.Equals expected == true)
          -- ticks確認
          actual = ::TestValueStruct (testObj.GetTicks())
          expected = ::TestValueStruct 1
          assert (actual.Equals expected == true)
        )
      )
      default: ()
    )
    /* Equals */
    actual = ::TestValueStruct context
    expected = ::TestValueStruct testObj
    assert (actual.Equals expected == true)
    ok
  )

  fileIn (getFullPath @"..\definitionPool.ms")
  testDef = ::standardDefinitionPool[@"Timer.ms"]
  testObj = testDef()

  testObj.StateChanged.Subscribe (TestObserverStruct testNotification)
  /* Setup End -------------------------------------------------------------- */
  sw.Start()
  /* Test Start ------------------------------------------------------------- */
  /* GetInterval */
  actual = ::TestValueStruct (testObj.GetInterval())
  expected = ::TestValueStruct 100
  assert (actual.Equals expected == true)

  /* GetTicks */
  actual = ::TestValueStruct (testObj.GetTicks())
  expected = ::TestValueStruct 0
  assert (actual.Equals expected == true)

  /* GetTimer */
  actual = ::TestValueStruct ((DotNet.GetType "System.Windows.Forms.Timer").IsInstanceOfType (testObj.GetTimer()))
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)

  /* IsEnabled */
  actual = ::TestValueStruct (testObj.IsEnabled())
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)

  /* UpdateTicks */
  expectedEnabled = false
  expectedTicks = 1
  actual = ::TestValueStruct (testObj.UpdateTicks())
  expected = ::TestValueStruct expectedTicks
  assert (actual.Equals expected == true)

  /* Reset */
  actual = ::TestValueStruct (testObj.Reset())
  expected = ::TestValueStruct ok
  assert (actual.Equals expected == true)

  /* SetInterval */
  -- 範囲外（最小値）
  expectedInterval = 1
  actual = ::TestValueStruct (testObj.SetInterval 0)
  expected = ::TestValueStruct expectedInterval
  assert (actual.Equals expected == true)
  -- 範囲内
  expectedInterval = 500
  actual = ::TestValueStruct (testObj.SetInterval 500)
  expected = ::TestValueStruct expectedInterval
  assert (actual.Equals expected == true)

  /* Start */
  -- Intervalを設定
  expectedInterval = 10
  actual = ::TestValueStruct (testObj.SetInterval 10)
  expected = ::TestValueStruct expectedInterval
  assert (actual.Equals expected == true)
  -- タイマー起動
  expectedEnabled = true
  expectedTicks = 1
  actual = ::TestValueStruct (testObj.Start())
  expected = ::TestValueStruct ok
  assert (actual.Equals expected == true)

  /* Restart */

  /* Test End --------------------------------------------------------------- */
  sw.Stop()
  /* Teardown Start --------------------------------------------------------- */
  /* Teardown End ----------------------------------------------------------- */
  format "[end %]%ms\n" nowTime (sw.ElapsedMilliseconds as Integer)
  ok
)
