/*! © 2021 imaoki | MIT License | https://github.com/imaoki */
/*-
アトリビュート用の追加メソッドを提供する。
*/
struct AttributeUtilityStruct (
  /*
  public fn GetAttribute obj attributeName = (),
  public fn GetAttributeNames obj = (),
  public fn HasAttribute obj attributeName = (),
  public fn IsAttribute obj = (),
  */

  /*-
  オブジェクトから指定した名前のアトリビュートインスタンスを取得する。
  @param obj <Any>
  @param attributeName <Name>
  @returns <Attribute|UndefinedClass>
  @remarks アトリビュートが見つからない場合は`undefined`返す。
  */
  public fn GetAttribute obj attributeName = (
    local attribute = undefined
    if isValidObj obj do (
      local attributeCount = CustAttributes.Count obj baseObject:true
      for i = 1 to attributeCount while attribute == undefined do (
        if (CustAttributes.GetDef obj i baseObject:true).Name == attributeName do (
          attribute = CustAttributes.Get obj i baseObject:true
        )
      )
    )
    attribute
  ),

  /*-
  オブジェクトが持つ全てのアトリビュートの名前を取得する。
  @param obj <Any>
  @returns <Array[<Name>]>
  */
  public fn GetAttributeNames obj = (
    local attributeNames = #()
    if isValidObj obj do (
      local attributeDefs = CustAttributes.GetDefs obj baseObject:true
      if classOf attributeDefs == Array do (
        attributeNames = for def in attributeDefs collect def.Name
      )
    )
    attributeNames
  ),

  /*-
  オブジェクトが指定した名前のアトリビュートを持っているかどうかを判定する。
  @param obj <Any>
  @param attributeName <Name>
  @returns <BooleanClass>
  */
  public fn HasAttribute obj attributeName = (
    this.IsAttribute (this.GetAttribute obj attributeName)
  ),

  /*-
  指定されたオブジェクトがアトリビュートインスタンスかどうかを判定する。
  @param obj <Any>
  @returns <BooleanClass>
  */
  public fn IsAttribute obj = (
    superClassOf obj == AttributeDef
  ),

  /*- @returns <Name> */
  public fn StructName = #AttributeUtilityStruct,

  /*-
  @param indent: <String>
  @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
  @returns <OkClass>
  */
  public fn Dump indent:"" out:listener = (
    format "%AttributeUtilityStruct\n" indent to:out
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
