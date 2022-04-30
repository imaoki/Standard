/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
fileIn @"definitionPool.ms"
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
  /*- @prop <StructDef:ConfigStruct> */
  public ConfigStruct,
  /*- @prop <StructDef:DialogStruct> */
  public DialogStruct,
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
  /*- @prop <StructDef:ObservableStruct> */
  public ObservableStruct,
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

  /*- @prop <String> バージョン番号。メジャー、マイナー、パッチの順。 */
  private version = "2.7.0",

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

  /*-
  @returns <String>
  */
  public fn GetVersion = (
    this.version
  ),

  on Create do (
    ::std = this
    /* 依存無し */
    this.AttributeUtility = (::standardDefinitionPool[@"AttributeUtility.ms"])()
    this.Comparer = (::standardDefinitionPool[@"Comparer.ms"])()
    this.DialogStruct = ::standardDefinitionPool[@"Dialog.ms"]
    this.DotNetUtility = (::standardDefinitionPool[@"DotNetUtility.ms"])()
    this.EasingStruct = ::standardDefinitionPool[@"Easing.ms"]
    this.ObservableStruct = ::standardDefinitionPool[@"Observable.ms"]
    this.PathUtilityStruct = ::standardDefinitionPool[@"PathUtility.ms"]
    this.ViewportUtility = (::standardDefinitionPool[@"ViewportUtility.ms"])()
    /*
    DotNetUtility.ms
    */
    this.EnumStruct = ::standardDefinitionPool[@"Enum.ms"]
    this.TimerStruct = ::standardDefinitionPool[@"Timer.ms"]
    /*
    DotNetUtility.ms
    Enum.ms
    */
    this.StringUtility = (::standardDefinitionPool[@"StringUtility.ms"])()
    /*
    DotNetUtility.ms
    StringUtility.ms
    */
    this.EncodingStruct = ::standardDefinitionPool[@"Encoding.ms"]
    /*
    Comparer.ms
    DotNetUtility.ms
    Encoding.ms
    Enum.ms
    PathUtility.ms
    */
    this.FileUtility = (::standardDefinitionPool[@"FileUtility.ms"])()
    /*
    FileUtility.ms
    PathUtility.ms
    StringUtility.ms
    */
    this.ConfigStruct = ::standardDefinitionPool[@"Config.ms"]
  )
)
