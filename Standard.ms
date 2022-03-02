/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
/*- @var <Struct:StandardStruct> */
global std
/*-
標準ライブラリ。
*/
struct StandardStruct (
  /*- @prop <Struct:AttributeUtilityStruct> */
  AttributeUtility,
  /*- @prop <Struct:ComparerStruct> */
  Comparer,
  /*- @prop <Struct:DotNetUtilityStruct> */
  DotNetUtility,
  /*- @prop <StructDef:EasingStruct> */
  EasingStruct,
  /*- @prop <StructDef:EncodingStruct> */
  EncodingStruct,
  /*- @prop <StructDef:EnumStruct> */
  EnumStruct,
  /*- @prop <Struct:FileUtilityStruct> */
  FileUtility,
  /*- @prop <StructDef:ObserverStruct> */
  ObserverStruct,
  /*- @prop <StructDef:PathUtilityStruct> */
  PathUtilityStruct,
  /*- @prop <Struct:StringUtilityStruct> */
  StringUtility,
  /*- @prop <StructDef:TimerStruct> */
  TimerStruct,
  /*- @prop <Struct:ViewportUtilityStruct> */
  ViewportUtility,

  /*- @returns <Name> */
  public fn StructName = #StandardStruct,

  /*-
  @param indent: <String>
  @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
  @returns <OkClass>
  */
  public fn Dump indent:"" out:listener = (
    format "%StandardStruct\n" indent to:out
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
    ::std = this
    /* 依存無し */
    this.AttributeUtility = (fileIn @"AttributeUtility.ms")()
    this.Comparer = (fileIn @"Comparer.ms")()
    this.DotNetUtility = (fileIn @"DotNetUtility.ms")()
    this.EasingStruct = fileIn @"Easing.ms"
    this.ObserverStruct = fileIn @"Observer.ms"
    this.PathUtilityStruct = fileIn @"PathUtility.ms"
    this.ViewportUtility = (fileIn @"ViewportUtility.ms")()
    /*
    DotNetUtility
    */
    this.EnumStruct = fileIn @"Enum.ms"
    this.TimerStruct = fileIn @"Timer.ms"
    /*
    DotNetUtility
    Enum
    */
    this.StringUtility = (fileIn @"StringUtility.ms")()
    /*
    DotNetUtility
    StringUtility
    */
    this.EncodingStruct = fileIn @"Encoding.ms"
    /*
    Comparer
    DotNetUtility
    Encoding
    Enum
    PathUtility
    */
    this.FileUtility = (fileIn @"FileUtility.ms")()
    format "[define]::std\n"
  )
)
::StandardStruct()
::StandardStruct
