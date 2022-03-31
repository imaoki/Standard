/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
/*-
通知を受け取る仕組みを提供する。
*/
struct ObserverStruct (
  /*-
  @prop <MAXScriptFunction|UndefinedClass> 通知を受け取る関数。既定値は`undefined`。
  @remarks 以下のように実装する。

  ```maxscript
  fn update type param = (
    case type of (
      (#Foo): ()
      (#Bar): ()
      default: ()
    )
    ok
  )
  ```

  | 引数    | 内容       |
  | ------- | ---------- |
  | `type`  | 通知名     |
  | `param` | 通知データ |
  */
  public Update,

  /*- @returns <Name> */
  public fn StructName = #ObserverStruct,

  /*-
  @param indent: <String>
  @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
  @returns <OkClass>
  */
  public fn Dump indent:"" out:listener = (
    format "%ObserverStruct\n" indent to:out
    format "%  Update:%\n" indent this.Update to:out
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

    local isEqualProperties = isProperty obj #Update \
        and obj.Update == this.Update

    isEqualStructName and isEqualProperties
  ),

  on Create do ()
)
