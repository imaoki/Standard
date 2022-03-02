/*! © 2021 imaoki | MIT License | https://github.com/imaoki */
(
  -- clearListener()

  local nowTime = (DotNetClass "System.DateTime").Now.ToString "HH:mm:ss"
  local sw = DotNetObject "System.Diagnostics.Stopwatch"

  local currentFile = getSourceFileName()
  local pathUtility = ::std.PathUtilityStruct currentFile

  local actual
  local expected
  local testDef
  local testObj

  format "[run %]@\"%\"\n" nowTime currentFile
  /* Setup Start ------------------------------------------------------------ */
  local TestToolStruct = struct TestToolStruct (
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
      ::std.DotNetUtility.TypeOf obj == "System.DateTime"
    ),

    public fn NotFoobar element index context = (
      classOf element == String \
          and not matchPattern element pattern:"*foo.bar" ignoreCase:true
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

  local fileDir = pathUtility.GetFullPath @".\Data\File"
  local testDir = pathUtility.GetFullPath @".\Data\File\Test"
  local testSubDir = pathUtility.GetFullPath @".\Data\File\Test\Sub"

  local dummyFile = pathUtility.GetFullPath @".\Data\File\Dummy\dummy.txt"
  local shiftJisFile = pathUtility.GetFullPath @".\Data\File\shiftJis.txt"
  local utf8nFile = pathUtility.GetFullPath @".\Data\File\utf8n.txt"

  local max2015File = pathUtility.GetFullPath @".\Data\File\2015.max"
  local max2016File = pathUtility.GetFullPath @".\Data\File\2016.max"
  local max2017File = pathUtility.GetFullPath @".\Data\File\2017.max"
  local max2018File = pathUtility.GetFullPath @".\Data\File\2018.max"

  local hiddenDir = pathUtility.GetFullPath @".\Data\File\Hidden"
  local readOnlyDir = pathUtility.GetFullPath @".\Data\File\ReadOnly"

  local hiddenFile = pathUtility.GetFullPath @".\Data\File\hidden.txt"
  local readOnlyFile = pathUtility.GetFullPath @".\Data\File\readOnly.txt"

  local booleanFile = pathUtility.GetFullPath @".\Data\File\returnBooleanClass.ms"
  local integerFile = pathUtility.GetFullPath @".\Data\File\returnInteger.ms"
  local stringFile = pathUtility.GetFullPath @".\Data\File\returnString.ms"

  local destDir
  local destDirs
  local destFile
  local destFiles
  local sourceDir
  local sourceFile

  testDef = fileIn (pathUtility.GetFullPath @"..\FileUtility.ms")
  testObj = testDef()
  /* Setup End -------------------------------------------------------------- */
  sw.Start()
  /* Test Start ------------------------------------------------------------- */
  /* CopyDirectory */
  expected = ::TestValueStruct true
  sourceDir = pathUtility.GetFullPath @".\Data\File\FileStructure\Recursive"
  destDir = pathUtility.GetFullPath @".\Data\File\FileStructure\CopiedRecursive"
  destDirs = #(
    destDir,
    destDir + @"\Single"
  )
  destFiles = #(
    destDir + @"\Single\StructA.ms",
    destDir + @"\Single\StructA.ms",
    destDir + @"\StructA.ms",
    destDir + @"\StructA.ms"
  )
  -- 新規コピー
  testObj.CopyDirectory sourceDir destDir
  for dir in destDirs do (
    actual = ::TestValueStruct (testTool.DirectoryExists dir)
    assert (actual.Equals expected == true)
  )
  for file in destFiles do (
    actual = ::TestValueStruct (testTool.FileExists file)
    assert (actual.Equals expected == true)
  )
  -- 上書きしない
  testObj.CopyDirectory sourceDir destDir
  for dir in destDirs do (
    actual = ::TestValueStruct (testTool.DirectoryExists dir)
    assert (actual.Equals expected == true)
  )
  for file in destFiles do (
    actual = ::TestValueStruct (testTool.FileExists file)
    assert (actual.Equals expected == true)
  )
  -- 上書きする
  testObj.CopyDirectory sourceDir destDir overwrite:true
  for dir in destDirs do (
    actual = ::TestValueStruct (testTool.DirectoryExists dir)
    assert (actual.Equals expected == true)
  )
  for file in destFiles do (
    actual = ::TestValueStruct (testTool.FileExists file)
    assert (actual.Equals expected == true)
  )
  -- 後処理
  assert (testTool.DeleteDirectory destDir == true)

  /* CopyFile */
  destFile = pathUtility.GetFullPath @".\Data\File\copyDest.txt"
  -- 前処理
  assert (testTool.CreateShiftJisFile shiftJisFile "あいうえお\nABCDEFG\n" == true)
  assert (testTool.CreateUtf8nFile utf8nFile "" == true)
  -- 新規コピー
  testObj.CopyFile utf8nFile destFile
  actual = ::TestValueStruct (testTool.FileExists destFile)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- 確認
  actual = ::TestValueStruct (testTool.ReadUtf8nFile destFile)
  expected = ::TestValueStruct ""
  assert (actual.Equals expected == true)
  -- 上書きしない
  testObj.CopyFile shiftJisFile destFile
  actual = ::TestValueStruct (testTool.FileExists destFile)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- 確認
  actual = ::TestValueStruct (testTool.ReadUtf8nFile destFile)
  expected = ::TestValueStruct ""
  assert (actual.Equals expected == true)
  -- 上書きする
  testObj.CopyFile shiftJisFile destFile overwrite:true
  actual = ::TestValueStruct (testTool.FileExists destFile)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- 確認
  actual = ::TestValueStruct (testTool.ReadShiftJisFile destFile)
  expected = ::TestValueStruct "あいうえお\nABCDEFG\n"
  assert (actual.Equals expected == true)
  -- 後処理
  assert (testTool.DeleteFile destFile == true)
  assert (testTool.DeleteFile shiftJisFile == true)
  assert (testTool.DeleteFile utf8nFile == true)

  /* CreateDirectory */
  actual = ::TestValueStruct (testTool.DirectoryExists testDir)
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)
  -- 新規作成
  testObj.CreateDirectory testDir
  actual = ::TestValueStruct (testTool.DirectoryExists testDir)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- 後処理
  assert (testTool.DeleteDirectory testDir == true)

  /* CreateTextFile */
  actual = ::TestValueStruct (testObj.CreateTextFile utf8nFile)
  assert (actual.IsFileStream() == true)
  testTool.CloseFile (actual.GetValue())
  -- 後処理
  assert (testTool.DeleteFile utf8nFile == true)

  /* DeleteDirectory */
  -- 前処理
  assert (testTool.CreateDirectory testSubDir == true)
  -- 消えない
  testObj.DeleteDirectory testDir recursive:false
  actual = ::TestValueStruct (testTool.DirectoryExists testDir)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- 消える
  testObj.DeleteDirectory testDir recursive:true
  actual = ::TestValueStruct (testTool.DirectoryExists testDir)
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)

  /* DeleteFile */
  -- 前処理
  assert (testTool.CreateUtf8nFile utf8nFile "" == true)
  -- 削除
  testObj.DeleteFile utf8nFile
  actual = ::TestValueStruct (testTool.FileExists utf8nFile)
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)

  /* DirectoryExists */
  -- 確認
  actual = ::TestValueStruct (testObj.DirectoryExists testDir)
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)
  -- 作成
  assert (testTool.CreateDirectory testDir == true)
  -- 確認
  actual = ::TestValueStruct (testObj.DirectoryExists testDir)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- 後処理
  assert (testTool.DeleteDirectory testDir == true)

  /* EvaluateFile */
  -- returnBooleanClass.ms
  actual = ::TestValueStruct (testObj.EvaluateFile booleanFile)
  assert (actual.IsBoolean() == true)
  -- returnInteger.ms
  actual = ::TestValueStruct (testObj.EvaluateFile integerFile)
  assert (actual.IsInteger() == true)
  -- returnString.ms
  actual = ::TestValueStruct (testObj.EvaluateFile stringFile)
  assert (actual.IsString() == true)

  /* FileExists */
  -- 前処理
  assert (testTool.CreateUtf8nFile utf8nFile "" == true)
  -- 確認
  actual = ::TestValueStruct (testObj.FileExists utf8nFile)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- 後処理
  assert (testTool.DeleteFile utf8nFile == true)

  /* GetCreationTime */
  -- ディレクトリ前処理
  assert (testTool.CreateDirectory testDir == true)
  -- ディレクトリ確認
  actual = ::TestValueStruct (testObj.GetCreationTime testDir)
  assert (actual.IsDotNetObject() == true)
  assert (testTool.IsDateTimeType (actual.GetValue()) == true)
  -- ディレクトリ後処理
  assert (testTool.DeleteDirectory testDir == true)

  -- ファイル前処理
  assert (testTool.CreateUtf8nFile utf8nFile "" == true)
  -- ファイル確認
  actual = ::TestValueStruct (testObj.GetCreationTime utf8nFile)
  assert (actual.IsDotNetObject() == true)
  assert (testTool.IsDateTimeType (actual.GetValue()) == true)
  -- ファイル後処理
  assert (testTool.DeleteFile utf8nFile == true)

  /* GetDirectories */
  -- 直下ディレクトリのみ
  actual = ::TestValueStruct (testObj.GetDirectories fileDir "*")
  expected = ::TestValueStruct #(
    pathUtility.GetFullPath @".\Data\File\FileStructure",
    pathUtility.GetFullPath @".\Data\File\Hidden",
    pathUtility.GetFullPath @".\Data\File\ReadOnly"
  )
  assert (actual.Equals expected == true)
  -- 全てのサブディレクトリ
  actual = ::TestValueStruct (testObj.GetDirectories fileDir "*" recursive:true)
  expected = ::TestValueStruct #(
    pathUtility.GetFullPath @".\Data\File\FileStructure",
    pathUtility.GetFullPath @".\Data\File\FileStructure\foo.bar",
    pathUtility.GetFullPath @".\Data\File\FileStructure\Recursive",
    pathUtility.GetFullPath @".\Data\File\FileStructure\Recursive\Single",
    pathUtility.GetFullPath @".\Data\File\FileStructure\Single",
    pathUtility.GetFullPath @".\Data\File\Hidden",
    pathUtility.GetFullPath @".\Data\File\ReadOnly"
  )
  assert (actual.Equals expected == true)
  -- ワイルドカード
  actual = ::TestValueStruct (testObj.GetDirectories fileDir @"*\Single*" recursive:true)
  expected = ::TestValueStruct #(
    pathUtility.GetFullPath @".\Data\File\FileStructure\Recursive\Single",
    pathUtility.GetFullPath @".\Data\File\FileStructure\Single"
  )
  assert (actual.Equals expected == true)

  /* GetFiles */
  -- 直下ディレクトリのみ
  actual = ::TestValueStruct (testObj.GetFiles fileDir "*")
  expected = ::TestValueStruct #(
    pathUtility.GetFullPath @".\Data\File\2015.max",
    pathUtility.GetFullPath @".\Data\File\2016.max",
    pathUtility.GetFullPath @".\Data\File\2017.max",
    pathUtility.GetFullPath @".\Data\File\2018.max",
    pathUtility.GetFullPath @".\Data\File\hidden.txt",
    pathUtility.GetFullPath @".\Data\File\readOnly.txt",
    pathUtility.GetFullPath @".\Data\File\returnBooleanClass.ms",
    pathUtility.GetFullPath @".\Data\File\returnInteger.ms",
    pathUtility.GetFullPath @".\Data\File\returnString.ms"
  )
  assert (actual.Equals expected == true)
  -- 全てのサブディレクトリ
  actual = ::TestValueStruct (testObj.GetFiles fileDir "*" recursive:true)
  expected = ::TestValueStruct #(
    pathUtility.GetFullPath @".\Data\File\2015.max",
    pathUtility.GetFullPath @".\Data\File\2016.max",
    pathUtility.GetFullPath @".\Data\File\2017.max",
    pathUtility.GetFullPath @".\Data\File\2018.max",
    pathUtility.GetFullPath @".\Data\File\FileStructure\foo.bar\foo.bar",
    pathUtility.GetFullPath @".\Data\File\FileStructure\Recursive\Single\foo.bar",
    pathUtility.GetFullPath @".\Data\File\FileStructure\Recursive\Single\StructA.ms",
    pathUtility.GetFullPath @".\Data\File\FileStructure\Recursive\Single\StructB.ms",
    pathUtility.GetFullPath @".\Data\File\FileStructure\Recursive\Single\testAttribute.ms",
    pathUtility.GetFullPath @".\Data\File\FileStructure\Recursive\Single\testRollout.ms",
    pathUtility.GetFullPath @".\Data\File\FileStructure\Recursive\StructA.ms",
    pathUtility.GetFullPath @".\Data\File\FileStructure\Recursive\StructB.ms",
    pathUtility.GetFullPath @".\Data\File\FileStructure\Single\foo.bar",
    pathUtility.GetFullPath @".\Data\File\FileStructure\Single\StructA.ms",
    pathUtility.GetFullPath @".\Data\File\FileStructure\Single\StructB.ms",
    pathUtility.GetFullPath @".\Data\File\FileStructure\Single\testAttribute.ms",
    pathUtility.GetFullPath @".\Data\File\FileStructure\Single\testRollout.ms",
    pathUtility.GetFullPath @".\Data\File\hidden.txt",
    pathUtility.GetFullPath @".\Data\File\readOnly.txt",
    pathUtility.GetFullPath @".\Data\File\returnBooleanClass.ms",
    pathUtility.GetFullPath @".\Data\File\returnInteger.ms",
    pathUtility.GetFullPath @".\Data\File\returnString.ms"
  )
  assert (actual.Equals expected == true)
  -- ワイルドカード
  actual = ::TestValueStruct (testObj.GetFiles fileDir @"*\Struct*.ms" recursive:true)
  expected = ::TestValueStruct #(
    pathUtility.GetFullPath @".\Data\File\FileStructure\Recursive\Single\StructA.ms",
    pathUtility.GetFullPath @".\Data\File\FileStructure\Recursive\Single\StructB.ms",
    pathUtility.GetFullPath @".\Data\File\FileStructure\Recursive\StructA.ms",
    pathUtility.GetFullPath @".\Data\File\FileStructure\Recursive\StructB.ms",
    pathUtility.GetFullPath @".\Data\File\FileStructure\Single\StructA.ms",
    pathUtility.GetFullPath @".\Data\File\FileStructure\Single\StructB.ms"
  )
  assert (actual.Equals expected == true)

  /* GetLastAccessTime */
  -- ディレクトリ前処理
  assert (testTool.CreateDirectory testDir == true)
  -- ディレクトリ確認
  actual = ::TestValueStruct (testObj.GetLastAccessTime testDir)
  assert (actual.IsDotNetObject() == true)
  assert (testTool.IsDateTimeType (actual.GetValue()) == true)
  -- ディレクトリ後処理
  assert (testTool.DeleteDirectory testDir == true)

  -- ファイル前処理
  assert (testTool.CreateUtf8nFile utf8nFile "" == true)
  -- ファイル確認
  actual = ::TestValueStruct (testObj.GetLastAccessTime utf8nFile)
  assert (actual.IsDotNetObject() == true)
  assert (testTool.IsDateTimeType (actual.GetValue()) == true)
  -- ファイル後処理
  assert (testTool.DeleteFile utf8nFile == true)

  /* GetLastWriteTime */
  -- ディレクトリ前処理
  assert (testTool.CreateDirectory testDir == true)
  -- ディレクトリ確認
  actual = ::TestValueStruct (testObj.GetLastWriteTime testDir)
  assert (actual.IsDotNetObject() == true)
  assert (testTool.IsDateTimeType (actual.GetValue()) == true)
  -- ディレクトリ後処理
  assert (testTool.DeleteDirectory testDir == true)

  -- ファイル前処理
  assert (testTool.CreateUtf8nFile utf8nFile "" == true)
  -- ファイル確認
  actual = ::TestValueStruct (testObj.GetLastWriteTime utf8nFile)
  assert (actual.IsDotNetObject() == true)
  assert (testTool.IsDateTimeType (actual.GetValue()) == true)
  -- ファイル後処理
  assert (testTool.DeleteFile utf8nFile == true)

  /* GetMaxVersion */
  -- 2015
  actual = ::TestValueStruct (testObj.GetMaxVersion max2015File)
  expected = ::TestValueStruct 2015
  assert (actual.Equals expected == true)
  -- 2018
  actual = ::TestValueStruct (testObj.GetMaxVersion max2018File)
  expected = ::TestValueStruct 2018
  assert (actual.Equals expected == true)

  /* IsHidden */
  -- ディレクトリFalse
  actual = ::TestValueStruct (testObj.IsHidden fileDir)
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)
  -- ディレクトリTrue
  actual = ::TestValueStruct (testObj.IsHidden hiddenDir)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- ファイル
  actual = ::TestValueStruct (testObj.IsHidden hiddenFile)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)

  /* IsMaxFile */
  actual = ::TestValueStruct (testObj.IsMaxFile max2015File)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)

  /* IsReadOnly */
  -- ディレクトリFalse
  actual = ::TestValueStruct (testObj.IsReadOnly fileDir)
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)
  -- ディレクトリTrue
  actual = ::TestValueStruct (testObj.IsReadOnly readOnlyDir)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- ファイル
  actual = ::TestValueStruct (testObj.IsReadOnly readOnlyFile)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)

  /* IsScriptFile */
  -- returnString.ms
  actual = ::TestValueStruct (testObj.IsScriptFile stringFile)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- readOnly.txt
  actual = ::TestValueStruct (testObj.IsScriptFile readOnlyFile)
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)

  /* MoveDirectory */
  -- ディレクトリ
  sourceDir = pathUtility.GetFullPath @".\Data\File\FileStructure\Recursive\Test"
  destDir = pathUtility.GetFullPath @".\Data\File\FileStructure\Single"
  local resultDir = pathUtility.GetFullPath @".\Data\File\FileStructure\Single\Test"
  -- ディレクトリ前処理
  assert (testTool.CreateDirectory sourceDir == true)
  -- ディレクトリ確認
  testObj.MoveDirectory sourceDir destDir
  actual = ::TestValueStruct (testTool.DirectoryExists resultDir)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- ディレクトリ後処理
  assert (testTool.DeleteDirectory resultDir == true)

  -- ファイル
  destDir = pathUtility.GetFullPath @".\Data\File\FileStructure"
  local resultFile = pathUtility.GetFullPath @".\Data\File\FileStructure\utf8n.txt"
  -- ファイル前処理
  assert (testTool.CreateUtf8nFile utf8nFile "" == true)
  -- ファイル確認
  actual = ::TestValueStruct (testObj.MoveDirectory utf8nFile destDir)
  assert (testTool.FileExists resultFile == true)
  -- ファイル後処理
  assert (testTool.DeleteFile resultFile == true)

  /* OpenTextFile */
  -- 前処理
  assert (testTool.CreateUtf8nFile utf8nFile "" == true)
  -- 確認
  actual = ::TestValueStruct (testObj.OpenTextFile utf8nFile)
  assert (actual.IsFileStream() == true)
  testTool.CloseFile (actual.GetValue())
  -- 後処理
  assert (testTool.DeleteFile utf8nFile == true)

  /* ReadAllLines */
  -- ファイルが存在しない場合は失敗する
  actual = ::TestValueStruct (testObj.ReadAllLines dummyFile)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)

  -- Shift-JIS前処理
  assert (testTool.CreateShiftJisFile shiftJisFile "あいうえお\nABCDEFG\n" == true)
  -- Shift-JIS確認
  actual = ::TestValueStruct (testObj.ReadAllLines shiftJisFile encoding:"shift_jis")
  expected = ::TestValueStruct #("あいうえお", "ABCDEFG")
  assert (actual.Equals expected == true)
  -- Shift-JIS後処理
  assert (testTool.DeleteFile shiftJisFile == true)

  -- UTF-8N前処理
  assert (testTool.CreateUtf8nFile utf8nFile "あいうえお\nABCDEFG\n" == true)
  -- UTF-8N確認
  actual = ::TestValueStruct (testObj.ReadAllLines utf8nFile)
  expected = ::TestValueStruct #("あいうえお", "ABCDEFG")
  assert (actual.Equals expected == true)
  -- UTF-8N後処理
  assert (testTool.DeleteFile utf8nFile == true)

  /* ReadAllText */
  -- ファイルが存在しない場合は失敗する
  actual = ::TestValueStruct (testObj.ReadAllText dummyFile)
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)

  -- Shift-JIS前処理
  assert (testTool.CreateShiftJisFile shiftJisFile "あいうえお\nABCDEFG\n" == true)
  -- Shift-JIS確認
  actual = ::TestValueStruct (testObj.ReadAllText shiftJisFile encoding:"shift_jis")
  expected = ::TestValueStruct "あいうえお\nABCDEFG\n"
  assert (actual.Equals expected == true)
  -- Shift-JIS後処理
  assert (testTool.DeleteFile shiftJisFile == true)

  -- UTF-8N前処理
  assert (testTool.CreateUtf8nFile utf8nFile "あいうえお\nABCDEFG\n" == true)
  -- UTF-8N確認
  actual = ::TestValueStruct (testObj.ReadAllText utf8nFile)
  expected = ::TestValueStruct "あいうえお\nABCDEFG\n"
  assert (actual.Equals expected == true)
  -- UTF-8N後処理
  assert (testTool.DeleteFile utf8nFile == true)

  /* RenameDirectory */
  sourceDir = pathUtility.GetFullPath @".\Data\File\FileStructure\Recursive\Test"
  destDir = pathUtility.GetFullPath @".\Data\File\FileStructure\Recursive\RenamedTest"
  -- 前処理
  assert (testTool.CreateDirectory sourceDir == true)
  -- 確認
  testObj.RenameDirectory sourceDir "RenamedTest"
  actual = ::TestValueStruct (testTool.DirectoryExists destDir)
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- 後処理
  assert (testTool.DeleteDirectory destDir == true)

  /* RenameFile */
  local utf8nRenamedFile = pathUtility.GetFullPath @".\Data\File\utf8nRenamed.txt"
  -- 拡張子有り前処理
  assert (testTool.CreateUtf8nFile utf8nFile "" == true)
  -- 拡張子有り確認
  actual = ::TestValueStruct (testObj.RenameFile utf8nFile "utf8nRenamed.txt")
  assert (testTool.FileExists utf8nRenamedFile == true)
  -- 拡張子有り後処理
  assert (testTool.DeleteFile utf8nRenamedFile == true)

  -- 拡張子無し前処理
  assert (testTool.CreateUtf8nFile utf8nFile "" == true)
  -- 拡張子無し確認
  actual = ::TestValueStruct (testObj.RenameFile utf8nFile "utf8nRenamed")
  assert (testTool.FileExists utf8nRenamedFile == true)
  -- 拡張子無し後処理
  assert (testTool.DeleteFile utf8nRenamedFile == true)

  /* WriteAllLines */
  -- ディレクトリが存在しない場合は失敗する
  testObj.WriteAllLines dummyFile #("あいうえお", "ABCDEFG")
  actual = ::TestValueStruct (testTool.FileExists dummyFile)
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)

  -- Shift-JIS前処理
  assert (testTool.CreateShiftJisFile shiftJisFile "" == true)
  -- Shift-JIS確認
  testObj.WriteAllLines shiftJisFile #("あいうえお", "ABCDEFG") encoding:"shift_jis"
  actual = ::TestValueStruct (testTool.ReadShiftJisFile shiftJisFile)
  expected = ::TestValueStruct "あいうえお\nABCDEFG\n"
  assert (actual.Equals expected == true)
  -- Shift-JIS後処理
  assert (testTool.DeleteFile shiftJisFile == true)

  -- UTF-8N前処理
  assert (testTool.CreateUtf8nFile utf8nFile "" == true)
  -- UTF-8N確認
  testObj.WriteAllLines utf8nFile #("あいうえお", "ABCDEFG")
  actual = ::TestValueStruct (testTool.ReadUtf8nFile utf8nFile)
  expected = ::TestValueStruct "あいうえお\nABCDEFG\n"
  assert (actual.Equals expected == true)
  -- UTF-8N後処理
  assert (testTool.DeleteFile utf8nFile == true)

  /* WriteAllText */
  -- ディレクトリが存在しない場合は失敗する
  testObj.WriteAllText dummyFile ""
  actual = ::TestValueStruct (testTool.FileExists dummyFile)
  expected = ::TestValueStruct false
  assert (actual.Equals expected == true)

  -- Shift-JIS前処理
  assert (testTool.CreateShiftJisFile shiftJisFile "" == true)
  -- Shift-JIS確認
  testObj.WriteAllText shiftJisFile "あいうえお\nABCDEFG\n" encoding:"shift_jis"
  actual = ::TestValueStruct (testTool.ReadShiftJisFile shiftJisFile)
  expected = ::TestValueStruct "あいうえお\nABCDEFG\n"
  assert (actual.Equals expected == true)
  -- Shift-JIS後処理
  assert (testTool.DeleteFile shiftJisFile == true)

  -- UTF-8N前処理
  assert (testTool.CreateUtf8nFile utf8nFile "" == true)
  -- UTF-8N確認
  testObj.WriteAllText utf8nFile "あいうえお\nABCDEFG\n"
  actual = ::TestValueStruct (testTool.ReadUtf8nFile utf8nFile)
  expected = ::TestValueStruct "あいうえお\nABCDEFG\n"
  assert (actual.Equals expected == true)
  -- UTF-8N後処理
  assert (testTool.DeleteFile utf8nFile == true)
  /* Test End --------------------------------------------------------------- */
  sw.Stop()
  /* Teardown Start --------------------------------------------------------- */
  /* Teardown End ----------------------------------------------------------- */
  format "[end %]%ms\n" nowTime (sw.ElapsedMilliseconds as Integer)
  ok
)
