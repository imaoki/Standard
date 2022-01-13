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
  testDef = fileIn (pathUtility.GetFullPath @"..\Easing.ms")
  testObj = testDef()
  /* Setup End -------------------------------------------------------------- */
  sw.Start()
  /* Test Start ------------------------------------------------------------- */
  /* BackIn */
  -- 下限より下
  actual = ::TestValueStruct (testObj.BackIn -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.BackIn 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.BackIn 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct -0.161152
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.BackIn 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct -0.375
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.BackIn 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct -0.108455
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.BackIn 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.BackIn 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* BackInOut */
  -- 下限より下
  actual = ::TestValueStruct (testObj.BackInOut -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.BackInOut 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.BackInOut 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct -0.1875
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.BackInOut 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct 0.5
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.BackInOut 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct 1.1875
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.BackInOut 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.BackInOut 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* BackOut */
  -- 下限より下
  actual = ::TestValueStruct (testObj.BackOut -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.BackOut 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.BackOut 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct 1.108455
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.BackOut 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct 1.375
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.BackOut 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct 1.16115
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.BackOut 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.BackOut 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* Bezier */
  local tangent1 = [0.5, 0.0]
  local tangent2 = [0.5, 1.0]
  -- 下限より下
  actual = ::TestValueStruct (testObj.Bezier -0.1 [0.5, -0.1] tangent2)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.Bezier 0.0 tangent1 tangent2)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.Bezier 0.25 tangent1 tangent2)
  -- actual.Dump()
  expected = ::TestValueStruct 0.105893
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.Bezier 0.5 tangent1 tangent2)
  -- actual.Dump()
  expected = ::TestValueStruct 0.5
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.Bezier 0.75 tangent1 tangent2)
  -- actual.Dump()
  expected = ::TestValueStruct 0.894107
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.Bezier 1.0 tangent1 tangent2)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.Bezier 1.1 tangent1 [0.5, 1.1])
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* BounceIn */
  -- 下限より下
  actual = ::TestValueStruct (testObj.BounceIn -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.BounceIn 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.BounceIn 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct 0.0411363
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.BounceIn 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct 0.28125
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.BounceIn 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct 0.527344
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.BounceIn 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.BounceIn 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* BounceInOut */
  -- 下限より下
  actual = ::TestValueStruct (testObj.BounceInOut -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.BounceInOut 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.BounceInOut 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct 0.140625
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.BounceInOut 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct 0.5
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.BounceInOut 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct 0.859375
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.BounceInOut 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.BounceInOut 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* BounceOut */
  -- 下限より下
  actual = ::TestValueStruct (testObj.BounceOut -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.BounceOut 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.BounceOut 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct 0.472656
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.BounceOut 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct 0.718750
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.BounceOut 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct 0.958864
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.BounceOut 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.BounceOut 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* CircularIn */
  -- 下限より下
  actual = ::TestValueStruct (testObj.CircularIn -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.CircularIn 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.CircularIn 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct 0.0317541
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.CircularIn 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct 0.133975
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.CircularIn 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct 0.338562
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.CircularIn 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.CircularIn 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* CircularInOut */
  -- 下限より下
  actual = ::TestValueStruct (testObj.CircularInOut -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.CircularInOut 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.CircularInOut 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct 0.0669873
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.CircularInOut 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct 0.5
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.CircularInOut 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct 0.933013
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.CircularInOut 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.CircularInOut 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* CircularOut */
  -- 下限より下
  actual = ::TestValueStruct (testObj.CircularOut -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.CircularOut 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.CircularOut 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct 0.661438
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.CircularOut 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct 0.866025
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.CircularOut 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct 0.968246
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.CircularOut 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.CircularOut 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* CubicIn */
  -- 下限より下
  actual = ::TestValueStruct (testObj.CubicIn -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.CubicIn 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.CubicIn 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct 0.015625
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.CubicIn 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct 0.125
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.CubicIn 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct 0.421875
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.CubicIn 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.CubicIn 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* CubicInOut */
  -- 下限より下
  actual = ::TestValueStruct (testObj.CubicInOut -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.CubicInOut 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.CubicInOut 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct 0.0625
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.CubicInOut 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct 0.5
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.CubicInOut 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct 0.9375
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.CubicInOut 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.CubicInOut 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* CubicOut */
  -- 下限より下
  actual = ::TestValueStruct (testObj.CubicOut -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.CubicOut 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.CubicOut 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct 0.578125
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.CubicOut 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct 0.875
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.CubicOut 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct 0.984375
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.CubicOut 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.CubicOut 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* ElasticIn */
  -- 下限より下
  actual = ::TestValueStruct (testObj.ElasticIn -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.ElasticIn 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.ElasticIn 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct -0.005104
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.ElasticIn 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct -0.022097
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.ElasticIn 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct 0.067650
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.ElasticIn 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.ElasticIn 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* ElasticIn（Flat） */
  -- 下限より下
  actual = ::TestValueStruct (testObj.ElasticIn -0.1 flat:true)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.ElasticIn 0.0 flat:true)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.ElasticIn 0.25 flat:true)
  -- actual.Dump()
  expected = ::TestValueStruct 0.994476
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.ElasticIn 0.5 flat:true)
  -- actual.Dump()
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.ElasticIn 0.75 flat:true)
  -- actual.Dump()
  expected = ::TestValueStruct 1.176777
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.ElasticIn 1.0 flat:true)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.ElasticIn 1.1 flat:true)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* ElasticInOut */
  -- 下限より下
  actual = ::TestValueStruct (testObj.ElasticInOut -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.ElasticInOut 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.ElasticInOut 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct -0.011049
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.ElasticInOut 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct 0.5
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.ElasticInOut 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct 1.011049
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.ElasticInOut 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.ElasticInOut 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* ElasticInOut（Flat） */
  -- 下限より下
  actual = ::TestValueStruct (testObj.ElasticInOut -0.1 flat:true)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.ElasticInOut 0.0 flat:true)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.ElasticInOut 0.25 flat:true)
  -- actual.Dump()
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.ElasticInOut 0.5 flat:true)
  -- actual.Dump()
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.ElasticInOut 0.75 flat:true)
  -- actual.Dump()
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.ElasticInOut 1.0 flat:true)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.ElasticInOut 1.1 flat:true)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* ElasticOut */
  -- 下限より下
  actual = ::TestValueStruct (testObj.ElasticOut -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.ElasticOut 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.ElasticOut 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct 0.932351
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.ElasticOut 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct 1.022097
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.ElasticOut 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct 1.005104
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.ElasticOut 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.ElasticOut 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* ElasticOut（Flat） */
  -- 下限より下
  actual = ::TestValueStruct (testObj.ElasticOut -0.1 flat:true)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.ElasticOut 0.0 flat:true)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.ElasticOut 0.25 flat:true)
  -- actual.Dump()
  expected = ::TestValueStruct 0.823223
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.ElasticOut 0.5 flat:true)
  -- actual.Dump()
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.ElasticOut 0.75 flat:true)
  -- actual.Dump()
  expected = ::TestValueStruct 1.005524
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.ElasticOut 1.0 flat:true)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.ElasticOut 1.1 flat:true)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* ExponentialIn */
  -- 下限より下
  actual = ::TestValueStruct (testObj.ExponentialIn -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.ExponentialIn 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.ExponentialIn 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct 0.005524
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.ExponentialIn 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct 0.031250
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.ExponentialIn 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct 0.176777
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.ExponentialIn 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.ExponentialIn 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* ExponentialInOut */
  -- 下限より下
  actual = ::TestValueStruct (testObj.ExponentialInOut -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.ExponentialInOut 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.ExponentialInOut 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct 0.015625
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.ExponentialInOut 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct 0.5
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.ExponentialInOut 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct 0.984375
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.ExponentialInOut 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.ExponentialInOut 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* ExponentialOut */
  -- 下限より下
  actual = ::TestValueStruct (testObj.ExponentialOut -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.ExponentialOut 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.ExponentialOut 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct 0.823223
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.ExponentialOut 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct 0.96875
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.ExponentialOut 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct 0.994476
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.ExponentialOut 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.ExponentialOut 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* Linear */
  -- 下限より下
  actual = ::TestValueStruct (testObj.Linear -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.Linear 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.Linear 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct 0.25
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.Linear 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct 0.5
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.Linear 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct 0.75
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.Linear 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.Linear 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* QuadraticIn */
  -- 下限より下
  actual = ::TestValueStruct (testObj.QuadraticIn -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.QuadraticIn 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.QuadraticIn 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct 0.0625
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.QuadraticIn 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct 0.25
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.QuadraticIn 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct 0.5625
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.QuadraticIn 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.QuadraticIn 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* QuadraticInOut */
  -- 下限より下
  actual = ::TestValueStruct (testObj.QuadraticInOut -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.QuadraticInOut 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.QuadraticInOut 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct 0.125
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.QuadraticInOut 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct 0.5
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.QuadraticInOut 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct 0.875
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.QuadraticInOut 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.QuadraticInOut 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* QuadraticOut */
  -- 下限より下
  actual = ::TestValueStruct (testObj.QuadraticOut -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.QuadraticOut 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.QuadraticOut 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct 0.4375
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.QuadraticOut 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct 0.75
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.QuadraticOut 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct 0.9375
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.QuadraticOut 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.QuadraticOut 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* QuarticIn */
  -- 下限より下
  actual = ::TestValueStruct (testObj.QuarticIn -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.QuarticIn 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.QuarticIn 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct 0.003906
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.QuarticIn 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct 0.0625
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.QuarticIn 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct 0.316406
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.QuarticIn 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より下
  actual = ::TestValueStruct (testObj.QuarticIn 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* QuarticInOut */
  -- 下限より下
  actual = ::TestValueStruct (testObj.QuarticInOut -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.QuarticInOut 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.QuarticInOut 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct 0.03125
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.QuarticInOut 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct 0.5
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.QuarticInOut 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct 0.96875
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.QuarticInOut 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.QuarticInOut 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* QuarticOut */
  -- 下限より下
  actual = ::TestValueStruct (testObj.QuarticOut -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.QuarticOut 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.QuarticOut 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct 0.683594
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.QuarticOut 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct 0.9375
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.QuarticOut 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct 0.996094
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.QuarticOut 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.QuarticOut 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* QuinticIn */
  -- 下限より下
  actual = ::TestValueStruct (testObj.QuinticIn -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.QuinticIn 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.QuinticIn 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct 0.000977
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.QuinticIn 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct 0.03125
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.QuinticIn 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct 0.237305
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.QuinticIn 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.QuinticIn 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* QuinticInOut */
  -- 下限より下
  actual = ::TestValueStruct (testObj.QuinticInOut -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.QuinticInOut 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.QuinticInOut 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct 0.015625
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.QuinticInOut 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct 0.5
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.QuinticInOut 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct 0.984375
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.QuinticInOut 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.QuinticInOut 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* QuinticOut */
  -- 下限より下
  actual = ::TestValueStruct (testObj.QuinticOut -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.QuinticOut 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.QuinticOut 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct 0.762695
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.QuinticOut 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct 0.968750
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.QuinticOut 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct 0.999023
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.QuinticOut 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.QuinticOut 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  -- /* Sigmoid */
  local inflection = 0.0
  local slope = 0.0
  -- 下限より下
  actual = ::TestValueStruct (testObj.Sigmoid -0.1 -0.6 -0.6)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.Sigmoid 0.0 inflection slope)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.Sigmoid 0.25 inflection slope)
  -- actual.Dump()
  expected = ::TestValueStruct 0.099213
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.Sigmoid 0.5 inflection slope)
  -- actual.Dump()
  expected = ::TestValueStruct 0.5
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.Sigmoid 0.75 inflection slope)
  -- actual.Dump()
  expected = ::TestValueStruct 0.900787
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.Sigmoid 1.0 inflection slope)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.Sigmoid 1.1 0.6 0.6)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* SineIn */
  -- 下限より下
  actual = ::TestValueStruct (testObj.SineIn -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.SineIn 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.SineIn 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct 0.076120
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.SineIn 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct 0.292893
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.SineIn 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct 0.617317
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.SineIn 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.SineIn 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* SineInOut */
  -- 下限より下
  actual = ::TestValueStruct (testObj.SineInOut -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.SineInOut 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.SineInOut 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct 0.146447
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.SineInOut 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct 0.5
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.SineInOut 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct 0.853553
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.SineInOut 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.SineInOut 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)

  /* SineOut */
  -- 下限より下
  actual = ::TestValueStruct (testObj.SineOut -0.1)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.0
  actual = ::TestValueStruct (testObj.SineOut 0.0)
  expected = ::TestValueStruct 0.0
  assert (actual.Equals expected == true)
  -- 0.25
  actual = ::TestValueStruct (testObj.SineOut 0.25)
  -- actual.Dump()
  expected = ::TestValueStruct 0.382683
  assert (actual.Equals expected == true)
  -- 0.5
  actual = ::TestValueStruct (testObj.SineOut 0.5)
  -- actual.Dump()
  expected = ::TestValueStruct 0.707107
  assert (actual.Equals expected == true)
  -- 0.75
  actual = ::TestValueStruct (testObj.SineOut 0.75)
  -- actual.Dump()
  expected = ::TestValueStruct 0.923880
  assert (actual.Equals expected == true)
  -- 1.0
  actual = ::TestValueStruct (testObj.SineOut 1.0)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  -- 上限より上
  actual = ::TestValueStruct (testObj.SineOut 1.1)
  expected = ::TestValueStruct 1.0
  assert (actual.Equals expected == true)
  /* Test End --------------------------------------------------------------- */
  sw.Stop()
  /* Teardown Start --------------------------------------------------------- */
  /* Teardown End ----------------------------------------------------------- */
  format "[end %]%ms\n" nowTime (sw.ElapsedMilliseconds as Integer)
  ok
)
