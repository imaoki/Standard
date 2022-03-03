/*! © 2021 imaoki | MIT License | https://github.com/imaoki */
/*-
.NETの[Enum](https://docs.microsoft.com/ja-jp/dotnet/api/system.enum?view=netframework-4.8)を`Name`値で操作するためのラッパー。
*/
struct EnumStruct (
  /*-
  @prop <String> 作成パラメータ1。
  使用する列挙体の完全修飾名。
  */
  public _CP1_,

  /*- @prop <DotNetClass:System.Enum> */
  private baseEnumClass = DotNetClass "System.Enum",
  /*- @prop <Struct:DotNetUtilityStruct> */
  private dotNetUtility,
  /*- @prop <DotNetClass:Any> */
  private enumClass,

  /*
  public fn Create flagNames = (),
  public fn GetFlags enumObject = (),
  public fn GetNames = (),
  public fn HasFlag enumObject flagName = (),
  public fn IsValidEnum = (),

  private fn isEnumClass obj = (),
  */

  /*-
  指定したフラグを組み合わせた列挙体インスタンスを生成する。
  @param flagNames <Array[<Name>]>
  @returns <DotNetObject:Any|UndefinedClass>
  @remarks `flagNames`が空配列、または未定義のフラグを指定した場合は`undefined`を返す。
  */
  public fn Create flagNames = (
    local enumObject = undefined
    if this.IsValidEnum() do (
      for flagName in flagNames do (
        if isProperty this.enumClass flagName do (
          local flagObject = getProperty this.enumClass flagName
          if enumObject == undefined then (
            enumObject = flagObject
          )
          else (
            enumObject = DotNet.CombineEnums enumObject flagObject
          )
        )
      )
    )
    enumObject
  ),

  /*-
  列挙体インスタンスから有効なフラグを取得する。
  @param enumObject <DotNetObject:Any>
  @returns <Array[<Name>]>
  @remarks `enumObject`は本インスタンスの列挙体オブジェクトと同じ型でなければならない。
  */
  public fn GetFlags enumObject = (
    local flagNames = this.GetNames()
    for flagName in flagNames collect (
      if this.HasFlag enumObject flagName then (
        flagName
      )
      else (
        dontCollect
      )
    )
  ),

  /*-
  列挙体に定義された全てのフラグの名前を取得する。
  @returns <Array[<Name>]>
  */
  public fn GetNames = (
    local flagNames = #()
    if this.IsValidEnum() do (
      local propNames = this.baseEnumClass.GetNames this.enumClass
      flagNames = for propName in propNames collect propName as Name
    )
    flagNames
  ),

  /*-
  指定したフラグが有効かどうかを判定する。
  @param enumObject <DotNetObject:Any>
  @param flagName <Name>
  @returns <BooleanClass>
  @remarks `enumObject`は本インスタンスの列挙体オブジェクトと同じ型でなければならない。
  */
  public fn HasFlag enumObject flagName = (
    local result = false
    if this.IsValidEnum() do (
      if isProperty this.enumClass flagName do (
        local flagObject = getProperty this.enumClass flagName
        result = DotNet.CompareEnums enumObject flagObject
      )
    )
    result
  ),

  /*-
  `Enum`オブジェクトとして有効かどうかを判定する。
  @returns <BooleanClass>
  */
  public fn IsValidEnum = (
    this.isEnumClass this.enumClass
  ),

  /*-
  `System.Enum`のサブクラスかどうかを判定する。
  @param obj <Any>
  @returns <BooleanClass>
  */
  private fn isEnumClass obj = (
    this.dotNetUtility.IsSubclassOf "System.Enum" obj
  ),

  /*- @returns <Name> */
  public fn StructName = #EnumStruct,

  /*-
  @param indent: <String>
  @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
  @returns <OkClass>
  */
  public fn Dump indent:"" out:listener = (
    format "%EnumStruct\n" indent to:out
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
    this.dotNetUtility = (fileIn @"DotNetUtility.ms")()
    if classOf this._CP1_ == String do (
      this.enumClass = DotNetClass this._CP1_
      if not this.isEnumClass this.enumClass do (
        this.enumClass = undefined
      )
    )
  )
)
