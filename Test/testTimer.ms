/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
(
  -- clearListener()

  local nowTime = (DotNetClass "System.DateTime").Now.ToString "HH:mm:ss"
  local sw = DotNetObject "System.Diagnostics.Stopwatch"

  local currentFile = getSourceFileName()
  local pathUtility = ::PathUtilityStruct currentFile

  local actual
  local expected
  local testDef
  local testObj

  format "[run %]@\"%\"\n" nowTime currentFile
  /* Setup Start ------------------------------------------------------------ */
  local expectedEnabled = false
  local expectedInterval = 100
  local expectedTicks = 0

  local updateObject
  fn updateObject context params type: = (
    format "updateObject params:%\n" params
    for param in params do (
      case param of (
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
    )
    /* Equals */
    actual = ::TestValueStruct context
    expected = ::TestValueStruct testObj
    assert (actual.Equals expected == true)
    ok
  )

  testDef = fileIn (pathUtility.GetFullPath @"..\Timer.ms")
  testObj = testDef()

  testObj.AddObserver (::ObserverStruct updateObject testObj)
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
