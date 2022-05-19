/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
/*-
.NETの[Encoding](https://docs.microsoft.com/ja-jp/dotnet/api/system.text.encoding?view=netframework-4.8)のラッパー。
@remarks 作成パラメータ
:   ```maxscript
    EncodingStruct [codePageIdentifier] [byteOrderMark]
    ```
*/
struct EncodingStruct (
  /*-
  @prop <String> 作成パラメータ1。
  エンコーディングの名前。既定値は`"utf-8"`。
  @remarks
  使用可能な値は[Encoding](https://docs.microsoft.com/ja-jp/dotnet/api/system.text.encoding?view=netframework-4.8#remarks)のエンコーディングの一覧に記載されている。
  未指定の場合はUTF-8（BOM無し）を使用する。
  */
  public _CP1_ = "utf-8",
  /*-
  @prop <BooleanClass> 作成パラメータ2。
  BOMの有無。既定値は`false`。
  */
  public _CP2_ = false,

  /*- @prop <Array[<Name>]> 全てのエンコーディングのIANA名の配列。 */
  private allNames = #(),
  /*- @prop <DotNetClass:System.BitConverter> */
  private bitConverterClass = DotNetClass "System.BitConverter",
  /*- @prop <DotNetClass:System.Convert> */
  private convertClass = DotNetClass "System.Convert",
  /*- @prop <Struct:DotNetUtilityStruct> */
  private dotNetUtility,
  /*- @prop <DotNetClass:System.Text.Encoding> */
  private encodingClass = DotNetClass "System.Text.Encoding",
  /*- @prop <DotNetObject:System.Text.Encoding> */
  private encodingObject = DotNetObject "System.Text.UTF8Encoding" false,
  /*- @prop <DotNetObject:System.Text.RegularExpressions.Regex> `^([a-fA-F0-9]{2})?(\-[a-fA-F0-9]{2})*$`に一致する正規表現オブジェクト。 */
  private hexStringRegex,
  /*- @prop <Struct:StringUtilityStruct> */
  private stringUtility,

  /*
  public fn DecodeHexString input = (),
  public fn EncodeToHexString input = (),
  public fn GetBytes input = (),
  public fn GetCodePage = (),
  public fn GetDisplayName = (),
  public fn GetEncodingObject = (),
  public fn GetName = (),
  public fn GetString bytes = (),
  public fn IsValidEncoding = (),
  public fn SetEncoding name bom:false = (),

  private fn isEncodingSubclass obj = (),
  private fn isValidName input = (),
  */

  /*-
  ハイフンで区切られた16進数文字列を元の文字列にデコードする。
  @param input <String>
  @returns <String>
  */
  public fn DecodeHexString input = (
    local result = ""
    if this.IsValidEncoding() and this.hexStringRegex.IsMatch input do (
      local hexArray = filterString input "-"
      local bytes = for hex in hexArray collect this.convertClass.ToByte hex 16
      result = this.GetString bytes
    )
    result
  ),

  /*-
  文字列をハイフンで区切られた16進数文字列にエンコードする。
  @param input <String>
  @returns <String>
  */
  public fn EncodeToHexString input = (
    local result = ""
    if this.IsValidEncoding() do (
      result = this.bitConverterClass.ToString (this.GetBytes input)
    )
    result
  ),

  /*-
  文字列をバイト配列にエンコードする。
  @param input <String>
  @returns <Array[<Integer>]>
  */
  public fn GetBytes input = (
    local bytes = #()
    if this.IsValidEncoding() do (
      bytes = this.encodingObject.GetBytes input
    )
    bytes
  ),

  /*-
  現在のエンコーディングオブジェクトのコードページIDを取得する。
  @returns <Integer>
  @remarks 無効なエンコーディングオブジェクトの場合は`-1`を返す。
  */
  public fn GetCodePage = (
    local codePage = -1
    if this.IsValidEncoding() do (
      codePage = this.encodingObject.CodePage
    )
    codePage
  ),

  /*-
  現在のエンコーディングについての記述をユーザーが判読できる形式で取得する。
  @returns <String>
  @remarks 無効なエンコーディングオブジェクトの場合は`""`を返す。
  */
  public fn GetDisplayName = (
    local displayName = ""
    if this.IsValidEncoding() do (
      displayName = this.encodingObject.EncodingName
    )
    displayName
  ),

  /*-
  現在のエンコーディングオブジェクトを取得する。
  @returns <DotNetObject:System.Text.Encoding>
  */
  public fn GetEncodingObject = (
    this.encodingObject
  ),

  /*-
  IANA(Internet Assigned Numbers Authority)名を取得する。
  @returns <String>
  @remarks 無効なエンコーディングオブジェクトの場合は`""`を返す。
  */
  public fn GetName = (
    local name = ""
    if this.IsValidEncoding() do (
      name = this.encodingObject.WebName
    )
    name
  ),

  /*-
  バイト配列を文字列にデコードする。
  @param bytes <Array[<Integer>]>
  @returns <String>
  */
  public fn GetString bytes = (
    local str = ""
    if this.IsValidEncoding() do (
      str = this.encodingObject.GetString bytes
    )
    str
  ),

  /*-
  エンコーディングオブジェクトとして有効かどうかを判定する。
  @returns <BooleanClass>
  */
  public fn IsValidEncoding = (
    this.isEncodingSubclass this.encodingObject
  ),

  /*-
  現在のエンコーディングオブジェクトを設定する。
  @param name <String>
  @param bom: <BooleanClass> バイト順マークを付加するかどうか。既定値は`false`。
  @returns <DotNetObject:System.Text.Encoding>
  @remarks 無効な名前を指定した場合はエンコーディングオブジェクトが`undefined`になる。
  */
  public fn SetEncoding name bom:false = (
    this.encodingObject = undefined
    if this.isValidName name do (
      if stricmp name "utf-8" == 0 then (
        this.encodingObject = DotNetObject "System.Text.UTF8Encoding" bom
      )
      else (
        this.encodingObject = this.encodingClass.GetEncoding name
      )
    )
    this.GetEncodingObject()
  ),

  /*-
  `"System.Text.Encoding"`のサブクラスかどうかを判定する。
  @param obj <Any>
  @returns <BooleanClass>
  */
  private fn isEncodingSubclass obj = (
    this.dotNetUtility.IsSubclassOf "System.Text.Encoding" obj
  ),

  /*-
  有効な名前かどうかを判定する。
  @param input <String>
  @returns <BooleanClass>
  */
  private fn isValidName input = (
    findItem this.allNames (input as Name) > 0
  ),

  /*- @returns <Name> */
  public fn StructName = #EncodingStruct,

  /*-
  @param indent: <String>
  @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
  @returns <OkClass>
  */
  public fn Dump indent:"" out:listener = (
    format "%EncodingStruct\n" indent to:out

    local typeName = this.dotNetUtility.TypeOf this.encodingObject
    format "%  encodingObject:\"%\"\n" indent typeName to:out

    if this.IsValidEncoding() do (
      format "%       CodePage:%\n" indent (this.GetCodePage()) to:out
      format "%           Name:\"%\"\n" indent (this.GetName()) to:out
      format "%    DisplayName:\"%\"\n" indent (this.GetDisplayName()) to:out
    )
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
    this.dotNetUtility = (::standardDefinitionPool[@"DotNetUtility.ms"])()
    this.stringUtility = (::standardDefinitionPool[@"StringUtility.ms"])()

    this.hexStringRegex = this.stringUtility.CreateRegex "^([a-fA-F0-9]{2})?(\-[a-fA-F0-9]{2})*$"

    local encodingInfos = this.encodingClass.GetEncodings()
    this.allNames = for info in encodingInfos collect info.Name as Name

    if classOf this._CP1_ == String and classOf this._CP2_ == BooleanClass do (
      this.SetEncoding this._CP1_ bom:this._CP2_
    )
  )
)
