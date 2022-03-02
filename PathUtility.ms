/*! © 2021 imaoki | MIT License | https://github.com/imaoki */
/*-
ファイルまたはディレクトリのパス情報を操作する。
*/
struct PathUtilityStruct (
  /*-
  @prop <String> 作成パラメータ1。ベースディレクトリ。既定値は`undefined`。
  @remarks 未指定の場合は本ファイルの配置されたディレクトリがベースディレクトリとなる。
  */
  public _CP1_,

  /*- @prop <String> */
  private baseDirectory,

  /*- @prop <DotNetClass:System.IO.Directory> */
  private directoryClass = DotNetClass "System.IO.Directory",
  /*- @prop <DotNetClass:System.Environment> */
  private environmentClass = DotNetClass "System.Environment",
  /*- @prop <DotNetClass:System.IO.Path> */
  private pathClass = DotNetClass "System.IO.Path",

  /*-
  パスの拡張子を変更する。
  @param path <String>
  @param extension <String> 新しい拡張子（先行ピリオド付き、またはなし）。
  @returns <String>
  */
  public fn ChangeExtension path extension = (
    this.pathClass.ChangeExtension path extension
  ),

  /*-
  パスからディレクトリ部分を抽出する。
  @param path <String>
  @returns <String>
  */
  public fn ExtractDirectoryName path = (
    path = this.TrimEndSeparator path
    if this.HasExtension path do (
      path = this.GetDirectoryName path
    )
    path
  ),

  /*-
  ベースディレクトリを取得する。
  @returns <String>
  */
  public fn GetBaseDirectory = (
    this.baseDirectory
  ),

  /*-
  パスのディレクトリ情報を取得する。
  @param path <String>
  @returns <String|UndefinedClass> ルートディレクトリの場合は`undefined`を返す。
  @remarks 取得したディレクトリ情報がルートディレクトリの場合にのみパスの末尾に`"\"`が付く。

  | パス                 | 結果        |
  | -------------------- | ----------- |
  | `@"C:\Dir\File.ext"` | `"C:\Dir"`  |
  | `@"C:\Dir\"`         | `"C:\Dir"`  |
  | `@"C:\Dir"`          | `"C:\"`     |
  | `@"C:\"`             | `undefined` |
  */
  public fn GetDirectoryName path = (
    this.pathClass.GetDirectoryName path
  ),

  /*-
  パスの拡張子（ピリオドを含む）を取得する。
  @param path <String>
  @returns <String>
  @remarks パスが拡張子を持たない場合は`""`を返す。
  */
  public fn GetExtension path = (
    this.pathClass.GetExtension path
  ),

  /*-
  パスのファイル名と拡張子を取得する。
  @param path <String>
  @returns <String>
  @remarks パスの最後の文字がディレクトリ区切り記号、またはボリューム区切り記号の場合は`""`を返す。
  */
  public fn GetFileName path = (
    this.pathClass.GetFileName path
  ),

  /*-
  パスの拡張子を含まないファイル名を取得する。
  @param path <String>
  @returns <String>
  */
  public fn GetFileNameWithoutExtension path = (
    this.pathClass.GetFileNameWithoutExtension path
  ),

  /*-
  絶対パスを取得する。
  @param path <String> 絶対パスまたは相対パス。
  @returns <String>
  @remarks 相対パスを使用する場合はベースディレクトリの実体が存在する必要がある。
  */
  public fn GetFullPath path = (
    if this.directoryClass.Exists this.baseDirectory do (
      this.environmentClass.CurrentDirectory = this.baseDirectory
    )
    this.pathClass.GetFullPath path
  ),

  /*-
  ファイル名に使用できない文字の配列を取得する。
  @returns <Array[<String>]>
  */
  public fn GetInvalidFileNameChars = (
    this.pathClass.GetInvalidFileNameChars()
  ),

  /*-
  パス名に使用できない文字の配列を取得する。
  @returns <Array[<String>]>
  */
  public fn GetInvalidPathChars = (
    this.pathClass.GetInvalidPathChars()
  ),

  /*-
  パスのルートディレクトリ情報を取得する。
  @param path <String>
  @returns <String>
  @remarks パスにルートディレクトリ情報が含まれていない場合は`""`を返す。
  */
  public fn GetPathRoot path = (
    this.pathClass.GetPathRoot path
  ),

  /*-
  ランダムなファイル名を取得する。
  @returns <String>
  */
  public fn GetRandomFileName = (
    this.pathClass.GetRandomFileName()
  ),

  /*-
  パスに拡張子が含まれているかどうかを判定する。
  @returns <BooleanClass>
  */
  public fn HasExtension path = (
    this.pathClass.HasExtension path
  ),

  /*-
  パスにルートが含まれているかどうかを判定する。
  @returns <BooleanClass>
  */
  public fn IsPathRooted path = (
    this.pathClass.IsPathRooted path
  ),

  /*-
  @param path <String>
  @returns <OkClass>
  */
  public fn SetBaseDirectory path = (
    this.baseDirectory = path
    if this.HasExtension this.baseDirectory do (
      this.baseDirectory = this.GetDirectoryName this.baseDirectory
    )
    this.baseDirectory = this.TrimEndSeparator this.baseDirectory
    this.GetBaseDirectory()
  ),

  /*-
  末尾にある区切り文字を全て削除する。
  @param path <String>
  @returns <String>
  @remarks ルートディレクトリの場合は何もしない。
  */
  public fn TrimEndSeparator path = (
    if this.GetDirectoryName path != undefined \
        and matchPattern path pattern:@"*\" do (
      path = trimRight path @"\"
    )
    path
  ),

  /*- @returns <Name> */
  public fn StructName = #PathUtilityStruct,

  /*-
  @param indent: <String>
  @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
  @returns <OkClass>
  */
  public fn Dump indent:"" out:listener = (
    format "%PathUtilityStruct\n" indent to:out
    format "%  currentDir:@\"%\"\n" indent this.currentDir to:out
    format "%  currentFile:@\"%\"\n" indent this.currentFile to:out
    format "%  globalVarName:\"%\"\n" indent this.globalVarName to:out
    format "%  parentDir:@\"%\"\n" indent this.parentDir to:out
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
    if classOf this._CP1_ == String then (
      this.SetBaseDirectory this._CP1_
    )
    else (
      this.SetBaseDirectory (getSourceFileName())
    )
  )
)
