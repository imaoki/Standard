/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
/*-
オブジェクトの状態が変化した際に通知を受け取る。
*/
struct ObserverStruct (
  /*-
  @prop <MAXScriptFunction> 通知を受け取る関数。
  @remarks 以下のように実装する。

  ```maxscript
  fn update context type param = (
    case type of (
      (#Foo): ()
      (#Bar): ()
      default: ()
    )
    ok
  )
  ```

  | 引数      | 内容                            |
  | --------- | ------------------------------- |
  | `context` | `Context`プロパティに設定した値 |
  | `type`    | イベント名                      |
  | `param`   | イベントデータ                  |
  */
  public Callback,
  /*- @prop <Any> 発生した通知を識別するための値。通常は`this`を指定する。 */
  public Context,

  /*- @returns <Name> */
  public fn StructName = #ObserverStruct,

  /*-
  @param indent: <String>
  @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
  @returns <OkClass>
  */
  public fn Dump indent:"" out:listener = (
    format "%ObserverStruct\n" indent to:out
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

    local isEqualProperties = isProperty obj #Callback \
        and isProperty obj #Context \
        and obj.Callback == this.Callback \
        and obj.Context == this.Context

    isEqualStructName and isEqualProperties
  ),

  on Create do ()
)
