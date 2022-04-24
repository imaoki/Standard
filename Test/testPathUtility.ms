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
  local parentDir = getFullPath @"..\"
  if matchPattern parentDir pattern:@"*\" do (
    parentDir = trimRight parentDir @"\"
  )

  local regex
  local regexClass = DotNetClass "System.Text.RegularExpressions.Regex"
  local regexOptionsClass = DotNetClass "System.Text.RegularExpressions.RegexOptions"

  fn createRegex pattern options = (
    local regexOptions = regexOptionsClass.None
    for optionName in options do (
      local option = getProperty regexOptionsClass optionName
      regexOptions = DotNet.CombineEnums regexOptions option
    )
    DotNetObject regexClass pattern regexOptions
  )

  fileIn (getFullPath @"..\definitionPool.ms")
  testDef = ::standardDefinitionPool[@"PathUtility.ms"]
  testObj = testDef()
  /* Setup End -------------------------------------------------------------- */
  sw.Start()
  /* Test Start ------------------------------------------------------------- */
  /* ChangeExtension */
  -- ピリオド付き
  actual = ::TestValueStruct (testObj.ChangeExtension @"C:\File.txt" ".ms")
  expected = ::TestValueStruct @"C:\File.ms"
  assert (actual.Equals expected == true)
  -- ピリオド無し
  actual = ::TestValueStruct (testObj.ChangeExtension @"C:\File.txt" "ms")
  expected = ::TestValueStruct @"C:\File.ms"
  assert (actual.Equals expected == true)
  -- 空文字
  actual = ::TestValueStruct (testObj.ChangeExtension @"C:\File.txt" "")
  expected = ::TestValueStruct @"C:\File."
  assert (actual.Equals expected == true)

  /* GetBaseDirectory */
  -- 現ディレクトリ
  testObj = testDef currentDir
  actual = ::TestValueStruct (testObj.GetBaseDirectory())
  expected = ::TestValueStruct currentDir
  assert (actual.Equals expected == true)
  -- 構造体定義ファイルのあるディレクトリ
  testObj = testDef()
  actual = ::TestValueStruct (testObj.GetBaseDirectory())
  expected = ::TestValueStruct parentDir
  assert (actual.Equals expected == true)

  /* GetDirectoryName */
  -- 空文字
  actual = ::TestValueStruct (testObj.GetDirectoryName @"")
  expected = ::TestValueStruct @""
  assert (actual.Equals expected == true)
  -- ファイル
  actual = ::TestValueStruct (testObj.GetDirectoryName @"C:\Dir\File.ext")
  expected = ::TestValueStruct @"C:\Dir"
  assert (actual.Equals expected == true)
  -- ディレクトリ（末尾区切り文字）
  actual = ::TestValueStruct (testObj.GetDirectoryName @"C:\Dir\")
  expected = ::TestValueStruct @"C:\Dir"
  assert (actual.Equals expected == true)
  -- ディレクトリ
  actual = ::TestValueStruct (testObj.GetDirectoryName @"C:\Dir")
  expected = ::TestValueStruct @"C:\"
  assert (actual.Equals expected == true)
  -- ルートディレクトリ
  actual = ::TestValueStruct (testObj.GetDirectoryName @"C:\")
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)

  /* GetExtension */
  -- 絶対パス
  actual = ::TestValueStruct (testObj.GetExtension @"C:\File.ext")
  expected = ::TestValueStruct ".ext"
  assert (actual.Equals expected == true)
  -- 相対パス
  actual = ::TestValueStruct (testObj.GetExtension @".\File.ext")
  expected = ::TestValueStruct ".ext"
  assert (actual.Equals expected == true)
  -- 拡張し無し
  actual = ::TestValueStruct (testObj.GetExtension @"C:\File")
  expected = ::TestValueStruct ""
  assert (actual.Equals expected == true)

  /* GetFileName */
  -- 相対パス
  actual = ::TestValueStruct (testObj.GetFileName @".\Dir\File.ext")
  expected = ::TestValueStruct "File.ext"
  assert (actual.Equals expected == true)
  -- 絶対パス
  actual = ::TestValueStruct (testObj.GetFileName @"C:\Dir\File.ext")
  expected = ::TestValueStruct "File.ext"
  assert (actual.Equals expected == true)
  -- 絶対パス（末尾ピリオド）
  actual = ::TestValueStruct (testObj.GetFileName @"C:\Dir\File.")
  expected = ::TestValueStruct "File."
  assert (actual.Equals expected == true)
  -- 絶対パス（拡張子のみ）
  actual = ::TestValueStruct (testObj.GetFileName @"C:\Dir\.ext")
  expected = ::TestValueStruct ".ext"
  assert (actual.Equals expected == true)
  -- ディレクトリ（末尾区切り文字）
  actual = ::TestValueStruct (testObj.GetFileName @"C:\Dir\")
  expected = ::TestValueStruct ""
  assert (actual.Equals expected == true)
  -- ディレクトリ
  actual = ::TestValueStruct (testObj.GetFileName @"C:\Dir")
  expected = ::TestValueStruct "Dir"
  assert (actual.Equals expected == true)
  -- ルートディレクトリ
  actual = ::TestValueStruct (testObj.GetFileName @"C:\")
  expected = ::TestValueStruct ""
  assert (actual.Equals expected == true)
  -- ルートディレクトリ（末尾ボリューム区切り記号）
  actual = ::TestValueStruct (testObj.GetFileName @"C:")
  expected = ::TestValueStruct ""
  assert (actual.Equals expected == true)

  /* GetFileNameWithoutExtension */
  -- 相対パス
  actual = ::TestValueStruct (testObj.GetFileNameWithoutExtension @".\Dir\File.ext")
  expected = ::TestValueStruct "File"
  assert (actual.Equals expected == true)
  -- 絶対パス
  actual = ::TestValueStruct (testObj.GetFileNameWithoutExtension @"C:\Dir\File.ext")
  expected = ::TestValueStruct "File"
  assert (actual.Equals expected == true)
  -- 絶対パス（末尾ピリオド）
  actual = ::TestValueStruct (testObj.GetFileNameWithoutExtension @"C:\Dir\File.")
  expected = ::TestValueStruct "File"
  assert (actual.Equals expected == true)
  -- 絶対パス（拡張子のみ）
  actual = ::TestValueStruct (testObj.GetFileNameWithoutExtension @"C:\Dir\.ext")
  expected = ::TestValueStruct ""
  assert (actual.Equals expected == true)
  -- ディレクトリ（末尾区切り文字）
  actual = ::TestValueStruct (testObj.GetFileNameWithoutExtension @"C:\Dir\")
  expected = ::TestValueStruct ""
  assert (actual.Equals expected == true)
  -- ディレクトリ
  actual = ::TestValueStruct (testObj.GetFileNameWithoutExtension @"C:\Dir")
  expected = ::TestValueStruct "Dir"
  assert (actual.Equals expected == true)
  -- ルートディレクトリ
  actual = ::TestValueStruct (testObj.GetFileNameWithoutExtension @"C:\")
  expected = ::TestValueStruct ""
  assert (actual.Equals expected == true)
  -- ルートディレクトリ（末尾ボリューム区切り記号）
  actual = ::TestValueStruct (testObj.GetFileNameWithoutExtension @"C:")
  expected = ::TestValueStruct ""
  assert (actual.Equals expected == true)

  /* GetFullPath */
  -- 空文字
  actual = ::TestValueStruct (testObj.GetFullPath @"")
  expected = ::TestValueStruct @""
  assert (actual.Equals expected == true)
  -- 絶対パス
  testObj = testDef()
  actual = ::TestValueStruct (testObj.GetFullPath @"C:\Dir\File.ext")
  expected = ::TestValueStruct @"C:\Dir\File.ext"
  assert (actual.Equals expected == true)
  -- 絶対パス（ベースディレクトリ指定）
  testObj = testDef currentDir
  actual = ::TestValueStruct (testObj.GetFullPath @"C:\Dir\File.ext")
  expected = ::TestValueStruct @"C:\Dir\File.ext"
  assert (actual.Equals expected == true)
  -- 相対パス
  testObj = testDef()
  actual = ::TestValueStruct (testObj.GetFullPath @".\Dir\File.ext")
  expected = ::TestValueStruct (parentDir + @"\Dir\File.ext")
  assert (actual.Equals expected == true)
  -- 相対パス（ベースディレクトリ指定）
  testObj = testDef currentDir
  actual = ::TestValueStruct (testObj.GetFullPath @"..\Dir\File.ext")
  expected = ::TestValueStruct (parentDir + @"\Dir\File.ext")
  assert (actual.Equals expected == true)

  /* GetInvalidFileNameChars */
  local invalidFileNameInt = #(34, 60, 62, 124, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 58, 42, 63, 92, 47)
  local invalidFileNameChar = for i in invalidFileNameInt collect Bit.IntAsChar i
  actual = ::TestValueStruct (testObj.GetInvalidFileNameChars())
  expected = ::TestValueStruct invalidFileNameChar
  assert (actual.Equals expected == true)

  /* GetInvalidPathChars */
  local invalidPathInt = #(34, 60, 62, 124, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31)
  local invalidPathChar = for i in invalidPathInt collect Bit.IntAsChar i
  actual = ::TestValueStruct (testObj.GetInvalidPathChars())
  expected = ::TestValueStruct invalidPathChar
  assert (actual.Equals expected == true)

  /* GetPathRoot */
  -- 空文字
  actual = ::TestValueStruct (testObj.GetPathRoot @"")
  expected = ::TestValueStruct @""
  assert (actual.Equals expected == true)
  -- 絶対パス
  actual = ::TestValueStruct (testObj.GetPathRoot @"C:\Dir\File.ext")
  expected = ::TestValueStruct @"C:\"
  assert (actual.Equals expected == true)
  -- 相対パス
  actual = ::TestValueStruct (testObj.GetPathRoot @".\File.ext")
  expected = ::TestValueStruct ""
  assert (actual.Equals expected == true)
  -- ディレクトリ
  actual = ::TestValueStruct (testObj.GetPathRoot @"C:\Dir")
  expected = ::TestValueStruct @"C:\"
  assert (actual.Equals expected == true)
  -- ルートディレクトリ
  actual = ::TestValueStruct (testObj.GetPathRoot @"C:\")
  expected = ::TestValueStruct @"C:\"
  assert (actual.Equals expected == true)
  -- ルートディレクトリ（末尾ボリューム区切り記号）
  actual = ::TestValueStruct (testObj.GetPathRoot @"C:")
  expected = ::TestValueStruct @"C:"
  assert (actual.Equals expected == true)

  /* GetRandomFileName */
  regex = createRegex "\w{8}\.\w{3}" #(#IgnoreCase, #Singleline)
  actual = ::TestValueStruct (regex.IsMatch (testObj.GetRandomFileName()))
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)

  /* HasExtension */
  -- 絶対パス
  actual = ::TestValueStruct (testObj.HasExtension @"C:\Dir\File.ext")
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- 相対パス
  actual = ::TestValueStruct (testObj.HasExtension @".\File.ext")
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- ディレクトリ
  actual = ::TestValueStruct (testObj.HasExtension @"C:\Dir")
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)
  -- ルートディレクトリ
  actual = ::TestValueStruct (testObj.HasExtension @"C:\")
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)

  /* IsPathRooted */
  -- 絶対パス
  actual = ::TestValueStruct (testObj.IsPathRooted @"C:\Dir\File.ext")
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- 相対パス
  actual = ::TestValueStruct (testObj.IsPathRooted @".\File.ext")
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)
  -- ディレクトリ
  actual = ::TestValueStruct (testObj.IsPathRooted @"C:\Dir")
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- ルートディレクトリ
  actual = ::TestValueStruct (testObj.IsPathRooted @"C:\")
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- ルートディレクトリ（末尾ボリューム区切り記号）
  actual = ::TestValueStruct (testObj.IsPathRooted @"C:")
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- UNCパス
  actual = ::TestValueStruct (testObj.IsPathRooted @"\\Server\Volume")
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)

  /* SetBaseDirectory */
  -- ファイルパス
  actual = ::TestValueStruct (testObj.SetBaseDirectory @"C:\Dir\File.ext")
  expected = ::TestValueStruct @"C:\Dir"
  assert (actual.Equals expected == true)
  -- ディレクトリパス
  actual = ::TestValueStruct (testObj.SetBaseDirectory @"C:\Dir")
  expected = ::TestValueStruct @"C:\Dir"
  assert (actual.Equals expected == true)
  -- ディレクトリパス（末尾区切り文字）
  actual = ::TestValueStruct (testObj.SetBaseDirectory @"C:\Dir\")
  expected = ::TestValueStruct @"C:\Dir"
  assert (actual.Equals expected == true)
  -- ルートディレクトリ
  actual = ::TestValueStruct (testObj.SetBaseDirectory @"C:\")
  expected = ::TestValueStruct @"C:\"
  assert (actual.Equals expected == true)
  -- ルートディレクトリ（末尾ボリューム区切り記号）
  actual = ::TestValueStruct (testObj.SetBaseDirectory @"C:")
  expected = ::TestValueStruct @"C:"
  assert (actual.Equals expected == true)

  /* TrimEndSeparator */
  -- 絶対パス
  actual = ::TestValueStruct (testObj.TrimEndSeparator @"C:\Dir\File.ext")
  expected = ::TestValueStruct @"C:\Dir\File.ext"
  assert (actual.Equals expected == true)
  -- 相対パス
  actual = ::TestValueStruct (testObj.TrimEndSeparator @".\File.ext")
  expected = ::TestValueStruct @".\File.ext"
  assert (actual.Equals expected == true)
  -- ディレクトリ
  actual = ::TestValueStruct (testObj.TrimEndSeparator @"C:\Dir")
  expected = ::TestValueStruct @"C:\Dir"
  assert (actual.Equals expected == true)
  -- ディレクトリ（末尾区切り文字）
  actual = ::TestValueStruct (testObj.TrimEndSeparator @"C:\Dir\")
  expected = ::TestValueStruct @"C:\Dir"
  assert (actual.Equals expected == true)
  -- ルートディレクトリ
  actual = ::TestValueStruct (testObj.TrimEndSeparator @"C:\")
  expected = ::TestValueStruct @"C:\"
  assert (actual.Equals expected == true)
  -- ルートディレクトリ（末尾ボリューム区切り記号）
  actual = ::TestValueStruct (testObj.TrimEndSeparator @"C:")
  expected = ::TestValueStruct @"C:"
  assert (actual.Equals expected == true)
  -- UNCパス
  actual = ::TestValueStruct (testObj.TrimEndSeparator @"\\Server\Volume")
  expected = ::TestValueStruct @"\\Server\Volume"
  assert (actual.Equals expected == true)
  /* Test End --------------------------------------------------------------- */
  sw.Stop()
  /* Teardown Start --------------------------------------------------------- */
  /* Teardown End ----------------------------------------------------------- */
  format "[end %]%ms\n" nowTime (sw.ElapsedMilliseconds as Integer)
  ok
)
