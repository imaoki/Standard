/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
/*-
.NET用の追加メソッドを提供する。
*/
struct DotNetUtilityStruct (
  /*
  public fn IsInstanceOf typeName obj = (),
  public fn IsSubclassOf typeName obj = (),
  public fn TypeOf obj = (),
  */

  /*-
  オブジェクトが指定した型のインスタンスかどうかを判定する。
  @param typeName <String> 型のアセンブリ修飾名。
  @param obj <DotNetObject:Any>
  @returns <BooleanClass>
  */
  public fn IsInstanceOf typeName obj = (
    classOf typeName == String \
        and classOf obj == DotNetObject \
        and (DotNet.GetType typeName).IsInstanceOfType obj
  ),

  /*-
  クラス、またはオブジェクトが指定した型から派生しているかどうかを判定する。
  @param typeName <String> 型のアセンブリ修飾名。
  @param obj <DotNetClass:Any|DotNetObject:Any>
  @returns <BooleanClass>
  */
  public fn IsSubclassOf typeName obj = (
    classOf typeName == String \
        and (classOf obj == DotNetClass or classOf obj == DotNetObject) \
        and (DotNet.GetType obj).IsSubclassOf (DotNet.GetType typeName)
  ),

  /*-
  型の完全修飾名を取得する。
  @param obj <DotNetClass:Any|DotNetObject:Any>
  @returns <String>
  @remarks `DotNetClass`および`DotNetObject`以外の場合は`classOf`の結果を文字列化する。
  */
  public fn TypeOf obj = (
    if classOf obj == DotNetClass or classOf obj == DotNetObject then (
      (DotNet.GetType obj).FullName
    )
    else (
      (classOf obj) as String
    )
  ),

  /*- @returns <Name> */
  public fn StructName = #DotNetUtilityStruct,

  /*-
  @param indent: <String>
  @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
  @returns <OkClass>
  */
  public fn Dump indent:"" out:listener = (
    format "%DotNetUtilityStruct\n" indent to:out
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

  on Create do ()
)
