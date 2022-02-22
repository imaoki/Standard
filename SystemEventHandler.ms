/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
/*- @var <Struct:SystemEventHandlerStruct> */
global systemEventHandler
/*-
イベントコールバックの処理を共通化するための仕組みを提供する。
@remarks 対応しているコールバックの種類は以下の通り。

* 一般イベントコールバック

* 時間変更コールバック

* ビューポート再描画コールバック
*/
struct SystemEventHandlerStruct (
  /*- @prop <Dictionary <Name> <Struct:TimerStruct>> イベント毎の遅延タイマー。 */
  private delayTimerTable,
  /*- @prop <Dictionary <Name> <Any>> イベント毎の補足情報。 */
  private eventParamTable,
  /*- @prop <Dictionary <Name> <Array[<Struct:ObserverStruct>]>> イベント毎のオブザーバ。 */
  private observerTable,

  /*- @prop <String> 自己のインスタンスを格納するグローバル変数の名前。既定値は`"systemEventHandler"`。 */
  private globalVarName = "systemEventHandler",

  /*-
  指定したイベントにオブザーバを登録する。
  @param eventType <Name>
  | 種類              | 内容               |
  | ----------------- | ------------------ |
  | `#TimeChange`     | 時間変更           |
  | `#ViewportRedraw` | ビューポート再描画 |
  | その他            | 一般イベント       |
  @param observer <Struct:ObserverStruct> `Callback`プロパティにはイベントコールバック用のメソッドを設定する。詳細は`ObserverStruct`のドキュメントを参照。
  @param delayInterval: <Integer> 最後にイベントが通知されてからコールバック関数を呼び出すまでの遅延時間。ミリ秒で指定する。既定値は`0`。
  遅延時間以内に同じイベントが通知された場合は時間をリセットして計測し直す。
  これにより短い間隔で大量に発生した同一イベントの通知を一度にまとめることができる。
  `0`を指定した場合はこの遅延処理を行わない。
  @returns <BooleanClass> 成功した場合は`true`、失敗した場合は`false`。
  */
  public fn Add eventType observer delayInterval:0 = (
    if not hasDictValue this.delayTimerTable eventType do (
      -- 遅延タイマーが未登録の場合は追加
      local delayTimer = this.createDelayTimer (delayInterval as Integer)
      this.delayTimerTable[eventType] = delayTimer
    )
    if this.findObserver eventType observer == 0 do (
      -- オブザーバが未登録の場合は追加
      if not hasDictValue this.observerTable eventType do (
        this.observerTable[eventType] = #()
      )
      append this.observerTable[eventType] observer
    )
    if this.GetRegisteredCallbackCount eventType == 0 do (
      -- コールバック未登録の場合はコールバックを登録
      case eventType of (
        (#TimeChange): this.registerTimeChangeCallback()
        (#ViewportRedraw): this.registerViewportRedrawCallback()
        default: this.registerGeneralEventCallback eventType
      )
    )
    this.findObserver eventType observer > 0
  ),

  /*-
  指定したイベントに登録されている`SystemEventHandlerStruct`由来のコールバックの数を取得する。
  @param eventType <Name>
  @returns <Integer>
  */
  public fn GetRegisteredCallbackCount eventType = (
    local count = 0
    case eventType of (
      (#TimeChange): (
        local callbackInfos = showRegisteredTimeCallbacks asArray:true
        for callbackInfo in callbackInfos do (
          if classOf callbackInfo == Array and callbackInfo.Count == 3 \
              and callbackInfo[3] == this.InvokeTimeChange do (
            count += 1
          )
        )
      )
      (#ViewportRedraw): (
        local callbackInfos = showRegisteredRedrawViewsCallbacks asArray:true
        for callbackInfo in callbackInfos do (
          if classOf callbackInfo == Array and callbackInfo.Count == 3 \
              and callbackInfo[3] == this.InvokeViewportRedraw do (
            count += 1
          )
        )
      )
      default: (
        count = (Callbacks.Show eventType asArray:true id:#SystemEventHandler).Count
      )
    )
    count
  ),

  /*-
  一般イベントが通知された時に呼ばれる。
  @param eventType <Name> イベントの名前。
  @param eventParam <Any> イベントの補足情報。
  @returns <OkClass>
  */
  public fn InvokeGeneralEvent eventType eventParam = (
    this.invokeTimer eventType eventParam
    ok
  ),

  /*-
  イベントに登録したコールバック関数を呼び出す。
  @param context <Struct:TimerStruct>
  @param params <Array[<Name>]|Any>
  @param type: <Name>
  @returns <OkClass>
  @remarks タイマーオブジェクトから呼ばれる。
  */
  public fn InvokeObserver context params type: = (
    if this.isValidTimer context and context.GetTicks() > 0 do (
      context.Reset()
      if classOf params == Array do (
        for param in params do (
          case param of (
            (#Ticks): (
              local eventType = this.getEventTypeFromTimer context
              if classOf eventType == Name do (
                local eventParam = this.getEventParam eventType
                local observers = this.observerTable[eventType]
                for observer in observers do (
                  observer.Callback observer.Context eventParam type:eventType
                )
              )
            )
            default: ()
          )
        )
      )
    )
    ok
  ),

  /*-
  アニメーション時間が変更された時に呼ばれる。
  @returns <OkClass>
  @remarks `eventParam`には現在時間が渡される。
  */
  public fn InvokeTimeChange = (
    this.invokeTimer #TimeChange (copy ::currentTime)
    ok
  ),

  /*-
  ビューポートが再描画された時に呼ばれる。
  @returns <OkClass>
  @remarks `eventParam`には`undefined`が渡される。
  */
  public fn InvokeViewportRedraw = (
    this.invokeTimer #ViewportRedraw undefined
    ok
  ),

  /*-
  指定したイベントからオブザーバを登録解除する。
  @param eventType <Name>
  | 種類              | 内容               |
  | ----------------- | ------------------ |
  | `#TimeChange`     | 時間変更           |
  | `#ViewportRedraw` | ビューポート再描画 |
  | その他            | 一般イベント       |
  @param observer <Struct:ObserverStruct>
  @returns <BooleanClass> 成功した場合は`true`、失敗した場合は`false`。
  */
  public fn Remove eventType observer = (
    local index = this.findObserver eventType observer
    if index > 0 do (
      deleteItem this.observerTable[eventType] index
      if this.observerTable[eventType].Count == 0 do (
        case eventType of (
          (#TimeChange): this.unregisterTimeChangeCallback()
          (#ViewportRedraw): this.unregisterViewportRedrawCallback()
          default: this.unregisterGeneralEventCallback eventType
        )
        removeDictValue this.delayTimerTable eventType
        removeDictValue this.eventParamTable eventType
        removeDictValue this.observerTable eventType
      )
    )
    this.findObserver eventType observer == 0
  ),

  /*-
  アンインストールする。
  @returns <OkClass>
  */
  public fn Uninstall = (
    this.unregisterAllCallbacks()
    this.destroyGlobalVar()
    ok
  ),

  /*-
  遅延タイマーを作成する。
  @param delayInterval <Integer>
  @returns <Struct:TimerStruct>
  */
  private fn createDelayTimer delayInterval = (
    local timerObject = ::TimerStruct delayInterval
    timerObject.AddObserver (::ObserverStruct this.InvokeObserver timerObject)
    timerObject
  ),

  /*-
  グローバル変数を定義する。
  @returns <OkClass>
  */
  private fn defineGlobalVar = (
    execute ("global " + this.globalVarName)
    if GlobalVars.IsGlobal this.globalVarName do (
      GlobalVars.Set this.globalVarName this
      format "[define]::%\n" this.globalVarName
    )
    ok
  ),

  /*-
  グローバル変数を破棄する。
  @returns <OkClass>
  @remarks 安全性を鑑みて変数名は削除せず、値のみ`undefined`で上書きする。
  */
  private fn destroyGlobalVar = (
    if GlobalVars.IsGlobal this.globalVarName do (
      GlobalVars.Set this.globalVarName undefined
      format "[destroy]::%\n" this.globalVarName
    )
    ok
  ),

  /*-
  @param eventType <Name>
  @param observer <Struct:ObserverStruct>
  @returns <Integer>
  */
  private fn findObserver eventType observer = (
    local index = 0
    if hasDictValue this.observerTable eventType do (
      local observers = this.observerTable[eventType]
      if classOf observers == Array do (
        for i = 1 to observers.Count while index == 0 do (
          if observers[i].Equals observer do (
            index = i
          )
        )
      )
    )
    index
  ),

  /*-
  一般イベント用のコールバックスクリプトを生成する。
  @param eventType <Name>
  @returns <String>
  */
  private fn generateGeneralEventScript eventType = (
    local script = StringStream ""
    format "::%.InvokeGeneralEvent % (Callbacks.NotificationParam())" this.globalVarName eventType to:script
    script as String
  ),

  /*-
  指定したイベントタイプの補足情報を取得する。
  @param eventType <Name>
  @returns <Any|UndefinedClass>
  @remarks イベントタイプが見つからない場合は`undefined`を返す。
  */
  private fn getEventParam eventType = (
    local eventParam = undefined
    if hasDictValue this.eventParamTable eventType do (
      eventParam = this.eventParamTable[eventType]
      if isDeleted eventParam do (
        eventParam = undefined
      )
    )
    eventParam
  ),

  /*-
  タイマーオブジェクトからイベントタイプを取得する。
  @param timerObject <Struct:TimerStruct>
  @returns <Name|UndefinedClass>
  @remarks イベントタイプが見つからない場合は`undefined`を返す。
  */
  private fn getEventTypeFromTimer timerObject = (
    local eventType = undefined
    for key in this.delayTimerTable.Keys while eventType == undefined do (
      local delayTimer = this.delayTimerTable[key]
      if delayTimer.Equals timerObject do (
        eventType = key
      )
    )
    eventType
  ),

  /*-
  イベントに登録したコールバック関数を呼び出す。
  @param eventType <Name>
  @param eventParam <Any>
  @returns <OkClass>
  */
  private fn invokeTimer eventType eventParam = (
    this.eventParamTable[eventType] = eventParam
    local delayTimer = this.delayTimerTable[eventType]
    if this.isValidTimer delayTimer do (
      if delayTimer.IsEnabled() then (
        -- タイマーが実行中の場合
        if delayTimer.GetTicks() > 0 then (
          -- 遅延時間を超えた場合は停止
          -- 正常であれば`InvokeObserver`側で停止しているはずだが念のため
          delayTimer.Reset()
        )
        else (
          -- 遅延時間内の場合はリスタート
          delayTimer.Restart()
        )
      )
      else (
        if delayTimer.GetInterval() == 0 then (
          -- 遅延時間が`0`の場合は即時実行
          delayTimer.UpdateTicks()
        )
        else (
          delayTimer.Start()
        )
      )
    )
    ok
  ),

  /*-
  @param obj <Any>
  @returns <BooleanClass>
  */
  private fn isValidTimer obj = (
    isStruct obj \
        and isProperty obj #StructName \
        and classOf obj.StructName == MAXScriptFunction \
        and obj.StructName() == #TimerStruct
  ),

  /*-
  一般イベントのコールバック関数を登録する。
  @param eventType <Name>
  @returns <OkClass>
  */
  private fn registerGeneralEventCallback eventType = (
    local script = this.generateGeneralEventScript eventType
    Callbacks.AddScript eventType script id:#SystemEventHandler
    ok
  ),

  /*-
  時間変更のコールバック関数を登録する。
  @returns <OkClass>
  */
  private fn registerTimeChangeCallback = (
    registerTimeCallback this.InvokeTimeChange
    ok
  ),

  /*-
  ビューポート再描画のコールバック関数を登録する。
  @returns <OkClass>
  */
  private fn registerViewportRedrawCallback = (
    registerRedrawViewsCallback this.InvokeViewportRedraw
    ok
  ),

  /*-
  全てのコールバック関数を登録解除する。
  @returns <OkClass>
  */
  private fn unregisterAllCallbacks = (
    for eventType in this.observerTable.Keys do (
      case eventType of (
        (#TimeChange): this.unregisterTimeChangeCallback()
        (#ViewportRedraw): this.unregisterViewportRedrawCallback()
        default: this.unregisterGeneralEventCallback eventType
      )
    )
  ),

  /*-
  一般イベントのコールバック関数を登録解除する。
  @param eventType <Name>
  @returns <OkClass>
  */
  private fn unregisterGeneralEventCallback eventType = (
    Callbacks.RemoveScripts eventType id:#SystemEventHandler
    ok
  ),

  /*-
  時間変更のコールバック関数を登録解除する。
  @returns <OkClass>
  */
  private fn unregisterTimeChangeCallback = (
    unregisterTimeCallback this.InvokeTimeChange
    ok
  ),

  /*-
  ビューポート再描画のコールバック関数を登録解除する。
  @returns <OkClass>
  */
  private fn unregisterViewportRedrawCallback = (
    unregisterRedrawViewsCallback this.InvokeViewportRedraw
    ok
  ),

  /*- @returns <Name> */
  public fn StructName = #SystemEventHandlerStruct,

  /*-
  @param indent: <String>
  @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
  @returns <OkClass>
  */
  public fn Dump indent:"" out:listener = (
    format "%SystemEventHandlerStruct\n" indent to:out
    format "%  globalVarName:\"%\"\n" indent this.globalVarName to:out
    format "%  delayTimerTable:%\n" indent this.delayTimerTable.Count to:out
    for key in this.delayTimerTable.Keys do (
      format "%    [%]:\n" indent (::stringUtility.ToPascalCase key) to:out
      this.delayTimerTable[key].Dump indent:(indent + "      ") out:out
    )
    format "%  eventParamTable:%\n" indent this.eventParamTable.Count to:out
    for key in this.eventParamTable.Keys do (
      format "%    [%]:%\n" indent (::stringUtility.ToPascalCase key) this.eventParamTable[key] to:out
    )
    format "%  observerTable:%\n" indent this.observerTable.Count to:out
    for key in this.observerTable.Keys do (
      format "%    [%]:%\n" indent (::stringUtility.ToPascalCase key) this.observerTable[key].Count to:out
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

  on Create do (
    this.defineGlobalVar()
    this.delayTimerTable = Dictionary #Name
    this.eventParamTable = Dictionary #Name
    this.observerTable = Dictionary #Name
  )
)
::SystemEventHandlerStruct()
::SystemEventHandlerStruct
