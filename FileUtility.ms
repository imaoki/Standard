/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
/*-
一般的なファイルおよびディレクトリの操作に加えてスクリプトファイルやシーンファイルの操作を行うメソッドも提供する。
@remarks エンコーディングは指定がない限りUTF-8（BOM無し）を使用する。
*/
struct FileUtilityStruct (
  /*- @prop <Struct:ComparerStruct> */
  private comparer,
  /*- @prop <DotNetClass:System.IO.Directory> */
  private directoryClass = DotNetClass "System.IO.Directory",
  /*- @prop <DotNetClass:System.IO.DirectoryInfo> */
  private directoryInfoClass = DotNetClass "System.IO.DirectoryInfo",
  /*- @prop <Struct:DotNetUtilityStruct> */
  private dotNetUtility,
  /*- @prop <StructDef:EncodingStruct> */
  private encodingDef,
  /*- @prop <StructDef:EnumStruct> */
  private enumDef,
  /*- @prop <Struct:EnumStruct> `"System.IO.FileAttributes"`列挙型。 */
  private fileAttributesEnum,
  /*- @prop <DotNetClass:System.IO.File> */
  private fileClass = DotNetClass "System.IO.File",
  /*- @prop <Struct:PathUtilityStruct> */
  private pathUtility,
  /*- @prop <StructDef:PathUtilityStruct> */
  private pathUtilityDef,
  /*- @prop <Struct:EnumStruct> `"System.IO.SearchOption"`列挙型。 */
  private searchOptionEnum,

  /*
  public fn CopyDirectory source destination overwrite:false = (),
  public fn CopyFile source destination overwrite:false = (),
  public fn CreateDirectory path = (),
  public fn CreateTextFile path access:#Write encoding:"utf-8" bom:false = (),
  public fn DeleteDirectory path recursive:true = (),
  public fn DeleteFile path = (),
  public fn DirectoryExists path = (),
  public fn EvaluateFile path = (),
  public fn FileExists path = (),
  public fn GetCreationTime path asUtc:false = (),
  public fn GetDirectories path pattern recursive:false = (),
  public fn GetFiles path pattern recursive:false = (),
  public fn GetLastAccessTime path asUtc:false = (),
  public fn GetLastWriteTime path asUtc:false = (),
  public fn GetMaxVersion path = (),
  public fn IsHidden path = (),
  public fn IsMaxFile path = (),
  public fn IsReadOnly path = (),
  public fn IsScriptFile path = (),
  public fn MoveDirectory source destination = (),
  public fn OpenTextFile path access:#Read encoding:"utf-8" bom:false = (),
  public fn ReadAllLines path encoding:"utf-8" bom:false = (),
  public fn ReadAllText path encoding:"utf-8" bom:false = (),
  public fn RenameDirectory path newName = (),
  public fn RenameFile path newName = (),
  public fn WriteAllLines path contents eol:"\n" encoding:"utf-8" bom:false = (),
  public fn WriteAllText path contents encoding:"utf-8" bom:false = (),

  private fn copyDirectoryRecursive source destination overwrite = (),
  private fn createDirectoryInfo path = (),
  private fn createEncoding encoding bom = (),
  private fn createSearchOption recursive = (),
  private fn getAttributes path = (),
  private fn getPathType path = (),
  private fn isFileAttributesObject obj = (),
  */

  /*-
  ディレクトリをコピーする。
  @param source <String> コピーするディレクトリのパス。
  @param destination <String> コピー先のパス。
  @param overwrite: <BooleanClass> 上書きする場合は`true`、それ以外の場合は`false`。既定値は`false`。
  @returns <OkClass>
  */
  public fn CopyDirectory source destination overwrite:false = (
    if this.DirectoryExists source and classOf destination == String do (
      destination = this.pathUtility.TrimEndSeparator destination
      this.copyDirectoryRecursive source destination overwrite
    )
    ok
  ),

  /*-
  ファイルをコピーする。
  @param source <String> コピーするファイルのパス。
  @param destination <String> コピー先のパス。
  @param overwrite: <BooleanClass> 上書きする場合は`true`、それ以外の場合は`false`。既定値は`false`。
  @returns <OkClass>
  */
  public fn CopyFile source destination overwrite:false = (
    if this.FileExists source and classOf destination == String do (
      if overwrite or not this.FileExists destination do (
        this.fileClass.Copy source destination overwrite
      )
    )
    ok
  ),

  /*-
  指定されたパスに全てのディレクトリとサブディレクトリを作成する。
  @param path <String>
  @returns <DotNetObject:System.IO.DirectoryInfo>
  */
  public fn CreateDirectory path = (
    this.directoryClass.CreateDirectory path
  ),

  /*-
  テキストファイルを作成、または上書きする。
  @param path <String>
  @param access: <Name> 実行可能な操作。既定値は`#Write`。
  @param encoding: <String> エンコーディングの名前。既定値は`"utf-8"`。
  @param bom: <BooleanClass> BOMの有無。既定値は`false`。
  @returns <FileStream|UndefinedClass> MAXScriptの`FileStream`値。
  @remarks 指定可能な値は`OpenTextFile`を参照。
  */
  public fn CreateTextFile path access:#Write encoding:"utf-8" bom:false = (
    local fs = this.fileClass.Create path
    if this.dotNetUtility.IsInstanceOf "System.IO.FileStream" fs do (
      fs.Close()
    )
    this.OpenTextFile path access:access encoding:encoding bom:bom
  ),

  /*-
  ディレクトリを削除する。
  @param path <String>
  @param recursive: <BooleanClass> サブディレクトリ、およびファイルを削除する場合は`true`、それ以外の場合は`false`。既定値は`true`。
  @returns <OkClass>
  @remarks
  `recursive`が`false`の時、指定されたディレクトリが空でない場合は削除しない。
  ゴミ箱には移動しないので使用の際は注意すること。
  */
  public fn DeleteDirectory path recursive:true = (
    if this.DirectoryExists path do (
      local subDirs = this.directoryClass.GetDirectories path
      local subFiles = this.directoryClass.GetFiles path
      if recursive or (subDirs.Count == 0 and subFiles.Count == 0) do (
        this.directoryClass.Delete path recursive
      )
    )
  ),

  /*-
  ファイルを削除する。
  @param path <String>
  @returns <OkClass>
  @remarks ゴミ箱には移動しないので使用の際は注意すること。
  */
  public fn DeleteFile path = (
    if this.FileExists path do (
      this.fileClass.Delete path
    )
    ok
  ),

  /*-
  ディレクトリが存在するかどうかを判定する。
  @param path <String>
  @returns <BooleanClass>
  */
  public fn DirectoryExists path = (
    this.directoryClass.Exists path
  ),

  /*-
  MAXScriptファイルを評価する。
  @param path <String>
  @returns <Any|UndefinedClass> msファイルでない場合は`undefined`を返す。
  @remarks msファイルのみが対象。
  */
  public fn EvaluateFile path = (
    if this.IsScriptFile path then (
      fileIn path
    )
    else (
      undefined
    )
  ),

  /*-
  ファイルが存在するかどうかを判定する。
  @param path <String>
  @returns <BooleanClass>
  */
  public fn FileExists path = (
    this.fileClass.Exists path
  ),

  /*-
  ディレクトリまたはファイルの作成日時を取得する。
  @param path <String>
  @param asUtc: <BooleanClass> 世界協定時刻（UTC）で取得する場合は`true`、現在時刻で取得する場合は`false`。既定値は`false`。
  @returns <DotNetObject:System.DateTime>
  */
  public fn GetCreationTime path asUtc:false = (
    local dateTimeObject = undefined
    case this.getPathType path of (
      (#Directory): (
        if asUtc then (
          dateTimeObject = this.directoryClass.GetCreationTimeUtc path
        )
        else (
          dateTimeObject = this.directoryClass.GetCreationTime path
        )
      )
      (#File): (
        if asUtc then (
          dateTimeObject = this.fileClass.GetCreationTimeUtc path
        )
        else (
          dateTimeObject = this.fileClass.GetCreationTime path
        )
      )
      default: ()
    )
    dateTimeObject
  ),

  /*-
  パターンに一致したサブディレクトリを取得する。
  @param path <String>
  @param pattern <String> リテラル文字とワイルドカード文字の組み合わせ。大文字と小文字を区別しない。
  @param recursive: <BooleanClass> 全てのサブディレクトリから検索する場合は`true`、現在のディレクトリからのみ検索する場合は`false`。既定値は`false`。
  @returns <Array[<Struct:Path>]>
  @remarks
  パスは自然順にソートされる。
  パターン照合は`"*"`で全てのサブディレクトリを取得した後、`matchPattern`関数によって照合される。
  よってパスの中間部分で選別する場合はパターン文字列の前後にワイルドカードが必要となる点に注意する。

  | 基点            | 取得したいパス            | 検索パターン |
  | --------------- | ------------------------- | ------------ |
  | `@"C:\Foo\Bar"` | `@"C:\Foo\Bar\Hoge\Piyo"` | `"*\Hoge*"`  |
  */
  public fn GetDirectories path pattern recursive:false = (
    local option = this.createSearchOption recursive
    local dirs = this.directoryClass.GetDirectories path "*" option
    qsort dirs this.comparer.CompareStringLogical
    for dir in dirs collect (
      if matchPattern dir pattern:pattern ignoreCase:true then (
        dir
      )
      else (
        dontCollect
      )
    )
  ),

  /*-
  パターンに一致したファイルを取得する。
  @param path <String>
  @param pattern <String> リテラル文字とワイルドカード文字の組み合わせ。大文字と小文字を区別しない。
  @param recursive: <BooleanClass> 全てのサブディレクトリから検索する場合は`true`、現在のディレクトリからのみ検索する場合は`false`。既定値は`false`。
  @returns <Array[<Struct:Path>]>
  @remarks
  パスは自然順にソートされる。
  パターン照合は`"*"`で全てのサブディレクトリを取得した後、`matchPattern`関数によって照合される。
  よってパスの中間部分で選別する場合はパターン文字列の前後にワイルドカードが必要となる点に注意する。

  | 基点            | 取得したいパス                | 検索パターン    |
  | --------------- | ----------------------------- | --------------- |
  | `@"C:\Foo\Bar"` | `@"C:\Foo\Bar\Hoge\Piyo.txt"` | `"*\Hoge*.txt"` |
  */
  public fn GetFiles path pattern recursive:false = (
    local option = this.createSearchOption recursive
    local files = this.directoryClass.GetFiles path "*" option
    qsort files this.comparer.CompareStringLogical
    for file in files collect (
      if matchPattern file pattern:pattern ignoreCase:true then (
        file
      )
      else (
        dontCollect
      )
    )
  ),

  /*-
  ディレクトリまたはファイルの最終アクセス日時を取得する。
  @param path <String>
  @param asUtc: <BooleanClass> 世界協定時刻（UTC）で取得する場合は`true`、現在時刻で取得する場合は`false`。既定値は`false`。
  @returns <DotNetObject:System.DateTime>
  */
  public fn GetLastAccessTime path asUtc:false = (
    local dateTimeObject = undefined
    case this.getPathType path of (
      (#Directory): (
        if asUtc then (
          dateTimeObject = this.directoryClass.GetLastAccessTimeUtc path
        )
        else (
          dateTimeObject = this.directoryClass.GetLastAccessTime path
        )
      )
      (#File): (
        if asUtc then (
          dateTimeObject = this.fileClass.GetLastAccessTimeUtc path
        )
        else (
          dateTimeObject = this.fileClass.GetLastAccessTime path
        )
      )
      default: ()
    )
    dateTimeObject
  ),

  /*-
  ディレクトリまたはファイルの最終書き込み日時を取得する。
  @param path <String>
  @param asUtc: <BooleanClass> 世界協定時刻（UTC）で取得する場合は`true`、現在時刻で取得する場合は`false`。既定値は`false`。
  @returns <DotNetObject:System.DateTime>
  */
  public fn GetLastWriteTime path asUtc:false = (
    local dateTimeObject = undefined
    case this.getPathType path of (
      (#Directory): (
        if asUtc then (
          dateTimeObject = this.directoryClass.GetLastWriteTimeUtc path
        )
        else (
          dateTimeObject = this.directoryClass.GetLastWriteTime path
        )
      )
      (#File): (
        if asUtc then (
          dateTimeObject = this.fileClass.GetLastWriteTimeUtc path
        )
        else (
          dateTimeObject = this.fileClass.GetLastWriteTime path
        )
      )
      default: ()
    )
    dateTimeObject
  ),

  /*-
  Maxシーンファイルのバージョンを西暦形式の整数で取得する。
  @param path <String>
  @returns <Integer>
  @remarks
  ファイルが存在しない等でバージョンが取得できない場合は`0`を返す。
  3ds Max 9以前のバージョンについても一律西暦形式で扱う。
  */
  public fn GetMaxVersion path = (
    local version = 0
    if this.IsMaxFile path do (
      version = (getMaxFileVersionData path)[1] / 1000 + 1998
    )
    version
  ),

  /*-
  ディレクトリまたはファイルが隠し属性かどうかを判定する。
  @param path <String>
  @returns <BooleanClass>
  */
  public fn IsHidden path = (
    local attributesObject = this.getAttributes path
    this.isFileAttributesObject attributesObject \
        and this.fileAttributesEnum.HasFlag attributesObject #Hidden
  ),

  /*-
  ファイルがMaxシーンファイルかどうかを判定する。
  @param path <String>
  @returns <BooleanClass>
  */
  public fn IsMaxFile path = (
    this.FileExists path and ::isMaxFile path
  ),

  /*-
  ディレクトリまたはファイルが読み取り専用かどうかを判定する。
  @param path <String>
  @returns <BooleanClass>
  @remarks
  Windowsのディレクトリを読み取り専用に設定するためにはPowerShell等を利用する必要がある。

  ```powershell
  Set-ItemProperty -Path .\foo -Name Attributes -Value "ReadOnly"
  ```

  ```dos
  attrib foo +R
  ```
  */
  public fn IsReadOnly path = (
    local attributesObject = this.getAttributes path
    this.isFileAttributesObject attributesObject \
        and this.fileAttributesEnum.HasFlag attributesObject #ReadOnly
  ),

  /*-
  ファイルがスクリプトファイルかどうかを判定する。
  @param path <String>
  @returns <BooleanClass>
  @remarks msファイルのみが対象。
  */
  public fn IsScriptFile path = (
    local extension = this.pathUtility.GetExtension path
    this.FileExists path and stricmp extension ".ms" == 0
  ),

  /*-
  ディレクトリまたはファイルのディレクトリ部分を変更する。
  @param source <String> ディレクトリまたはファイルのパス。
  @param destination <String> 移動先のディレクトリまたはファイルのパス。ファイルパスを指定した場合はディレクトリ部分が使用される。
  @returns <OkClass>
  */
  public fn MoveDirectory source destination = (
    destination = this.pathUtility.TrimEndSeparator destination
    if this.DirectoryExists destination do (
      destination += @"\" + (this.pathUtility.GetFileName source)
      case this.getPathType source of (
        (#Directory): this.directoryClass.Move source destination
        (#File): this.fileClass.Move source destination
        default: ()
      )
    )
    ok
  ),

  /*-
  テキストファイルを開く。
  @param path <String>
  @param access: <Name> 実行可能な操作を以下の値で指定する。既定値は`#Read`。

  | 値           | 操作              | `openFile`関数の`mode`パラメータの対応 |
  | ------------ | ----------------- | -------------------------------------- |
  | `#Read`      | 読み取り          | `"rt"`                                 |
  | `#ReadWrite` | 読み取り/書き込み | `"r+"`                                 |
  | `#Write`     | 書き込み          | `"wt"`                                 |

  これ以外の値を指定した場合は`#Read`が使用される。
  @param encoding: <String> エンコーディングの名前。既定値は`"utf-8"`。
  @param bom: <BooleanClass> BOMの有無。既定値は`false`。
  @returns <FileStream|UndefinedClass> MAXScriptの`FileStream`値。
  */
  public fn OpenTextFile path access:#Read encoding:"utf-8" bom:false = (
    local fs = undefined
    if this.FileExists path do (
      local modeValue = case access of (
        (#ReadWrite): "r+"
        (#Write): "wt"
        default: "rt"
      )

      local encodingObject = this.createEncoding encoding bom
      local codePage = encodingObject.GetCodePage()
      fs = openFile path mode:modeValue encoding:codePage writeBOM:bom
    )
    fs
  ),

  /*-
  ファイルの全ての行を読み取る。
  @param path <String>
  @param encoding: <String> エンコーディングの名前。既定値は`"utf-8"`。
  @param bom: <BooleanClass> BOMの有無。既定値は`false`。
  @returns <Array[<String>]|UndefinedClass> ファイルが存在しない場合は`undefined`を返す。
  */
  public fn ReadAllLines path encoding:"utf-8" bom:false = (
    local contents = undefined
    if this.FileExists path do (
      local encodingObject = this.createEncoding encoding bom
      contents = this.fileClass.ReadAllLines path (encodingObject.GetEncodingObject())
    )
    contents
  ),

  /*-
  ファイルの全てのテキストを読み取る。
  @param path <String>
  @param encoding: <String> エンコーディングの名前。既定値は`"utf-8"`。
  @param bom: <BooleanClass> BOMの有無。既定値は`false`。
  @returns <String|UndefinedClass> ファイルが存在しない場合は`undefined`を返す。
  */
  public fn ReadAllText path encoding:"utf-8" bom:false = (
    local contents = undefined
    if this.FileExists path do (
      local encodingObject = this.createEncoding encoding bom
      contents = this.fileClass.ReadAllText path (encodingObject.GetEncodingObject())
    )
    contents
  ),

  /*-
  ディレクトリ名を変更する。
  @param path <String>
  @param newName <String> 新しいディレクトリ名。
  @returns <OkClass>
  */
  public fn RenameDirectory path newName = (
    if this.DirectoryExists path and classOf newName == String do (
      local dir = this.pathUtility.GetDirectoryName path
      if classOf dir == String and this.DirectoryExists dir do (
        newName = this.pathUtility.GetFileNameWithoutExtension newName
        local destination = dir + @"\" + newName
        if not this.DirectoryExists destination do (
          this.directoryClass.Move path destination
        )
      )
    )
    ok
  ),

  /*-
  ファイル名を変更する。
  @param path <String>
  @param newName <String> 新しいファイル名。
  @returns <OkClass>
  @remarks 拡張子が含まれている場合は全て変更し、含まれていない場合は拡張子を引き継ぐ。
  */
  public fn RenameFile path newName = (
    if this.FileExists path and classOf newName == String do (
      local dir = this.pathUtility.GetDirectoryName path
      if classOf dir == String and this.DirectoryExists dir do (
        local destination = dir + @"\" + newName
        if not this.pathUtility.HasExtension destination do (
          destination += this.pathUtility.GetExtension path
        )
        if not this.FileExists destination do (
          this.fileClass.Move path destination
        )
      )
    )
    ok
  ),

  /*-
  ファイルを作成して行を書き込む。
  @param path <String>
  @param contents <Array[<Any>]>
  @param eol: <String> 改行コード。既定値は`"\n"`。
  @param encoding: <String> エンコーディングの名前。既定値は`"utf-8"`。
  @param bom: <BooleanClass> BOMの有無。既定値は`false`。
  @returns <OkClass>
  @remarks
  既存のファイルは上書きされる。
  ディレクトリが存在しない場合は作成に失敗する。
  */
  public fn WriteAllLines path contents eol:"\n" encoding:"utf-8" bom:false = (
    local ss = StringStream ""
    if classOf contents == Array do (
      with printAllElements true (
        for content in contents do (
          format "%%" content eol to:ss
        )
      )
    )
    this.WriteAllText path ss encoding:encoding bom:bom
    ok
  ),

  /*-
  ファイルを作成して文字列を書き込む。
  @param path <String>
  @param contents <String|StringStream>
  @param encoding: <String> エンコーディングの名前。既定値は`"utf-8"`。
  @param bom: <BooleanClass> BOMの有無。既定値は`false`。
  @returns <OkClass>
  @remarks
  既存のファイルは上書きされる。
  ディレクトリが存在しない場合は作成に失敗する。
  */
  public fn WriteAllText path contents encoding:"utf-8" bom:false = (
    if this.DirectoryExists (this.pathUtility.GetDirectoryName path) do (
      contents = contents as String
      local encodingObject = this.createEncoding encoding bom
      this.fileClass.WriteAllText path contents (encodingObject.GetEncodingObject())
    )
    ok
  ),

  /*-
  ディレクトリを再帰的にコピーする。
  @param source <String> コピーするディレクトリのパス。
  @param destination <String> コピー先パス。
  @param overwrite <BooleanClass>
  @returns <OkClass>
  */
  private fn copyDirectoryRecursive source destination overwrite = (
    if not this.DirectoryExists destination do (
      local sourceInfo = this.createDirectoryInfo source
      local destinationInfo = this.CreateDirectory destination
      destinationInfo.Attributes = sourceInfo.Attributes
    )

    if this.DirectoryExists destination do (
      local files = this.directoryClass.GetFiles source
      for subSource in files do (
        local subDestination = copy destination
        subDestination += @"\" + (this.pathUtility.GetFileName subSource)
        this.CopyFile subSource subDestination overwrite:overwrite
      )

      local dirs = this.directoryClass.GetDirectories source
      for subSource in dirs do (
        local subDestination = copy destination
        subDestination += @"\" + (this.pathUtility.GetFileName subSource)
        this.copyDirectoryRecursive subSource subDestination overwrite
      )
    )
    ok
  ),

  /*-
  `"System.IO.DirectoryInfo"`オブジェクトを生成する。
  @param path <String>
  @returns <DotNetObject:System.IO.DirectoryInfo>
  */
  private fn createDirectoryInfo path = (
    DotNetObject this.directoryInfoClass path
  ),

  /*-
  エンコーディングオブジェクトを生成する。
  @param encoding <String>
  @param bom <BooleanClass>
  @returns <Struct:Encoding>
  */
  private fn createEncoding encoding bom = (
    local encodingObject = this.encodingDef encoding bom
    if not encodingObject.IsValidEncoding() do (
      encodingObject = this.encodingDef()
    )
    encodingObject
  ),

  /*-
  `"System.IO.SearchOption"`オブジェクトを生成する。
  @param recursive <BooleanClass>
  @returns <DotNetObject:System.IO.SearchOption>
  */
  private fn createSearchOption recursive = (
    if recursive then (
      this.searchOptionEnum.Create #(#AllDirectories)
    )
    else (
      this.searchOptionEnum.Create #(#TopDirectoryOnly)
    )
  ),

  /*-
  ディレクトリまたはファイルの`FileAttributes`オブジェクトを取得する。
  @param path <String>
  @returns <DotNetObject:System.IO.FileAttributes>
  */
  private fn getAttributes path = (
    local attributesObject = undefined
    case this.getPathType path of (
      (#Directory): (
        attributesObject = (this.createDirectoryInfo path).Attributes
      )
      (#File): (
        attributesObject = this.fileClass.GetAttributes path
      )
      default: ()
    )
    attributesObject
  ),

  /*-
  パスの種類を判定する。
  @param path <String>
  @returns <Name>
  | 種類         | 値           |
  | ------------ | ------------ |
  | ディレクトリ | `#Directory` |
  | ファイル     | `#File`      |
  | 不明         | `#Unknown`   |
  */
  private fn getPathType path = (
    if this.FileExists path then (
      #File
    )
    else (
      if this.DirectoryExists path then (
        #Directory
      )
      else (
        #Unknown
      )
    )
  ),

  /*-
  @param obj <Any>
  @returns <BooleanClass>
  */
  private fn isFileAttributesObject obj = (
    this.dotNetUtility.IsInstanceOf "System.IO.FileAttributes" obj
  ),

  /*- @returns <Name> */
  public fn StructName = #FileUtilityStruct,

  /*-
  @param indent: <String>
  @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
  @returns <OkClass>
  */
  public fn Dump indent:"" out:listener = (
    format "%FileUtilityStruct\n" indent to:out
    ok
  ),

  /*-
  @param obj <Any>
  @returns <BooleanClass>
  @remarks 大文字と小文字を区別する。
  */
  public fn Equals obj = (
    local isEqualStructName = isStruct obj \
        and isProperty obj #StructName \
        and classOf obj.StructName == MAXScriptFunction \
        and obj.StructName() == this.StructName()

    local isEqualProperties = true

    isEqualStructName and isEqualProperties
  ),

  on Create do (
    this.comparer = (::standardDefinitionPool[@"Comparer.ms"])()
    this.dotNetUtility = (::standardDefinitionPool[@"DotNetUtility.ms"])()
    this.encodingDef = ::standardDefinitionPool[@"Encoding.ms"]
    this.enumDef = ::standardDefinitionPool[@"Enum.ms"]
    this.pathUtilityDef = ::standardDefinitionPool[@"PathUtility.ms"]

    this.pathUtility = this.pathUtilityDef (getSourceFileName())
    this.fileAttributesEnum = this.enumDef "System.IO.FileAttributes"
    this.searchOptionEnum = this.enumDef "System.IO.SearchOption"
  )
)
