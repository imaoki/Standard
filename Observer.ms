/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
/*-
オブジェクトの状態が変化した際に通知を受け取る。
*/
struct ObserverStruct (
  /*-
  @prop <MAXScriptFunction> 通知を受け取る関数。
  @remarks 用途によって引数の扱いが異なる。

  構造体用のコールバック関数
  :   `context`と`params`の二つの引数を取る。

      ```maxscript
      fn update context params type: = (
        if classOf params == Array do (
          for param in params do (
            case param of (
              (#Foo): ()
              (#Bar): ()
              default: ()
            )
          )
        )
        ok
      )
      ```

      | 引数      | 内容                                      |
      | --------- | ----------------------------------------- |
      | `context` | 本構造体の`Context`プロパティに設定した値 |
      | `params`  | 更新されたパラメータや処理の名前の配列    |

  イベントコールバック用のコールバック関数
  :   `context`と`params`に加えて`type:`キーワード引数を取る。

      ```maxscript
      fn update context params type: = (
        if classOf type == Name then (
          case type of (
            (#NodeCloned): ()
            (#NodeCreated): ()
            default: ()
          )
        )
        else (
          if classOf params == Array do (
            for param in params do (
              case param of (
                default: ()
              )
            )
          )
        )
        ok
      )
      ```

      | 引数      | 内容                                      |
      | --------- | ----------------------------------------- |
      | `context` | 本構造体の`Context`プロパティに設定した値 |
      | `params`  | 発生したイベントの補足情報                |
      | `type:`   | 発生したイベントの名前                    |
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
