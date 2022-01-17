/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
/*-
.NETの`Timer`オブジェクトの`Tick`イベントのイベントハンドラ。
@param sender <DotNetObject:System.Windows.Forms.Timer> イベント発生元の`Timer`オブジェクト。
@param event <DotNetObject:System.EventArgs> イベントデータ。
@returns <OkClass>
*/
global mxsDotNetTimerTickHandler = fn mxsDotNetTimerTickHandler sender event = (
  if ::dotNetUtility.IsInstanceOf "System.Windows.Forms.Timer" sender do (
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
*/
struct TimerStruct (
  /*- @prop <Point> 作成パラメータ1。`Tick`イベントの発生間隔（ミリ秒）。既定値は`100`。 */
  public _CP1_ = 100,

  /*- @prop <Integer> `Tick`イベントが発生回数。既定値は`0`。 */
  private ticks = 0,
  /*- @prop <DotNetObject:System.Windows.Forms.Timer> */
  private timer,

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
    this.notify #(#Interval)
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
    this.notify #(#Ticks)
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
      isEqualProperties = ::dotNetUtility.IsInstanceOf "System.Windows.Forms.Timer" ov \
          and ov.Equals tv
    )

    isEqualStructName and isEqualProperties
  ),

  /*- @prop <Array[<Struct:ObserverStruct>]> */
  private observers = #(),

  /*-
  @param observer <Struct:ObserverStruct>
  @returns <BooleanClass> 成功した場合は`true`、失敗した場合は`false`。
  */
  public fn AddObserver observer = (
    if this.findObserver observer == 0 do (
      append this.observers observer
    )
    this.findObserver observer > 0
  ),

  /*-
  @param observer <Struct:ObserverStruct>
  @returns <BooleanClass> 成功した場合は`true`、失敗した場合は`false`。
  */
  public fn RemoveObserver observer = (
    local index = this.findObserver observer
    if index > 0 do (
      deleteItem this.observers index
    )
    this.findObserver observer == 0
  ),

  /*-
  @param observer <Struct:ObserverStruct>
  @returns <Integer>
  */
  private fn findObserver observer = (
    local index = 0
    for i = 1 to this.observers.Count while index == 0 do (
      if this.observers[i].Equals observer do (
        index = i
      )
    )
    index
  ),

  /*-
  @param params <Array[<Name>]> 通知するパラメータ名。
  @returns <OkClass>
  */
  private fn notify params = (
    for observer in this.observers do (
      observer.Callback observer.Context params
    )
    ok
  ),

  on Create do (
    this.timer = DotNetObject "System.Windows.Forms.Timer"
    if classOf this._CP1_ == Integer do (
      this.SetInterval this._CP1_
    )
    this.timer.Tag = DotNetMxsValue this
    DotNet.RemoveEventHandlers this.timer "Tick"
    DotNet.AddEventHandler this.timer "Tick" ::mxsDotNetTimerTickHandler
  )
)