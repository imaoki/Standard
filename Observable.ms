/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
/*-
通知を発行する仕組みを提供する。
@remarks 通知を受け取る関数は次のように実装する。

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
struct ObservableStruct (
  /*- @prop <Array[<MAXScriptFunction>]> */
  private observers = #(),

  /*
  public fn Count = (),
  public fn Notify type param = (),
  public fn Subscribe obj = (),
  public fn Unsubscribe obj = (),

  private fn findObserver obj = (),
  private fn isValidObserver obj = (),
  */

  /*-
  登録されているオブザーバの数を取得する。
  @returns <Integer>
  */
  public fn Count = (
    this.observers.Count
  ),

  /*-
  通知を発行する。
  @param type <Name> 通知名。
  @param param <Any> 通知データ。
  @returns <OkClass>
  */
  public fn Notify type param = (
    for observer in this.observers do (
      observer type param
    )
    ok
  ),

  /*-
  @param obj <MAXScriptFunction>
  @returns <BooleanClass> オブザーバが存在する場合は`true`、失敗した場合は`false`。
  */
  public fn Subscribe obj = (
    if this.findObserver obj == 0 do (
      append this.observers obj
    )
    this.findObserver obj > 0
  ),

  /*-
  @param obj <MAXScriptFunction>
  @returns <BooleanClass> 成功した場合は`true`、失敗した場合は`false`。
  */
  public fn Unsubscribe obj = (
    local index = this.findObserver obj
    if index > 0 do (
      deleteItem this.observers index
    )
    this.findObserver obj <= 0
  ),

  /*-
  @param obj <Any>
  @returns <Integer>
  */
  private fn findObserver obj = (
    local index = -1
    if this.isValidObserver obj do (
      index = 0
    )
    for i = 1 to this.observers.Count while index == 0 do (
      if this.observers[i] == obj do (
        index = i
      )
    )
    index
  ),

  /*-
  @param obj <Any>
  @returns <BooleanClass>
  */
  private fn isValidObserver obj = (
    classOf obj == MAXScriptFunction
  ),

  /*- @returns <Name> */
  public fn StructName = #ObservableStruct,

  /*-
  @param indent: <String>
  @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
  @returns <OkClass>
  */
  public fn Dump indent:"" out:listener = (
    format "%ObservableStruct\n" indent to:out
    format "%  observers:%\n" indent this.observers.Count to:out
    for i = 1 to this.observers.Count do (
      format "%    [%]:%\n" indent i this.observers[i] to:out
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

  on Create do ()
)
