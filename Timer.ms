/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
/*-
.NETの`Timer`オブジェクトの`Tick`イベントのイベントハンドラ。
@param sender <DotNetObject:System.Windows.Forms.Timer> イベント発生元の`Timer`オブジェクト。
@param event <DotNetObject:System.EventArgs> イベントデータ。
@returns <OkClass>
*/
global mxsDotNetTimerTickHandler = fn mxsDotNetTimerTickHandler sender event = (
  if classOf sender == DotNetObject \
      and (DotNet.GetType "System.Windows.Forms.Timer").IsInstanceOfType sender do (
    if classOf sender.Tag == DotNetMxsValue do (
      local timerObject = sender.Tag.Value
      if isStruct timerObject \
          and isProperty timerObject #StructName \
          and classOf timerObject.StructName == MAXScriptFunction \
          and timerObject.StructName() == #TimerStruct do (
        timerObject.UpdateTicks()
      )
    )
  )
  ok
)
/*-
.NETの[Timer](https://docs.microsoft.com/ja-jp/dotnet/api/system.windows.forms.timer?view=netframework-4.8)のラッパー。
@remarks 作成パラメータ
:   ```maxscript
    TimerStruct [interval]
    ```

通知
:   | 通知名      | 通知データ               | タイミング                           |
    | ----------- | ------------------------ | ------------------------------------ |
    | `#Interval` | 新たな発生間隔（ミリ秒） | `Tick`イベントの発生間隔を設定した後 |
    | `#Ticks`    | 自己インスタンス         | `Tick`イベントが発生した直後         |
*/
struct TimerStruct (
  /*- @prop <Point> 作成パラメータ1。`Tick`イベントの発生間隔（ミリ秒）。既定値は`100`。 */
  public _CP1_ = 100,

  /*- @prop <Struct:DotNetUtilityStruct> */
  private dotNetUtility,
  /*- @prop <Integer> `Tick`イベントが発生回数。既定値は`0`。 */
  private ticks = 0,
  /*- @prop <DotNetObject:System.Windows.Forms.Timer> */
  private timer,

  /*
  public fn GetInterval = (),
  public fn GetTicks = (),
  public fn GetTimer = (),
  public fn IsEnabled = (),
  public fn Reset = (),
  public fn Restart = (),
  public fn SetInterval input = (),
  public fn Start = (),
  public fn Stop = (),
  public fn UpdateTicks = (),
  */

  /*-
  `Tick`イベントの発生間隔（ミリ秒）を取得する。
  @returns <Integer>
  */
  public fn GetInterval = (
    this.timer.Interval
  ),

  /*-
  `Tick`イベントが発生回数を取得する。
  @returns <Integer>
  */
  public fn GetTicks = (
    this.ticks
  ),

  /*-
  `Timer`オブジェクトを取得する。
  @returns <DotNetObject:System.Windows.Forms.Timer>
  */
  public fn GetTimer = (
    this.timer
  ),

  /*-
  タイマーが実行されているかどうかを取得する。
  @returns <BooleanClass>
  */
  public fn IsEnabled = (
    this.timer.Enabled
  ),

  /*-
  タイマーを停止して`ticks`を`0`にリセットする。
  @returns <OkClass>
  @remarks `ticks`は変更するが通知は発行しない。
  */
  public fn Reset = (
    this.Stop()
    this.ticks = 0
    ok
  ),

  /*-
  タイマーを停止して`ticks`を`0`にリセットし、再度タイマーを起動する。
  @returns <OkClass>
  */
  public fn Restart = (
    this.Reset()
    this.Start()
    ok
  ),

  /*-
  `Tick`イベントの発生間隔（ミリ秒）を設定する。
  @param input <Integer> `1`以上の値。
  @returns <Integer> 新たに設定された値。
  */
  public fn SetInterval input = (
    if input < 1 do input = 1
    this.timer.Interval = input
    this.StateChanged.Notify #Interval this.timer.Interval
    this.GetInterval()
  ),

  /*-
  タイマーを起動する。
  @returns <OkClass>
  */
  public fn Start = (
    this.timer.Start()
    ok
  ),

  /*-
  タイマーを停止する。
  @returns <OkClass>
  */
  public fn Stop = (
    this.timer.Stop()
    ok
  ),

  /*-
  `Tick`イベントが発生した時に呼ばれ、`ticks`を更新する。
  @returns <Integer> 新たに設定された`ticks`の値。
  */
  public fn UpdateTicks = (
    this.ticks += 1
    this.StateChanged.Notify #Ticks this
    this.GetTicks()
  ),

  /*- @returns <Name> */
  public fn StructName = #TimerStruct,

  /*-
  @param indent: <String>
  @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
  @returns <OkClass>
  */
  public fn Dump indent:"" out:listener = (
    format "%TimerStruct\n" indent to:out
    format "%  ticks:%\n" indent this.ticks to:out
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

    local isEqualProperties = isProperty obj #GetInterval \
        and classOf obj.GetInterval == MAXScriptFunction \
        and obj.GetInterval() == this.GetInterval() \
        and isProperty obj #GetTicks \
        and classOf obj.GetTicks == MAXScriptFunction \
        and obj.GetTicks() == this.GetTicks() \
        and isProperty obj #GetTimer \
        and classOf obj.GetTimer == MAXScriptFunction

    if isEqualProperties do (
      local ov = obj.GetTimer()
      local tv = this.GetTimer()
      isEqualProperties = this.dotNetUtility.IsInstanceOf "System.Windows.Forms.Timer" ov \
          and ov.Equals tv
    )

    isEqualStructName and isEqualProperties
  ),

  /*- @prop <Struct:ObservableStruct> */
  public StateChanged,

  on Create do (
    this.StateChanged = (::standardDefinitionPool[@"Observable.ms"])()
    this.dotNetUtility = (::standardDefinitionPool[@"DotNetUtility.ms"])()
    this.timer = DotNetObject "System.Windows.Forms.Timer"
    if classOf this._CP1_ == Integer do (
      this.SetInterval this._CP1_
    )
    this.timer.Tag = DotNetMxsValue this
    DotNet.RemoveEventHandlers this.timer "Tick"
    DotNet.AddEventHandler this.timer "Tick" ::mxsDotNetTimerTickHandler
  )
)
