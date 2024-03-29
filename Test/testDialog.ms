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
  fileIn (getFullPath @"..\definitionPool.ms")
  local configDef = ::standardDefinitionPool[@"Config.ms"]

  local MnuTest
  rcMenu MnuTest (
    menuItem Mi1 "Item1"
    separator Sep
    subMenu "SubMenu" (
      menuItem Mi2 "Item2"
    )
  )

  local RltTest
  rollout RltTest "" (
    button Btn "Button"
  )

  local expectedInitPosition = undefined
  local expectedInitSize = [160, 160]
  local expectedIsDisplayed = false
  local expectedLockHeight = false
  local expectedLockWidth = false
  local expectedMenuDef = undefined
  local expectedModal = false
  local expectedPosition = [0, 0]
  local expectedRolloutDef = undefined
  local expectedSize = [0, 0]
  local expectedStyleBorder = false
  local expectedStyleMaximizeBox = false
  local expectedStyleMinimizeBox = false
  local expectedStyleResizing = false
  local expectedStyleSunkenedge = false
  local expectedStyleSysmenu = true
  local expectedStyleTitleBar = false
  local expectedStyleToolWindow = true

  local testNotification
  fn testNotification type param = (
    -- format "testNotification type:% param:%\n" type param
    case type of (
      (#DialogCreated): (
        actual = ::TestValueStruct (testObj.IsDisplayed())
        expected = ::TestValueStruct expectedIsDisplayed
        assert (actual.Equals expected == true)
      )
      (#DialogDestroyed): (
        actual = ::TestValueStruct (testObj.IsDisplayed())
        expected = ::TestValueStruct expectedIsDisplayed
        assert (actual.Equals expected == true)
      )
      (#InitPosition): (
        actual = ::TestValueStruct (testObj.GetInitPosition())
        expected = ::TestValueStruct expectedInitPosition
        assert (actual.Equals expected == true)
      )
      (#InitSize): (
        actual = ::TestValueStruct (testObj.GetInitSize())
        expected = ::TestValueStruct expectedInitSize
        assert (actual.Equals expected == true)
      )
      (#IsDisplayed): (
        actual = ::TestValueStruct param
        expected = ::TestValueStruct expectedIsDisplayed
        assert (actual.Equals expected == true)
      )
      (#LockHeight): (
        actual = ::TestValueStruct (testObj.GetLockHeight())
        expected = ::TestValueStruct expectedLockHeight
        assert (actual.Equals expected == true)
      )
      (#LockWidth): (
        actual = ::TestValueStruct (testObj.GetLockWidth())
        expected = ::TestValueStruct expectedLockWidth
        assert (actual.Equals expected == true)
      )
      (#MenuDef): (
        actual = ::TestValueStruct (testObj.GetMenuDef())
        expected = ::TestValueStruct expectedMenuDef
        assert (actual.Equals expected == true)
      )
      (#Modal): (
        actual = ::TestValueStruct (testObj.GetModal())
        expected = ::TestValueStruct expectedModal
        assert (actual.Equals expected == true)
      )
      (#PositionChanged): (
        actual = ::TestValueStruct (testObj.GetPosition())
        expected = ::TestValueStruct expectedPosition
        assert (actual.Equals expected == true)
      )
      (#RolloutDef): (
        actual = ::TestValueStruct (testObj.GetRolloutDef())
        expected = ::TestValueStruct expectedRolloutDef
        assert (actual.Equals expected == true)
      )
      (#SizeChanged): (
        actual = ::TestValueStruct (testObj.GetSize())
        expected = ::TestValueStruct expectedSize
        assert (actual.Equals expected == true)
      )
      (#StyleBorder): (
        actual = ::TestValueStruct (testObj.GetStyleBorder())
        expected = ::TestValueStruct expectedStyleBorder
        assert (actual.Equals expected == true)
      )
      (#StyleMaximizeBox): (
        actual = ::TestValueStruct (testObj.GetStyleMaximizeBox())
        expected = ::TestValueStruct expectedStyleMaximizeBox
        assert (actual.Equals expected == true)
      )
      (#StyleMinimizeBox): (
        actual = ::TestValueStruct (testObj.GetStyleMinimizeBox())
        expected = ::TestValueStruct expectedStyleMinimizeBox
        assert (actual.Equals expected == true)
      )
      (#StyleResizing): (
        actual = ::TestValueStruct (testObj.GetStyleResizing())
        expected = ::TestValueStruct expectedStyleResizing
        assert (actual.Equals expected == true)
      )
      (#StyleSunkenedge): (
        actual = ::TestValueStruct (testObj.GetStyleSunkenedge())
        expected = ::TestValueStruct expectedStyleSunkenedge
        assert (actual.Equals expected == true)
      )
      (#StyleSysmenu): (
        actual = ::TestValueStruct (testObj.GetStyleSysmenu())
        expected = ::TestValueStruct expectedStyleSysmenu
        assert (actual.Equals expected == true)
      )
      (#StyleTitleBar): (
        actual = ::TestValueStruct (testObj.GetStyleTitleBar())
        expected = ::TestValueStruct expectedStyleTitleBar
        assert (actual.Equals expected == true)
      )
      (#StyleToolWindow): (
        actual = ::TestValueStruct (testObj.GetStyleToolWindow())
        expected = ::TestValueStruct expectedStyleToolWindow
        assert (actual.Equals expected == true)
      )
      default: ()
    )
    ok
  )

  local testConfig = configDef()

  testDef = ::standardDefinitionPool[@"Dialog.ms"]
  /* Setup End -------------------------------------------------------------- */
  sw.Start()
  /* Test Start ------------------------------------------------------------- */
  /* 空インスタンス作成 */
  testObj = testDef()
  testObj.StateChanged.Subscribe testNotification

  /* GetInitPosition */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetInitPosition())
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)

  /* GetInitSize */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetInitSize())
  expected = ::TestValueStruct [160, 160]
  assert (actual.Equals expected == true)

  /* GetLockHeight */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetLockHeight())
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)

  /* GetLockWidth */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetLockWidth())
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)

  /* GetMenuDef */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetMenuDef())
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)

  /* GetModal */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetModal())
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)

  /* GetPosition */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetPosition())
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)

  /* GetRolloutDef */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetRolloutDef())
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)

  /* GetRolloutName */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetRolloutName())
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)

  /* GetSize */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetSize())
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)

  /* GetStyleBorder */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetStyleBorder())
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)

  /* GetStyleMaximizeBox */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetStyleMaximizeBox())
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)

  /* GetStyleMinimizeBox */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetStyleMinimizeBox())
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)

  /* GetStyleResizing */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetStyleResizing())
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)

  /* GetStyleSunkenedge */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetStyleSunkenedge())
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)

  /* GetStyleSysmenu */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetStyleSysmenu())
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)

  /* GetStyleTitleBar */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetStyleTitleBar())
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)

  /* GetStyleToolWindow */
  -- 既定値
  actual = ::TestValueStruct (testObj.GetStyleToolWindow())
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)

  /* IsDisplayed */
  -- 既定値
  actual = ::TestValueStruct (testObj.IsDisplayed())
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)

  /* Load */
  actual = ::TestValueStruct (testObj.Load testConfig)
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)
  -- 数を確認
  actual = ::TestValueStruct (testConfig.Count())
  expected = ::TestValueStruct 0
  assert (actual.Equals expected == true)

  /* Save */
  actual = ::TestValueStruct (testObj.Save testConfig)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- 数を確認
  actual = ::TestValueStruct (testConfig.Count())
  expected = ::TestValueStruct 1
  assert (actual.Equals expected == true)
  -- キーを確認
  actual = ::TestValueStruct (testConfig.GetKeys())
  expected = ::TestValueStruct #(#Dialog)
  assert (actual.Equals expected == true)
  -- 値を確認
  actual = ::TestValueStruct (testConfig.GetValue #Dialog)
  expected = ::TestValueStruct (
    Dictionary #Name \
        #(#InitPosition, undefined) \
        #(#InitSize, [160, 160]) \
        #(#LockHeight, false) \
        #(#LockWidth, false) \
        #(#Modal, false) \
        #(#StyleBorder, false) \
        #(#StyleMaximizeBox, false) \
        #(#StyleMinimizeBox, false) \
        #(#StyleResizing, false) \
        #(#StyleSunkenedge, false) \
        #(#StyleSysmenu, true) \
        #(#StyleTitleBar, false) \
        #(#StyleToolWindow, true)
  )
  assert (actual.Equals expected == true)

  /* SetInitPosition */
  -- 無効な値
  expectedInitPosition = undefined
  actual = ::TestValueStruct (testObj.SetInitPosition "[100, 100]")
  expected = ::TestValueStruct expectedInitPosition
  assert (actual.Equals expected == true)
  -- 無効な値
  expectedInitPosition = undefined
  actual = ::TestValueStruct (testObj.SetInitPosition 100)
  expected = ::TestValueStruct expectedInitPosition
  assert (actual.Equals expected == true)
  -- 無効な値
  expectedInitPosition = undefined
  actual = ::TestValueStruct (testObj.SetInitPosition [100, 100, 100])
  expected = ::TestValueStruct expectedInitPosition
  assert (actual.Equals expected == true)
  -- 成功（Point2）
  expectedInitPosition = [100, 100]
  actual = ::TestValueStruct (testObj.SetInitPosition [100, 100])
  expected = ::TestValueStruct expectedInitPosition
  assert (actual.Equals expected == true)
  -- 成功（undefined）
  expectedInitPosition = undefined
  actual = ::TestValueStruct (testObj.SetInitPosition undefined)
  expected = ::TestValueStruct expectedInitPosition
  assert (actual.Equals expected == true)

  /* SetInitSize */
  -- 無効な値
  expectedInitSize = [160, 160]
  actual = ::TestValueStruct (testObj.SetInitSize "[100, 100]")
  expected = ::TestValueStruct expectedInitSize
  assert (actual.Equals expected == true)
  -- 無効な値
  expectedInitSize = [160, 160]
  actual = ::TestValueStruct (testObj.SetInitSize 100)
  expected = ::TestValueStruct expectedInitSize
  assert (actual.Equals expected == true)
  -- 無効な値
  expectedInitSize = [160, 160]
  actual = ::TestValueStruct (testObj.SetInitSize [100, 100, 100])
  expected = ::TestValueStruct expectedInitSize
  assert (actual.Equals expected == true)
  -- 無効な値（undefined）
  expectedInitSize = [160, 160]
  actual = ::TestValueStruct (testObj.SetInitSize undefined)
  expected = ::TestValueStruct expectedInitSize
  assert (actual.Equals expected == true)
  -- 成功
  expectedInitSize = [100, 100]
  actual = ::TestValueStruct (testObj.SetInitSize [100, 100])
  expected = ::TestValueStruct expectedInitSize
  assert (actual.Equals expected == true)

  /* SetLockHeight */
  -- 無効な値
  expectedLockHeight = false
  actual = ::TestValueStruct (testObj.SetLockHeight "true")
  expected = ::TestValueStruct expectedLockHeight
  assert (actual.Equals expected == true)
  -- 成功
  expectedLockHeight = true
  actual = ::TestValueStruct (testObj.SetLockHeight true)
  expected = ::TestValueStruct expectedLockHeight
  assert (actual.Equals expected == true)

  /* SetLockWidth */
  -- 無効な値
  expectedLockWidth = false
  actual = ::TestValueStruct (testObj.SetLockWidth "true")
  expected = ::TestValueStruct expectedLockWidth
  assert (actual.Equals expected == true)
  -- 成功
  expectedLockWidth = true
  actual = ::TestValueStruct (testObj.SetLockWidth true)
  expected = ::TestValueStruct expectedLockWidth
  assert (actual.Equals expected == true)

  /* SetModal */
  -- 無効な値
  expectedModal = false
  actual = ::TestValueStruct (testObj.SetModal "true")
  expected = ::TestValueStruct expectedModal
  assert (actual.Equals expected == true)
  -- 成功
  expectedModal = true
  actual = ::TestValueStruct (testObj.SetModal true)
  expected = ::TestValueStruct expectedModal
  assert (actual.Equals expected == true)

  /* SetPosition */
  -- ロールアウトが表示されていないので失敗
  expectedPosition = undefined
  actual = ::TestValueStruct (testObj.SetPosition [100, 100])
  expected = ::TestValueStruct expectedPosition
  assert (actual.Equals expected == true)

  /* SetSize */
  -- ロールアウトが表示されていないので失敗
  expectedSize = undefined
  actual = ::TestValueStruct (testObj.SetSize [100, 100])
  expected = ::TestValueStruct expectedSize
  assert (actual.Equals expected == true)

  /* SetStyleBorder */
  -- 無効な値
  expectedStyleBorder = false
  actual = ::TestValueStruct (testObj.SetStyleBorder "true")
  expected = ::TestValueStruct expectedStyleBorder
  assert (actual.Equals expected == true)
  -- 成功
  expectedStyleBorder = true
  actual = ::TestValueStruct (testObj.SetStyleBorder true)
  expected = ::TestValueStruct expectedStyleBorder
  assert (actual.Equals expected == true)

  /* SetStyleMaximizeBox */
  -- 無効な値
  expectedStyleMaximizeBox = false
  actual = ::TestValueStruct (testObj.SetStyleMaximizeBox "true")
  expected = ::TestValueStruct expectedStyleMaximizeBox
  assert (actual.Equals expected == true)
  -- 成功
  expectedStyleMaximizeBox = true
  actual = ::TestValueStruct (testObj.SetStyleMaximizeBox true)
  expected = ::TestValueStruct expectedStyleMaximizeBox
  assert (actual.Equals expected == true)

  /* SetStyleMinimizeBox */
  -- 無効な値
  expectedStyleMinimizeBox = false
  actual = ::TestValueStruct (testObj.SetStyleMinimizeBox "true")
  expected = ::TestValueStruct expectedStyleMinimizeBox
  assert (actual.Equals expected == true)
  -- 成功
  expectedStyleMinimizeBox = true
  actual = ::TestValueStruct (testObj.SetStyleMinimizeBox true)
  expected = ::TestValueStruct expectedStyleMinimizeBox
  assert (actual.Equals expected == true)

  /* SetStyleResizing */
  -- 無効な値
  expectedStyleResizing = false
  actual = ::TestValueStruct (testObj.SetStyleResizing "true")
  expected = ::TestValueStruct expectedStyleResizing
  assert (actual.Equals expected == true)
  -- 成功
  expectedStyleResizing = true
  actual = ::TestValueStruct (testObj.SetStyleResizing true)
  expected = ::TestValueStruct expectedStyleResizing
  assert (actual.Equals expected == true)

  /* SetStyleSunkenedge */
  -- 無効な値
  expectedStyleSunkenedge = false
  actual = ::TestValueStruct (testObj.SetStyleSunkenedge "true")
  expected = ::TestValueStruct expectedStyleSunkenedge
  assert (actual.Equals expected == true)
  -- 成功
  expectedStyleSunkenedge = true
  actual = ::TestValueStruct (testObj.SetStyleSunkenedge true)
  expected = ::TestValueStruct expectedStyleSunkenedge
  assert (actual.Equals expected == true)

  /* SetStyleSysmenu */
  -- 無効な値
  expectedStyleSysmenu = true
  actual = ::TestValueStruct (testObj.SetStyleSysmenu "false")
  expected = ::TestValueStruct expectedStyleSysmenu
  assert (actual.Equals expected == true)
  -- 成功
  expectedStyleSysmenu = false
  actual = ::TestValueStruct (testObj.SetStyleSysmenu false)
  expected = ::TestValueStruct expectedStyleSysmenu
  assert (actual.Equals expected == true)

  /* SetStyleTitleBar */
  -- 無効な値
  expectedStyleTitleBar = false
  actual = ::TestValueStruct (testObj.SetStyleTitleBar "true")
  expected = ::TestValueStruct expectedStyleTitleBar
  assert (actual.Equals expected == true)
  -- 成功
  expectedStyleTitleBar = true
  actual = ::TestValueStruct (testObj.SetStyleTitleBar true)
  expected = ::TestValueStruct expectedStyleTitleBar
  assert (actual.Equals expected == true)

  /* SetStyleToolWindow */
  -- 無効な値
  expectedStyleToolWindow = true
  actual = ::TestValueStruct (testObj.SetStyleToolWindow "false")
  expected = ::TestValueStruct expectedStyleToolWindow
  assert (actual.Equals expected == true)
  -- 成功
  expectedStyleToolWindow = false
  actual = ::TestValueStruct (testObj.SetStyleToolWindow false)
  expected = ::TestValueStruct expectedStyleToolWindow
  assert (actual.Equals expected == true)

  /* SetMenuDef */
  -- 無効な値
  expectedMenuDef = undefined
  actual = ::TestValueStruct (testObj.SetMenuDef #Foo)
  expected = ::TestValueStruct expectedMenuDef
  assert (actual.Equals expected == true)
  -- 成功（RCMenu）
  expectedMenuDef = MnuTest
  actual = ::TestValueStruct (testObj.SetMenuDef MnuTest)
  expected = ::TestValueStruct expectedMenuDef
  assert (actual.Equals expected == true)
  -- 成功（undefined）
  expectedMenuDef = undefined
  actual = ::TestValueStruct (testObj.SetMenuDef undefined)
  expected = ::TestValueStruct expectedMenuDef
  assert (actual.Equals expected == true)

  /* SetRolloutDef */
  -- 無効な値
  expectedRolloutDef = undefined
  actual = ::TestValueStruct (testObj.SetRolloutDef #Foo)
  expected = ::TestValueStruct expectedRolloutDef
  assert (actual.Equals expected == true)
  -- 成功
  expectedRolloutDef = RltTest
  actual = ::TestValueStruct (testObj.SetRolloutDef RltTest)
  expected = ::TestValueStruct expectedRolloutDef
  assert (actual.Equals expected == true)
  -- 名前を確認
  actual = ::TestValueStruct (testObj.GetRolloutName())
  expected = ::TestValueStruct #RltTest
  assert (actual.Equals expected == true)
  -- 位置を確認（ロールアウト非表示でも取得可能）
  actual = ::TestValueStruct (testObj.GetPosition())
  expected = ::TestValueStruct [0, 0]
  assert (actual.Equals expected == true)
  -- サイズを確認（ロールアウト非表示でも取得可能）
  actual = ::TestValueStruct (testObj.GetSize())
  expected = ::TestValueStruct [0, 0]
  assert (actual.Equals expected == true)

  /* インスタンス再作成 */
  testObj = testDef()
  testObj.StateChanged.Subscribe testNotification
  -- ロールアウト設定
  expectedRolloutDef = RltTest
  actual = ::TestValueStruct (testObj.SetRolloutDef RltTest)
  expected = ::TestValueStruct expectedRolloutDef
  assert (actual.Equals expected == true)

  /* Save */
  testConfig.Clear()
  actual = ::TestValueStruct (testObj.Save testConfig)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- 数を確認
  actual = ::TestValueStruct (testConfig.Count())
  expected = ::TestValueStruct 1
  assert (actual.Equals expected == true)
  -- キーを確認
  actual = ::TestValueStruct (testConfig.GetKeys())
  expected = ::TestValueStruct #(#'RltTest.Dialog')
  assert (actual.Equals expected == true)
  -- 値を確認
  actual = ::TestValueStruct (testConfig.GetValue #'RltTest.Dialog')
  expected = ::TestValueStruct (
    Dictionary #Name \
        #(#InitPosition, undefined) \
        #(#InitSize, [160, 160]) \
        #(#LockHeight, false) \
        #(#LockWidth, false) \
        #(#Modal, false) \
        #(#StyleBorder, false) \
        #(#StyleMaximizeBox, false) \
        #(#StyleMinimizeBox, false) \
        #(#StyleResizing, false) \
        #(#StyleSunkenedge, false) \
        #(#StyleSysmenu, true) \
        #(#StyleTitleBar, false) \
        #(#StyleToolWindow, true)
  )
  assert (actual.Equals expected == true)

  /* Create */
  expectedIsDisplayed = true
  actual = ::TestValueStruct (testObj.Create())
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- 位置を確認
  actual = ::TestValueStruct (testObj.GetPosition())
  assert (actual.IsPoint2() == true)
  -- サイズを確認
  actual = ::TestValueStruct (testObj.GetSize())
  expected = ::TestValueStruct [160, 160]
  assert (actual.Equals expected == true)
  -- 表示状態を確認
  actual = ::TestValueStruct (testObj.IsDisplayed())
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- 位置を設定
  expectedPosition = [100, 100]
  actual = ::TestValueStruct (testObj.SetPosition [100, 100])
  expected = ::TestValueStruct expectedPosition
  assert (actual.Equals expected == true)
  -- サイズを設定
  expectedSize = [100, 100]
  actual = ::TestValueStruct (testObj.SetSize [100, 100])
  expected = ::TestValueStruct expectedSize
  assert (actual.Equals expected == true)

  /* RaiseDialogDestroyed */
  expectedIsDisplayed = false
  actual = ::TestValueStruct (testObj.RaiseDialogDestroyed())
  expected = ::TestValueStruct ok
  assert (actual.Equals expected == true)
  -- 表示状態を確認
  actual = ::TestValueStruct (testObj.IsDisplayed())
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)

  /* DisableIsDialogDestroyed */
  actual = ::TestValueStruct (testObj.DisableIsDialogDestroyed())
  expected = ::TestValueStruct ok
  assert (actual.Equals expected == true)
  -- 表示状態を確認
  actual = ::TestValueStruct (testObj.IsDisplayed())
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)

  /* Destroy */
  expectedIsDisplayed = false
  actual = ::TestValueStruct (testObj.Destroy())
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- 位置を確認
  actual = ::TestValueStruct (testObj.GetPosition())
  expected = ::TestValueStruct [0, 0]
  assert (actual.Equals expected == true)
  -- サイズを確認
  actual = ::TestValueStruct (testObj.GetSize())
  expected = ::TestValueStruct [0, 0]
  assert (actual.Equals expected == true)
  -- 表示状態を確認
  actual = ::TestValueStruct (testObj.IsDisplayed())
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)

  -- testObj.Dump()

  /* 作成パラメータ */
  testObj = testDef RltTest [100, 100] [200, 200] MnuTest
  -- ロールアウト定義を確認
  actual = ::TestValueStruct (testObj.GetRolloutDef())
  expected = ::TestValueStruct RltTest
  assert (actual.Equals expected == true)
  -- 初期サイズを確認
  actual = ::TestValueStruct (testObj.GetInitSize())
  expected = ::TestValueStruct [100, 100]
  assert (actual.Equals expected == true)
  -- 初期位置を確認
  actual = ::TestValueStruct (testObj.GetInitPosition())
  expected = ::TestValueStruct [200, 200]
  assert (actual.Equals expected == true)
  -- メニュー定義を確認
  actual = ::TestValueStruct (testObj.GetMenuDef())
  expected = ::TestValueStruct MnuTest
  assert (actual.Equals expected == true)
  /* Test End --------------------------------------------------------------- */
  sw.Stop()
  /* Teardown Start --------------------------------------------------------- */
  /* Teardown End ----------------------------------------------------------- */
  format "[end %]%ms\n" nowTime (sw.ElapsedMilliseconds as Integer)
  ok
)
