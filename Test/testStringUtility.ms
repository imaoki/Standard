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
  local regexClass = DotNetClass "System.Text.RegularExpressions.Regex"
  local regexOptionsClass = DotNetClass "System.Text.RegularExpressions.RegexOptions"
  local regexOptionsIS = DotNet.CombineEnums \
      regexOptionsClass.IgnoreCase \
      regexOptionsClass.Singleline

  local obj
  local options
  local pattern

  fileIn (getFullPath @"..\definitionPool.ms")
  testDef = ::standardDefinitionPool[@"StringUtility.ms"]
  testObj = testDef()
  /* Setup End -------------------------------------------------------------- */
  sw.Start()
  /* Test Start ------------------------------------------------------------- */
  /* ClipString */
  pattern = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
  -- 既定値の40桁に省略
  actual = ::TestValueStruct (testObj.ClipString pattern)
  expected = ::TestValueStruct "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijk..."
  assert (actual.Equals expected == true)

  -- 20桁に省略
  actual = ::TestValueStruct (testObj.ClipString pattern digit:20)
  expected = ::TestValueStruct "ABCDEFGHIJKLMNOPQ..."
  assert (actual.Equals expected == true)

  /* CreateRegex */
  pattern = "\d+"
  -- 正規表現オブジェクト生成
  actual = ::TestValueStruct (testObj.CreateRegex pattern)
  expected = ::TestValueStruct (DotNetObject regexClass pattern regexOptionsIS)
  assert (actual.IsRegexObject() == true)
  assert (actual.Equals expected == true)

  /* EscapeBackslash */
  -- 空白文字
  actual = ::TestValueStruct (
    testObj.EscapeBackslash "\r\n\t\n\n\r\t\t"
  )
  expected = ::TestValueStruct @"\r\n\t\n\n\r\t\t"
  assert (actual.IsString() == true)
  assert (actual.Equals expected == true)
  -- バックスラッシュ
  actual = ::TestValueStruct (
    testObj.EscapeBackslash "foo\\bar\\hoge\\\\piyo"
  )
  expected = ::TestValueStruct @"foo\\bar\\hoge\\\\piyo"
  assert (actual.IsString() == true)
  assert (actual.Equals expected == true)

  /* EscapeWhiteSpace */
  -- 空白文字のエスケープ処理
  actual = ::TestValueStruct (
    testObj.EscapeWhiteSpace "foo\nbar\rhoge\tpiyo"
  )
  expected = ::TestValueStruct "foo\\nbar\\rhoge\\tpiyo"
  assert (actual.IsString() == true)
  assert (actual.Equals expected == true)

  /* FormatString */
  -- 文字列のフォーマット処理
  actual = ::TestValueStruct (
    testObj.FormatString "%% \%:%" #("--", "a", #IkFk)
  )
  expected = ::TestValueStruct "--a %:#IkFk"
  assert (actual.IsString() == true)
  assert (actual.Equals expected == true)

  /* FromCodePoint */
  actual = ::TestValueStruct (
    testObj.FromCodePoint #(
      9731,
      9733,
      9842,
      0x2F804,
      0xD83C, 0xDF63,
      0xD867, 0xDE3D
    )
  )
  expected = ::TestValueStruct "☃★♲你🍣𩸽"
  assert (actual.IsString() == true)
  assert (actual.Equals expected == true)

  /* GetRegexOptions */
  pattern = ".*"
  -- 既定値
  options = #(#IgnoreCase, #Singleline)
  obj = testObj.CreateRegex pattern
  actual = ::TestValueStruct (testObj.GetRegexOptions obj)
  expected = ::TestValueStruct options
  assert (actual.IsArray() == true)
  assert (actual.Equals expected == true)
  -- 明示的に指定
  options = #(#Multiline, #RightToLeft)
  obj = testObj.CreateRegex pattern options:options
  actual = ::TestValueStruct (testObj.GetRegexOptions obj)
  expected = ::TestValueStruct options
  assert (actual.IsArray() == true)
  assert (actual.Equals expected == true)
  -- 文字列で取得
  options = #(#Multiline, #RightToLeft)
  obj = testObj.CreateRegex pattern options:options
  actual = ::TestValueStruct (
    testObj.GetRegexOptions obj asStringArray:true
  )
  expected = ::TestValueStruct #("Multiline", "RightToLeft")
  assert (actual.IsArray() == true)
  assert (actual.Equals expected == true)

  /* GetRegexPattern */
  -- 通常パターン
  obj = testObj.CreateRegex "[A-Za-z_0-9]+"
  actual = ::TestValueStruct (testObj.GetRegexPattern obj)
  expected = ::TestValueStruct "[A-Za-z_0-9]+"
  assert (actual.IsString() == true)
  assert (actual.Equals expected == true)
  -- エスケープ文字
  obj = testObj.CreateRegex "\n\(\[\d+\]\)\n"
  actual = ::TestValueStruct (testObj.GetRegexPattern obj)
  expected = ::TestValueStruct "\\n\\(\\[\\d+\\]\\)\\n"
  assert (actual.IsString() == true)
  assert (actual.Equals expected == true)

  /* GetUnicodeCodePointFromSurrogatePair */
  -- 🍣
  actual = ::TestValueStruct (testObj.GetUnicodeCodePointFromSurrogatePair 0xD83C 0xDF63)
  expected = ::TestValueStruct 0x1F363
  assert (actual.Equals expected == true)
  -- 𩸽
  actual = ::TestValueStruct (testObj.GetUnicodeCodePointFromSurrogatePair 0xD867 0xDE3D)
  expected = ::TestValueStruct 0x29E3D
  assert (actual.Equals expected == true)

  /* GetValidUnicodeCodePoint */
  -- ★
  actual = ::TestValueStruct (testObj.GetValidUnicodeCodePoint 0x9733)
  expected = ::TestValueStruct #(0x9733)
  assert (actual.Equals expected == true)
  -- 𩸽
  actual = ::TestValueStruct (testObj.GetValidUnicodeCodePoint 0x29E3D)
  expected = ::TestValueStruct #(0xD867, 0xDE3D)
  assert (actual.Equals expected == true)
  -- 😃
  actual = ::TestValueStruct (testObj.GetValidUnicodeCodePoint 0x1F603)
  expected = ::TestValueStruct #(0xD83D, 0xDE03)
  assert (actual.Equals expected == true)

  /* IsRegexObject */
  -- 正規表現オブジェクト
  actual = ::TestValueStruct (
    testObj.IsRegexObject (DotNetObject regexClass "")
  )
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- 正規表現オブジェクト以外
  actual = ::TestValueStruct (
    testObj.IsRegexObject (DotNetObject "System.String" "")
  )
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)

  /* Join */
  -- セパレータ無し
  actual = ::TestValueStruct (testObj.Join #("foo", "bar"))
  expected = ::TestValueStruct "foobar"
  assert (actual.Equals expected == true)
  -- セパレータ指定
  actual = ::TestValueStruct (testObj.Join #("foo", "bar") separator:"-")
  expected = ::TestValueStruct "foo-bar"
  assert (actual.Equals expected == true)

  /* PadLeft */
  pattern = "foo"
  -- 文字を生成しない
  actual = ::TestValueStruct (testObj.PadLeft pattern 0 " ")
  expected = ::TestValueStruct "foo"
  assert (actual.Equals expected == true)
  -- 二文字以上の文字列を指定
  actual = ::TestValueStruct (testObj.PadLeft pattern 5 "ab")
  expected = ::TestValueStruct "aafoo"
  assert (actual.Equals expected == true)
  -- 多数の文字列を生成
  actual = ::TestValueStruct (testObj.PadLeft pattern 10 "-")
  expected = ::TestValueStruct "-------foo"
  assert (actual.Equals expected == true)

  /* PadRight */
  pattern = "foo"
  -- 文字を生成しない
  actual = ::TestValueStruct (testObj.PadRight pattern 0 " ")
  expected = ::TestValueStruct "foo"
  assert (actual.Equals expected == true)
  -- 二文字以上の文字列を指定
  actual = ::TestValueStruct (testObj.PadRight pattern 5 "ab")
  expected = ::TestValueStruct "fooaa"
  assert (actual.Equals expected == true)
  -- 多数の文字列を生成
  actual = ::TestValueStruct (testObj.PadRight pattern 10 "-")
  expected = ::TestValueStruct "foo-------"
  assert (actual.Equals expected == true)

  /* Serialize */
  -- AngleAxis
  actual = ::TestValueStruct (testObj.Serialize (AngleAxis 0 [0, 0, 1]))
  expected = ::TestValueStruct "(AngleAxis 0 [0, 0, 1])"
  assert (actual.Equals expected == true)
  -- Array
  actual = ::TestValueStruct (testObj.Serialize #("foo", #fooBar))
  expected = ::TestValueStruct "#(\"foo\", #FooBar)"
  assert (actual.Equals expected == true)
  -- BigMatrix
  actual = ::TestValueStruct (testObj.Serialize (BigMatrix 2 3))
  expected = ::TestValueStruct "(local _ = BigMatrix 2 3;_[1][1] = 0.000000;_[1][2] = 0.000000;_[1][3] = 0.000000;_[2][1] = 0.000000;_[2][2] = 0.000000;_[2][3] = 0.000000;_)"
  assert (actual.Equals expected == true)
  -- BitArray
  actual = ::TestValueStruct (testObj.Serialize #{1..3, 5})
  expected = ::TestValueStruct "#{1..3, 5}"
  assert (actual.Equals expected == true)
  -- BooleanClass（true）
  actual = ::TestValueStruct (testObj.Serialize true)
  expected = ::TestValueStruct "true"
  assert (actual.Equals expected == true)
  -- BooleanClass（false）
  actual = ::TestValueStruct (testObj.Serialize false)
  expected = ::TestValueStruct "false"
  assert (actual.Equals expected == true)
  -- Box2
  actual = ::TestValueStruct (testObj.Serialize (Box2 0 5 10 20))
  expected = ::TestValueStruct "(Box2 0 5 10 20)"
  assert (actual.Equals expected == true)
  -- Box3
  actual = ::TestValueStruct (testObj.Serialize (Box3 [0, 0, 0] [5, 5, 5]))
  expected = ::TestValueStruct "(Box3 [0, 0, 0] [5, 5, 5])"
  assert (actual.Equals expected == true)
  -- Color
  actual = ::TestValueStruct (testObj.Serialize (Color 0 5 10))
  expected = ::TestValueStruct "(Color 0 5 10)"
  assert (actual.Equals expected == true)
  -- DataPair（名前未指定）
  actual = ::TestValueStruct (testObj.Serialize (DataPair 0 1))
  expected = ::TestValueStruct "(DataPair 0 1)"
  assert (actual.Equals expected == true)
  -- DataPair（名前指定）
  actual = ::TestValueStruct (
    testObj.Serialize (DataPair Name:"foo" Value:#fooBar)
  )
  expected = ::TestValueStruct "(DataPair Name:\"foo\" Value:#FooBar)"
  assert (actual.Equals expected == true)
  -- Dictionary（Integer）
  actual = ::TestValueStruct (
    testObj.Serialize (Dictionary #Integer #(1, #Foo) #(2, "Bar"))
  )
  expected = ::TestValueStruct "(Dictionary #Integer #(1, #Foo) #(2, \"Bar\"))"
  assert (actual.Equals expected == true)
  -- Dictionary（Name）
  actual = ::TestValueStruct (
    testObj.Serialize (Dictionary #Name #(#Aaa, 1) #(#Bbb, 2))
  )
  expected = ::TestValueStruct "(Dictionary #Name #(#Aaa, 1) #(#Bbb, 2))"
  assert (actual.Equals expected == true)
  -- Dictionary（String）
  actual = ::TestValueStruct (
    testObj.Serialize (Dictionary #String #("Aaa", 1) #("Bbb", 2))
  )
  expected = ::TestValueStruct "(Dictionary #String #(\"Aaa\", 1) #(\"Bbb\", 2))"
  assert (actual.Equals expected == true)
  -- EulerAngles
  actual = ::TestValueStruct (testObj.Serialize (EulerAngles 0 0 0))
  expected = ::TestValueStruct "(EulerAngles 0 0 0)"
  assert (actual.Equals expected == true)
  -- Float
  actual = ::TestValueStruct (testObj.Serialize 0.0)
  expected = ::TestValueStruct "0.000000"
  assert (actual.Equals expected == true)
  -- Integer
  actual = ::TestValueStruct (testObj.Serialize 0)
  expected = ::TestValueStruct "0"
  assert (actual.Equals expected == true)
  -- Interval（整数指定）
  actual = ::TestValueStruct (testObj.Serialize (Interval 0 10))
  expected = ::TestValueStruct "(Interval 0f 10f)"
  assert (actual.Equals expected == true)
  -- Interval（Time値指定）
  actual = ::TestValueStruct (testObj.Serialize (Interval 0f 10f))
  expected = ::TestValueStruct "(Interval 0f 10f)"
  assert (actual.Equals expected == true)
  -- Matrix3
  actual = ::TestValueStruct (testObj.Serialize (Matrix3 1))
  expected = ::TestValueStruct (
    "(Matrix3 [1, 0, 0] [0, 1, 0] [0, 0, 1] [0, 0, 0])"
  )
  assert (actual.Equals expected == true)
  -- Name
  actual = ::TestValueStruct (testObj.Serialize #fooBar)
  expected = ::TestValueStruct "#FooBar"
  assert (actual.Equals expected == true)
  -- Name（引用符）
  actual = ::TestValueStruct (testObj.Serialize ("#fooBar" as Name))
  expected = ::TestValueStruct "#'#FooBar'"
  assert (actual.Equals expected == true)
  -- OkClass
  actual = ::TestValueStruct (testObj.Serialize ok)
  expected = ::TestValueStruct "ok"
  assert (actual.Equals expected == true)
  -- Point2
  actual = ::TestValueStruct (testObj.Serialize [0, 0])
  expected = ::TestValueStruct "[0, 0]"
  assert (actual.Equals expected == true)
  -- Point3
  actual = ::TestValueStruct (testObj.Serialize [0, 0, 0])
  expected = ::TestValueStruct "[0, 0, 0]"
  assert (actual.Equals expected == true)
  -- Point4
  actual = ::TestValueStruct (testObj.Serialize [0, 0, 0, 0])
  expected = ::TestValueStruct "[0, 0, 0, 0]"
  assert (actual.Equals expected == true)
  -- Quat
  actual = ::TestValueStruct (testObj.Serialize (Quat 1))
  expected = ::TestValueStruct "(Quat 0 0 0 1)"
  assert (actual.Equals expected == true)
  -- Ray
  actual = ::TestValueStruct (testObj.Serialize (Ray [0, 0, 0] [0, 0, 1]))
  expected = ::TestValueStruct "(Ray [0, 0, 0] [0, 0, 1])"
  assert (actual.Equals expected == true)
  -- String
  actual = ::TestValueStruct (testObj.Serialize "fooBar")
  expected = ::TestValueStruct "\"fooBar\""
  assert (actual.Equals expected == true)
  -- StringStream
  actual = ::TestValueStruct (testObj.Serialize (StringStream "fooBar"))
  expected = ::TestValueStruct "(StringStream \"fooBar\")"
  assert (actual.Equals expected == true)
  -- Time（秒）
  actual = ::TestValueStruct (testObj.Serialize 1m)
  expected = ::TestValueStruct "1800f"
  assert (actual.Equals expected == true)
  -- Time（分）
  actual = ::TestValueStruct (testObj.Serialize 1s)
  expected = ::TestValueStruct "30f"
  assert (actual.Equals expected == true)
  -- Time（ティック）
  actual = ::TestValueStruct (testObj.Serialize 1t)
  expected = ::TestValueStruct "0.00625f"
  assert (actual.Equals expected == true)
  -- Time（フレーム）
  actual = ::TestValueStruct (testObj.Serialize 1f)
  expected = ::TestValueStruct "1f"
  assert (actual.Equals expected == true)
  -- UndefinedClass
  actual = ::TestValueStruct (testObj.Serialize undefined)
  expected = ::TestValueStruct "undefined"
  assert (actual.Equals expected == true)
  -- UnsuppliedClass
  actual = ::TestValueStruct (testObj.Serialize unsupplied)
  expected = ::TestValueStruct "unsupplied"
  assert (actual.Equals expected == true)

  /* Split */
  pattern = "foo.bar.baz"
  -- 既定値
  actual = ::TestValueStruct (testObj.Split pattern ".")
  expected = ::TestValueStruct #("foo", "bar", "baz")
  assert (actual.Equals expected == true)
  -- 一致する区切り文字が一つの場合は空要素が省略される
  actual = ::TestValueStruct (testObj.Split pattern "." removeEmpty:false)
  expected = ::TestValueStruct #("foo", "bar", "baz")
  assert (actual.Equals expected == true)
  -- 一致する区切り文字が一つの場合は空要素が省略される
  actual = ::TestValueStruct (testObj.Split pattern ".a" removeEmpty:false)
  expected = ::TestValueStruct #("foo", "b", "r", "b", "z")
  assert (actual.Equals expected == true)
  -- 一致する区切り文字が二つ以上連続する場合は空要素は省略されない
  actual = ::TestValueStruct (testObj.Split pattern ".b" removeEmpty:false)
  expected = ::TestValueStruct #("foo", "", "ar", "", "az")
  assert (actual.Equals expected == true)
  -- 文字列で分割
  actual = ::TestValueStruct (testObj.Split pattern #(".b") removeEmpty:false)
  expected = ::TestValueStruct #("foo", "ar", "az")
  assert (actual.Equals expected == true)

  /* SplitByLF */
  -- 改行位置で分割
  actual = ::TestValueStruct (testObj.SplitByLF "foo\nbar\n")
  expected = ::TestValueStruct #("foo", "bar", "")
  assert (actual.Equals expected == true)

  /* ToCharArray */
  actual = ::TestValueStruct (testObj.ToCharArray "foo")
  expected = ::TestValueStruct #("f", "o", "o")
  assert (actual.Equals expected == true)
  -- 空文字
  actual = ::TestValueStruct (testObj.ToCharArray "")
  expected = ::TestValueStruct #()
  assert (actual.Equals expected == true)

  /* ToPascalCase */
  -- 境界テスト（大文字小文字）
  actual = ::TestValueStruct (testObj.ToPascalCase "fooBarHoge")
  expected = ::TestValueStruct "FooBarHoge"
  assert (actual.Equals expected == true)
  -- 境界テスト（空白）
  actual = ::TestValueStruct (testObj.ToPascalCase "foo bar hoge")
  expected = ::TestValueStruct "Foo Bar Hoge"
  assert (actual.Equals expected == true)
  -- 境界テスト（数字）
  actual = ::TestValueStruct (testObj.ToPascalCase "foo123bar")
  expected = ::TestValueStruct "Foo123Bar"
  assert (actual.Equals expected == true)
  -- 境界テスト（スネークケース）
  actual = ::TestValueStruct (testObj.ToPascalCase "foo_bar")
  expected = ::TestValueStruct "Foo_Bar"
  assert (actual.Equals expected == true)
  -- 境界テスト（チェインケース）
  actual = ::TestValueStruct (testObj.ToPascalCase "foo-bar")
  expected = ::TestValueStruct "Foo-Bar"
  assert (actual.Equals expected == true)
  -- 境界テスト（Name値の数字）
  actual = ::TestValueStruct (testObj.ToPascalCase #foo123bar)
  expected = ::TestValueStruct "#Foo123Bar"
  assert (actual.Equals expected == true)
  -- 境界テスト（Name値の空白）
  actual = ::TestValueStruct (testObj.ToPascalCase #'foo bar')
  expected = ::TestValueStruct "#'Foo Bar'"
  assert (actual.Equals expected == true)
  -- カンマテスト（Name）
  actual = ::TestValueStruct (testObj.ToPascalCase #'foo,bar')
  expected = ::TestValueStruct "#'Foo,Bar'"
  assert (actual.Equals expected == true)
  -- カンマテスト（String）
  actual = ::TestValueStruct (testObj.ToPascalCase "foo,bar")
  expected = ::TestValueStruct "Foo,Bar"
  assert (actual.Equals expected == true)
  -- カンマテスト（Array）
  actual = ::TestValueStruct (testObj.ToPascalCase #(0,0))
  expected = ::TestValueStruct "#(0, 0)"
  assert (actual.Equals expected == true)
  -- カンマテスト（Point2）
  actual = ::TestValueStruct (testObj.ToPascalCase [0,0])
  expected = ::TestValueStruct "[0, 0]"
  assert (actual.Equals expected == true)
  -- AngleAxis
  actual = ::TestValueStruct (testObj.ToPascalCase (AngleAxis 0 [0, 0, 1]))
  expected = ::TestValueStruct "(AngleAxis 0 [0, 0, 1])"
  assert (actual.Equals expected == true)
  -- Array
  actual = ::TestValueStruct (testObj.ToPascalCase #("foo", #fooBar))
  expected = ::TestValueStruct "#(\"Foo\", #FooBar)"
  assert (actual.Equals expected == true)
  -- BigMatrix
  actual = ::TestValueStruct (testObj.ToPascalCase (BigMatrix 2 3))
  expected = ::TestValueStruct "#BigMatrix([0.0, 0.0, 0.0], [0.0, 0.0, 0.0])"
  assert (actual.Equals expected == true)
  -- BitArray
  actual = ::TestValueStruct (testObj.ToPascalCase #{1..3, 5})
  expected = ::TestValueStruct "#{1..3, 5}"
  assert (actual.Equals expected == true)
  -- BooleanClass（true）
  actual = ::TestValueStruct (testObj.ToPascalCase true)
  expected = ::TestValueStruct "true"
  assert (actual.Equals expected == true)
  -- BooleanClass（false）
  actual = ::TestValueStruct (testObj.ToPascalCase false)
  expected = ::TestValueStruct "false"
  assert (actual.Equals expected == true)
  -- Box2
  actual = ::TestValueStruct (testObj.ToPascalCase (Box2 0 5 10 20))
  expected = ::TestValueStruct "(Box2 0 5 10 20)"
  assert (actual.Equals expected == true)
  -- Box3
  actual = ::TestValueStruct (testObj.ToPascalCase (Box3 [0, 0, 0] [5, 5, 5]))
  expected = ::TestValueStruct "(Box3 [0, 0, 0] [5, 5, 5])"
  assert (actual.Equals expected == true)
  -- Color
  actual = ::TestValueStruct (testObj.ToPascalCase (Color 0 5 10))
  expected = ::TestValueStruct "(Color 0 5 10)"
  assert (actual.Equals expected == true)
  -- DataPair（名前未指定）
  actual = ::TestValueStruct (testObj.ToPascalCase (DataPair 0 1))
  expected = ::TestValueStruct "(DataPair 0 1)"
  assert (actual.Equals expected == true)
  -- DataPair（名前指定）
  actual = ::TestValueStruct (
    testObj.ToPascalCase (DataPair Name:"foo" Value:#fooBar)
  )
  expected = ::TestValueStruct "(DataPair Name:\"Foo\" Value:#FooBar)"
  assert (actual.Equals expected == true)
  -- Dictionary（Integer）
  actual = ::TestValueStruct (
    testObj.ToPascalCase (Dictionary #Integer #(1, #Foo) #(2, "Bar"))
  )
  expected = ::TestValueStruct "(Dictionary #Integer #(1, #Foo) #(2, \"Bar\"))"
  assert (actual.Equals expected == true)
  -- Dictionary（Name）
  actual = ::TestValueStruct (
    testObj.ToPascalCase (Dictionary #Name #(#Aaa, 1) #(#Bbb, 2))
  )
  expected = ::TestValueStruct "(Dictionary #Name #(#Aaa, 1) #(#Bbb, 2))"
  assert (actual.Equals expected == true)
  -- Dictionary（String）
  actual = ::TestValueStruct (
    testObj.ToPascalCase (Dictionary #String #("Aaa", 1) #("Bbb", 2))
  )
  expected = ::TestValueStruct "(Dictionary #String #(\"Aaa\", 1) #(\"Bbb\", 2))"
  assert (actual.Equals expected == true)
  -- EulerAngles
  actual = ::TestValueStruct (testObj.ToPascalCase (EulerAngles 0 0 0))
  expected = ::TestValueStruct "(EulerAngles 0 0 0)"
  assert (actual.Equals expected == true)
  -- Float
  actual = ::TestValueStruct (testObj.ToPascalCase 0.0)
  expected = ::TestValueStruct "0.0"
  assert (actual.Equals expected == true)
  -- Integer
  actual = ::TestValueStruct (testObj.ToPascalCase 0)
  expected = ::TestValueStruct "0"
  assert (actual.Equals expected == true)
  -- Interval（整数指定）
  actual = ::TestValueStruct (testObj.ToPascalCase (Interval 0 10))
  expected = ::TestValueStruct "(Interval 0f 10f)"
  assert (actual.Equals expected == true)
  -- Interval（Time値指定）
  actual = ::TestValueStruct (testObj.ToPascalCase (Interval 0f 10f))
  expected = ::TestValueStruct "(Interval 0f 10f)"
  assert (actual.Equals expected == true)
  -- Matrix3
  actual = ::TestValueStruct (testObj.ToPascalCase (Matrix3 1))
  expected = ::TestValueStruct (
    "(Matrix3 [1, 0, 0] [0, 1, 0] [0, 0, 1] [0, 0, 0])"
  )
  assert (actual.Equals expected == true)
  -- Name
  actual = ::TestValueStruct (testObj.ToPascalCase #fooBar)
  expected = ::TestValueStruct "#FooBar"
  assert (actual.Equals expected == true)
  -- Name（引用符）
  actual = ::TestValueStruct (testObj.ToPascalCase ("#fooBar" as Name))
  expected = ::TestValueStruct "#'#FooBar'"
  assert (actual.Equals expected == true)
  -- OkClass
  actual = ::TestValueStruct (testObj.ToPascalCase ok)
  expected = ::TestValueStruct "ok"
  assert (actual.Equals expected == true)
  -- Point2
  actual = ::TestValueStruct (testObj.ToPascalCase [0, 0])
  expected = ::TestValueStruct "[0, 0]"
  assert (actual.Equals expected == true)
  -- Point3
  actual = ::TestValueStruct (testObj.ToPascalCase [0, 0, 0])
  expected = ::TestValueStruct "[0, 0, 0]"
  assert (actual.Equals expected == true)
  -- Point4
  actual = ::TestValueStruct (testObj.ToPascalCase [0, 0, 0, 0])
  expected = ::TestValueStruct "[0, 0, 0, 0]"
  assert (actual.Equals expected == true)
  -- Quat
  actual = ::TestValueStruct (testObj.ToPascalCase (Quat 1))
  expected = ::TestValueStruct "(Quat 0 0 0 1)"
  assert (actual.Equals expected == true)
  -- Ray
  actual = ::TestValueStruct (testObj.ToPascalCase (Ray [0, 0, 0] [0, 0, 1]))
  expected = ::TestValueStruct "(Ray [0, 0, 0] [0, 0, 1])"
  assert (actual.Equals expected == true)
  -- String
  actual = ::TestValueStruct (testObj.ToPascalCase "fooBar")
  expected = ::TestValueStruct "FooBar"
  assert (actual.Equals expected == true)
  -- StringStream
  actual = ::TestValueStruct (testObj.ToPascalCase (StringStream "fooBar"))
  expected = ::TestValueStruct "(StringStream \"FooBar\")"
  assert (actual.Equals expected == true)
  -- Time（秒）
  actual = ::TestValueStruct (testObj.ToPascalCase 1m)
  expected = ::TestValueStruct "1800f"
  assert (actual.Equals expected == true)
  -- Time（分）
  actual = ::TestValueStruct (testObj.ToPascalCase 1s)
  expected = ::TestValueStruct "30f"
  assert (actual.Equals expected == true)
  -- Time（ティック）
  actual = ::TestValueStruct (testObj.ToPascalCase 1t)
  expected = ::TestValueStruct "0.00625f"
  assert (actual.Equals expected == true)
  -- Time（フレーム）
  actual = ::TestValueStruct (testObj.ToPascalCase 1f)
  expected = ::TestValueStruct "1f"
  assert (actual.Equals expected == true)
  -- UndefinedClass
  actual = ::TestValueStruct (testObj.ToPascalCase undefined)
  expected = ::TestValueStruct "undefined"
  assert (actual.Equals expected == true)
  -- UnsuppliedClass
  actual = ::TestValueStruct (testObj.ToPascalCase unsupplied)
  expected = ::TestValueStruct "unsupplied"
  assert (actual.Equals expected == true)

  /* Trim */
  pattern = "\t\tfoobar  \n"
  actual = ::TestValueStruct (testObj.Trim pattern)
  expected = ::TestValueStruct "foobar"
  assert (actual.Equals expected == true)

  /* TrimEnd */
  pattern = "\t\tfoobar  \n"
  -- 末尾に一致する文字が無いので削除されない
  actual = ::TestValueStruct (testObj.TrimEnd pattern " ")
  expected = ::TestValueStruct "\t\tfoobar  \n"
  assert (actual.Equals expected == true)
  -- 複数の文字を削除
  actual = ::TestValueStruct (testObj.TrimEnd pattern "r \n")
  expected = ::TestValueStruct "\t\tfooba"
  assert (actual.Equals expected == true)

  /* TrimStart */
  pattern = "\t\tfoobar  \n"
  -- 先頭に一致する文字が無いので削除されない
  actual = ::TestValueStruct (testObj.TrimStart pattern " ")
  expected = ::TestValueStruct "\t\tfoobar  \n"
  assert (actual.Equals expected == true)
  -- 複数の文字を削除
  actual = ::TestValueStruct (testObj.TrimStart pattern "\tf")
  expected = ::TestValueStruct "oobar  \n"
  assert (actual.Equals expected == true)
  /* Test End --------------------------------------------------------------- */
  sw.Stop()
  /* Teardown Start --------------------------------------------------------- */
  /* Teardown End ----------------------------------------------------------- */
  format "[end %]%ms\n" nowTime (sw.ElapsedMilliseconds as Integer)
  ok
)
