/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
/*- @var <Struct:StandardStruct> */
global std
/*-
標準ライブラリ。
*/
struct StandardStruct (
  /*- @prop <Struct:AttributeUtilityStruct> */
  public AttributeUtility,
  /*- @prop <Struct:ComparerStruct> */
  public Comparer,
  /*- @prop <Struct:DotNetUtilityStruct> */
  public DotNetUtility,
  /*- @prop <StructDef:EasingStruct> */
  public EasingStruct,
  /*- @prop <StructDef:EncodingStruct> */
  public EncodingStruct,
  /*- @prop <StructDef:EnumStruct> */
  public EnumStruct,
  /*- @prop <Struct:FileUtilityStruct> */
  public FileUtility,
  /*- @prop <StructDef:ObserverStruct> */
  public ObserverStruct,
  /*- @prop <StructDef:PathUtilityStruct> */
  public PathUtilityStruct,
  /*- @prop <Struct:StringUtilityStruct> */
  public StringUtility,
  /*- @prop <StructDef:TimerStruct> */
  public TimerStruct,
  /*- @prop <Struct:ViewportUtilityStruct> */
  public ViewportUtility,

  /*
  public fn Install = (),
  public fn Uninstall = (),
  */

  /*-
  インストールする。
  @returns <OkClass>
  @remarks 静的メソッド。
  */
  public fn Install = (
    ::StandardStruct()
    if isProperty ::startupLoader #RegisterFile do (
      ::startupLoader.RegisterFile (getSourceFileName()) installer:true
    )
    format "[install]::std\n"
    ok
  ),

  /*-
  アンインストールする。
  @returns <OkClass>
  @remarks 静的メソッド。
  */
  public fn Uninstall = (
    if isProperty ::startupLoader #UnregisterFile do (
      ::startupLoader.UnregisterFile (getSourceFileName())
    )
    ::std = undefined
    format "[uninstall]::std\n"
    ok
  ),

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
  )
)
