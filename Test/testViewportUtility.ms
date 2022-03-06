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
  local targetSizeX = 300.0
  local targetSizeY = 200.0
  local viewTMPosZ = copy targetSizeY

  Viewport.SetLayout #Layout_1
  local viewSize = getViewSize()

  Viewport.SetLayout #Layout_4
  Viewport.ActiveViewport = 4
  Viewport.SetType #View_Persp_User
  Viewport.SetFov 45.0

  local adjustmentX = 0.0
  local adjustmentY = 0.0

  do (
    local pos = 1.0 - (targetSizeY + adjustmentY) / viewSize.Y
    ViewPanelManager.SetSplitterBarPos 0 pos
    adjustmentY += 0.1
  )
  while (getViewSize()).Y < targetSizeY

  do (
    local pos = 1.0 - (targetSizeX + adjustmentX) / viewSize.X
    ViewPanelManager.SetSplitterBarPos 1 pos
    adjustmentX += 0.1
  )
  while (getViewSize()).X < targetSizeX

  testDef = fileIn (getFullPath @"..\ViewportUtility.ms")
  testObj = testDef()
  /* Setup End -------------------------------------------------------------- */
  sw.Start()
  /* Test Start ------------------------------------------------------------- */
  /* GetDistancePerPixel */
  -- ビュー変換調整
  do (
    local pos = [0, 0, viewTMPosZ * -1]
    Viewport.SetTM (Matrix3 [1, 0, 0] [0, 1, 0] [0, 0, 1] pos)
    viewTMPosZ += 0.001
  )
  while testObj.GetDistancePerPixel() < 1.0
  -- 確認
  actual = ::TestValueStruct (testObj.GetDistancePerPixel())
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- スケール係数確認
  actual = ::TestValueStruct ((getScreenScaleFactor [0, 0, 0]) as Integer)
  expected = ::TestValueStruct targetSizeY
  assert (actual.Equals expected == true)

  /* PixelDistance */
  actual = ::TestValueStruct (testObj.PixelDistance [0, 0, 0] [1, 0, 0])
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  /* Test End --------------------------------------------------------------- */
  sw.Stop()
  /* Teardown Start --------------------------------------------------------- */
  /* Teardown End ----------------------------------------------------------- */
  format "[end %]%ms\n" nowTime (sw.ElapsedMilliseconds as Integer)
  ok
)
