/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
/*-
ダイアログの作成と破棄に伴う処理をカプセル化するための構造体。
@remarks 作成パラメータ
:   ```maxscript
    DialogStruct rolloutDef [initSize] [initPosition] [menuDef]
    ```

通知
:   | 通知名              | 通知データ                    | タイミング                             |
    | ------------------- | ----------------------------- | -------------------------------------- |
    | `#DialogCreated`    | `undefined`                   | ダイアログを作成した直後               |
    | `#DialogDestroyed`  | `undefined`                   | ダイアログを破棄した直後               |
    | `#InitPosition`     | 新たな`initPosition`値        | `initPosition`を設定した後             |
    | `#InitSize`         | 新たな`initSize`値            | `initSize`を設定した後                 |
    | `#IsDisplayed`      | `IsDisplayed`メソッドの戻り値 | ダイアログの表示状態を変更した後       |
    | `#LockHeight`       | 新たな`lockHeight`値          | `lockHeight`を設定した後               |
    | `#LockWidth`        | 新たな`lockWidth`値           | `lockWidth`を設定した後                |
    | `#MenuDef`          | 新たな`menuDef`値             | `menuDef`を設定した後                  |
    | `#Modal`            | 新たな`modal`値               | `modal`を設定した後                    |
    | `#PositionChanged`  | `undefined`                   | ダイアログの現在の位置を設定した直後   |
    | `#RolloutDef`       | 新たな`rolloutDef`値          | `rolloutDef`を設定した後               |
    | `#SizeChanged`      | `undefined`                   | ダイアログの現在のサイズを設定した直後 |
    | `#StyleBorder`      | 新たな`styleBorder`値         | `styleBorder`を設定した後              |
    | `#StyleMaximizeBox` | 新たな`styleMaximizeBox`値    | `styleMaximizeBox`を設定した後         |
    | `#StyleMinimizeBox` | 新たな`styleMinimizeBox`値    | `styleMinimizeBox`を設定した後         |
    | `#StyleResizing`    | 新たな`styleResizing`値       | `styleResizing`を設定した後            |
    | `#StyleSunkenedge`  | 新たな`styleSunkenedge`値     | `styleSunkenedge`を設定した後          |
    | `#StyleSysmenu`     | 新たな`styleSysmenu`値        | `styleSysmenu`を設定した後             |
    | `#StyleTitleBar`    | 新たな`styleTitleBar`値       | `styleTitleBar`を設定した後            |
    | `#StyleToolWindow`  | 新たな`styleToolWindow`値     | `styleToolWindow`を設定した後          |

設定ファイル
:   | パス                                         | 値                         |
    | -------------------------------------------- | -------------------------- |
    | `[#'RolloutName.Dialog'][#InitPosition]`     | 現在の`initPosition`値     |
    | `[#'RolloutName.Dialog'][#InitSize]`         | 現在の`initSize`値         |
    | `[#'RolloutName.Dialog'][#LockHeight]`       | 現在の`lockHeight`値       |
    | `[#'RolloutName.Dialog'][#LockWidth]`        | 現在の`lockWidth`値        |
    | `[#'RolloutName.Dialog'][#Modal]`            | 現在の`modal`値            |
    | `[#'RolloutName.Dialog'][#StyleBorder]`      | 現在の`styleBorder`値      |
    | `[#'RolloutName.Dialog'][#StyleMaximizeBox]` | 現在の`styleMaximizeBox`値 |
    | `[#'RolloutName.Dialog'][#StyleMinimizeBox]` | 現在の`styleMinimizeBox`値 |
    | `[#'RolloutName.Dialog'][#StyleResizing]`    | 現在の`styleResizing`値    |
    | `[#'RolloutName.Dialog'][#StyleSunkenedge]`  | 現在の`styleSunkenedge`値  |
    | `[#'RolloutName.Dialog'][#StyleSysmenu]`     | 現在の`styleSysmenu`値     |
    | `[#'RolloutName.Dialog'][#StyleTitleBar]`    | 現在の`styleTitleBar`値    |
    | `[#'RolloutName.Dialog'][#StyleToolWindow]`  | 現在の`styleToolWindow`値  |
*/
struct DialogStruct (
  /*- @prop <RolloutClass> 作成パラメータ1。ロールアウト定義。既定値は`undefined`。 */
  public _CP1_,
  /*- @prop <Point2> 作成パラメータ2。ダイアログの初期サイズ。既定値は`[160, 160]`。 */
  public _CP2_ = [160, 160],
  /*- @prop <Point2|UndefinedClass> 作成パラメータ3。ダイアログの初期位置。既定値は`undefined`。 */
  public _CP3_,
  /*- @prop <RCMenu|UndefinedClass> 作成パラメータ4。タイトルバーに表示されるメニュー定義。既定値は`undefined`。 */
  public _CP4_,

  /*- @prop <Point2|UndefinedClass> ダイアログの初期位置。既定値は`undefined`。 */
  private initPosition,
  /*- @prop <Point2> ダイアログの初期サイズ。既定値は`[160, 160]`。 */
  private initSize = [160, 160],
  /*- @prop <BooleanClass> 実際の状態に関わらずダイアログを閉じたことにするかどうか。既定値は`false`。 */
  private isDialogDestroyed = false,
  /*- @prop <BooleanClass> 高さを固定するかどうか。既定値は`false`。 */
  private lockHeight = false,
  /*- @prop <BooleanClass> 幅を固定するかどうか。既定値は`false`。 */
  private lockWidth = false,
  /*- @prop <RCMenu|UndefinedClass> タイトルバーに表示されるメニュー定義。既定値は`undefined`。 */
  private menuDef,
  /*- @prop <BooleanClass> モーダルダイアログにするかどうか。既定値は`false`。 */
  private modal = false,
  /*- @prop <RolloutClass> ロールアウト定義。既定値は`undefined`。 */
  private rolloutDef,
  /*- @prop <BooleanClass> 二重境界線を持つかどうか。既定値は`false`。 */
  private styleBorder = false,
  /*- @prop <BooleanClass> 最大化ボタンを持つかどうか。既定値は`false`。 */
  private styleMaximizeBox = false,
  /*- @prop <BooleanClass> 最小化ボタンを持つかどうか。既定値は`false`。 */
  private styleMinimizeBox = false,
  /*- @prop <BooleanClass> サイズ変更可能かどうか。既定値は`false`。 */
  private styleResizing = false,
  /*- @prop <BooleanClass> 境界線の内側をくぼませるかどうか。既定値は`false`。 */
  private styleSunkenedge = false,
  /*- @prop <BooleanClass> タイトルバーに各種ボタンが表示されるかどうか。既定値は`true`。 */
  private styleSysmenu = true,
  /*- @prop <BooleanClass> タイトルバーを持つかどうか。既定値は`false`。 */
  private styleTitleBar = false,
  /*- @prop <BooleanClass> ツールウィンドウにするかどうか。既定値は`true`。 */
  private styleToolWindow = true,

  /*
  public fn Create = (),
  public fn Destroy = (),
  public fn DisableIsDialogDestroyed = (),
  public fn GetInitPosition = (),
  public fn GetInitSize = (),
  public fn GetLockHeight = (),
  public fn GetLockWidth = (),
  public fn GetMenuDef = (),
  public fn GetModal = (),
  public fn GetPosition = (),
  public fn GetRolloutDef = (),
  public fn GetRolloutName = (),
  public fn GetSize = (),
  public fn GetStyleBorder = (),
  public fn GetStyleMaximizeBox = (),
  public fn GetStyleMinimizeBox = (),
  public fn GetStyleResizing = (),
  public fn GetStyleSunkenedge = (),
  public fn GetStyleSysmenu = (),
  public fn GetStyleTitleBar = (),
  public fn GetStyleToolWindow = (),
  public fn IsDisplayed = (),
  public fn Load config = (),
  public fn RaiseDialogDestroyed = (),
  public fn Save config = (),
  public fn SetInitPosition input = (),
  public fn SetInitSize input = (),
  public fn SetLockHeight input = (),
  public fn SetLockWidth input = (),
  public fn SetMenuDef def = (),
  public fn SetModal input = (),
  public fn SetPosition input = (),
  public fn SetRolloutDef def = (),
  public fn SetSize input = (),
  public fn SetStyleBorder input = (),
  public fn SetStyleMaximizeBox input = (),
  public fn SetStyleMinimizeBox input = (),
  public fn SetStyleResizing input = (),
  public fn SetStyleSunkenedge input = (),
  public fn SetStyleSysmenu input = (),
  public fn SetStyleTitleBar input = (),
  public fn SetStyleToolWindow input = (),

  private fn generateConfigKey = (),
  private fn generateStyle = (),
  private fn inDialog obj = (),
  private fn isValidConfig obj = (),
  private fn isValidMenuDef obj = (),
  private fn isValidRolloutDef obj = (),
  */

  /*-
  ダイアログを作成する。
  @returns <BooleanClass> 正常に作成できた場合は`true`、作成できなかった場合は`false`。
  @remarks `isDialogDestroyed`は必ず`false`になる。
  */
  public fn Create = (
    this.DisableIsDialogDestroyed()
    if this.isValidRolloutDef this.rolloutDef do (
      local w = this.initSize.X as Integer
      local h = this.initSize.Y as Integer
      local menu = unsupplied
      if this.isValidMenuDef this.menuDef do (
        menu = this.menuDef
      )
      local pos = unsupplied
      if classOf this.initPosition == Point2 do (
        pos = this.initPosition
      )
      local style = this.generateStyle()
      createDialog this.rolloutDef w h \
          lockHeight:this.lockHeight \
          lockWidth:this.lockWidth \
          menu:menu \
          modal:this.modal \
          pos:pos \
          style:style
      if classOf this.initPosition != Point2 do (
        this.initPosition = this.GetPosition()
      )
      this.StateChanged.Notify #IsDisplayed (this.IsDisplayed())
      this.StateChanged.Notify #DialogCreated undefined
    )
    this.IsDisplayed()
  ),

  /*-
  ダイアログを破棄する。
  @returns <BooleanClass> 正常に破棄できた場合は`true`、破棄できなかった場合は`false`。
  */
  public fn Destroy = (
    if this.inDialog this.rolloutDef do (
      destroyDialog this.rolloutDef
      this.StateChanged.Notify #IsDisplayed (this.IsDisplayed())
      this.StateChanged.Notify #DialogDestroyed undefined
    )
    not this.IsDisplayed()
  ),

  /*-
  `isDialogDestroyed`を`false`にする。
  @returns <OkClass>
  */
  public fn DisableIsDialogDestroyed = (
    this.isDialogDestroyed = false
    ok
  ),

  /*-
  ダイアログの初期位置を取得する。
  @returns <Point2|UndefinedClass>
  */
  public fn GetInitPosition = (
    this.initPosition
  ),

  /*-
  ダイアログの初期サイズを取得する。
  @returns <Point2>
  */
  public fn GetInitSize = (
    this.initSize
  ),

  /*-
  高さを固定するかどうかを取得する。
  @returns <BooleanClass>
  */
  public fn GetLockHeight = (
    this.lockHeight
  ),

  /*-
  幅を固定するかどうかを取得する。
  @returns <BooleanClass>
  */
  public fn GetLockWidth = (
    this.lockWidth
  ),

  /*-
  タイトルバーに表示されるメニュー定義を取得する。
  @returns <RCMenu|UndefinedClass>
  */
  public fn GetMenuDef = (
    this.menuDef
  ),

  /*-
  モーダルダイアログにするかどうかを取得する。
  @returns <BooleanClass>
  */
  public fn GetModal = (
    this.modal
  ),

  /*-
  ダイアログの現在の位置を取得する。
  @returns <Point2|UndefinedClass>
  @remarks 取得できない場合は`undefined`を返す。
  */
  public fn GetPosition = (
    local pos = undefined
    if this.isValidRolloutDef this.rolloutDef do (
      pos = getDialogPos this.rolloutDef
    )
    pos
  ),

  /*-
  ロールアウト定義を取得する。
  @returns <RolloutClass>
  */
  public fn GetRolloutDef = (
    this.rolloutDef
  ),

  /*-
  ロールアウト定義の名前を取得する。
  @returns <Name|UndefinedClass>
  @remarks 取得できない場合は`undefined`を返す。
  */
  public fn GetRolloutName = (
    local rolloutName = undefined
    if this.isValidRolloutDef this.rolloutDef do (
      rolloutName = this.rolloutDef.Name as Name
    )
    rolloutName
  ),

  /*-
  ダイアログの現在のサイズを取得する。
  @returns <Point2|UndefinedClass>
  @remarks 取得できない場合は`undefined`を返す。
  */
  public fn GetSize = (
    local size = undefined
    if this.isValidRolloutDef this.rolloutDef do (
      size = getDialogSize this.rolloutDef
    )
    size
  ),

  /*-
  二重境界線を持つかどうかを取得する。
  @returns <BooleanClass>
  */
  public fn GetStyleBorder = (
    this.styleBorder
  ),

  /*-
  最大化ボタンを持つかどうかを取得する。
  @returns <BooleanClass>
  */
  public fn GetStyleMaximizeBox = (
    this.styleMaximizeBox
  ),

  /*-
  最小化ボタンを持つかどうかを取得する。
  @returns <BooleanClass>
  */
  public fn GetStyleMinimizeBox = (
    this.styleMinimizeBox
  ),

  /*-
  サイズ変更可能かどうかを取得する。
  @returns <BooleanClass>
  */
  public fn GetStyleResizing = (
    this.styleResizing
  ),

  /*-
  境界線の内側をくぼませるかどうかを取得する。
  @returns <BooleanClass>
  */
  public fn GetStyleSunkenedge = (
    this.styleSunkenedge
  ),

  /*-
  タイトルバーに各種ボタンが表示されるかどうかを取得する。
  @returns <BooleanClass>
  */
  public fn GetStyleSysmenu = (
    this.styleSysmenu
  ),

  /*-
  タイトルバーを持つかどうかを取得する。
  @returns <BooleanClass>
  */
  public fn GetStyleTitleBar = (
    this.styleTitleBar
  ),

  /*-
  ツールウィンドウにするかどうかを取得する。
  @returns <BooleanClass>
  */
  public fn GetStyleToolWindow = (
    this.styleToolWindow
  ),

  /*-
  ダイアログが表示されているかどうかを取得する。
  @returns <BooleanClass>
  */
  public fn IsDisplayed = (
    not this.isDialogDestroyed and this.inDialog this.rolloutDef
  ),

  /*-
  コンフィグから値を読み込む。
  @param config <Struct:ConfigStruct>
  @returns <BooleanClass> 読み込みに成功した場合は`true`、失敗した場合は`false`。
  */
  public fn Load config = (
    local isSuccessful = false
    if this.isValidConfig config do (
      local table = config.GetValue (this.generateConfigKey())
      if classOf table == Dictionary do (
        if hasDictValue table #InitPosition do this.initPosition = table[#InitPosition]
        if hasDictValue table #InitSize do this.initSize = table[#InitSize]
        if hasDictValue table #LockHeight do this.lockHeight = table[#LockHeight]
        if hasDictValue table #LockWidth do this.lockWidth = table[#LockWidth]
        if hasDictValue table #Modal do this.modal = table[#Modal]
        if hasDictValue table #StyleBorder do this.styleBorder = table[#StyleBorder]
        if hasDictValue table #StyleMaximizeBox do this.styleMaximizeBox = table[#StyleMaximizeBox]
        if hasDictValue table #StyleMinimizeBox do this.styleMinimizeBox = table[#StyleMinimizeBox]
        if hasDictValue table #StyleResizing do this.styleResizing = table[#StyleResizing]
        if hasDictValue table #StyleSunkenedge do this.styleSunkenedge = table[#StyleSunkenedge]
        if hasDictValue table #StyleSysmenu do this.styleSysmenu = table[#StyleSysmenu]
        if hasDictValue table #StyleTitleBar do this.styleTitleBar = table[#StyleTitleBar]
        if hasDictValue table #StyleToolWindow do this.styleToolWindow = table[#StyleToolWindow]
        isSuccessful = true
      )
    )
    isSuccessful
  ),

  /*-
  `Destroy`メソッド以外の方法でダイアログを閉じる場合に`#DialogDestroyed`の通知を発行する。
  @returns <OkClass>
  @remarks `Close`イベント等、実際にダイアログが閉じていなくても閉じたことにしてその旨を通知したい場所で呼び出す。
  */
  public fn RaiseDialogDestroyed = (
    this.isDialogDestroyed = true
    this.StateChanged.Notify #IsDisplayed (this.IsDisplayed())
    this.StateChanged.Notify #DialogDestroyed undefined
    ok
  ),

  /*-
  コンフィグに値を書き込む。
  @param config <Struct:ConfigStruct>
  @returns <BooleanClass> 書き出しに成功した場合は`true`、失敗した場合は`false`。
  */
  public fn Save config = (
    local isSuccessful = false
    if this.isValidConfig config do (
      local table = Dictionary #Name
      table[#InitPosition] = this.initPosition
      table[#InitSize] = this.initSize
      table[#LockHeight] = this.lockHeight
      table[#LockWidth] = this.lockWidth
      table[#Modal] = this.modal
      table[#StyleBorder] = this.styleBorder
      table[#StyleMaximizeBox] = this.styleMaximizeBox
      table[#StyleMinimizeBox] = this.styleMinimizeBox
      table[#StyleResizing] = this.styleResizing
      table[#StyleSunkenedge] = this.styleSunkenedge
      table[#StyleSysmenu] = this.styleSysmenu
      table[#StyleTitleBar] = this.styleTitleBar
      table[#StyleToolWindow] = this.styleToolWindow
      config.AddValue (this.generateConfigKey()) table
      isSuccessful = true
    )
    isSuccessful
  ),

  /*-
  ダイアログの初期位置を設定する。
  @param input <Point2|UndefinedClass>
  @returns <Point2|UndefinedClass>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetInitPosition input = (
    if classOf input == Point2 or classOf input == UndefinedClass do (
      this.initPosition = input
      this.StateChanged.Notify #InitPosition this.initPosition
    )
    this.GetInitPosition()
  ),

  /*-
  ダイアログの初期サイズを設定する。
  @param input <Point2>
  @returns <Point2>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetInitSize input = (
    if classOf input == Point2 do (
      this.initSize = input
      this.StateChanged.Notify #InitSize this.initSize
    )
    this.GetInitSize()
  ),

  /*-
  高さを固定するかどうかを設定する。
  @param input <BooleanClass>
  @returns <BooleanClass>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetLockHeight input = (
    if classOf input == BooleanClass do (
      this.lockHeight = input
      this.StateChanged.Notify #LockHeight this.lockHeight
    )
    this.GetLockHeight()
  ),

  /*-
  幅を固定するかどうかを設定する。
  @param input <BooleanClass>
  @returns <BooleanClass>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetLockWidth input = (
    if classOf input == BooleanClass do (
      this.lockWidth = input
      this.StateChanged.Notify #LockWidth this.lockWidth
    )
    this.GetLockWidth()
  ),

  /*-
  タイトルバーに表示されるメニュー定義を設定する。
  @param def <RCMenu|UndefinedClass>
  @returns <RCMenu|UndefinedClass>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetMenuDef def = (
    if this.isValidMenuDef def or classOf def == UndefinedClass do (
      this.menuDef = def
      this.StateChanged.Notify #MenuDef this.menuDef
    )
    this.GetMenuDef()
  ),

  /*-
  モーダルダイアログにするかどうかを設定する。
  @param input <BooleanClass>
  @returns <BooleanClass>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetModal input = (
    if classOf input == BooleanClass do (
      this.modal = input
      this.StateChanged.Notify #Modal this.modal
    )
    this.GetModal()
  ),

  /*-
  ダイアログの現在の位置を設定する。
  @param input <Point2>
  @returns <Point2>
  @remarks 内部状態は変更しない。
  無効な値の場合は何もしない。
  */
  public fn SetPosition input = (
    if classOf input == Point2 and this.inDialog this.rolloutDef do (
      setDialogPos this.rolloutDef input
      this.StateChanged.Notify #PositionChanged undefined
    )
    this.GetPosition()
  ),

  /*-
  ロールアウト定義を設定する。
  @param def <RolloutClass>
  @returns <RolloutClass>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetRolloutDef def = (
    if this.isValidRolloutDef def do (
      this.rolloutDef = def
      this.StateChanged.Notify #RolloutDef this.rolloutDef
    )
    this.GetRolloutDef()
  ),

  /*-
  ダイアログの現在のサイズを設定する。
  @param input <Point2>
  @returns <Point2>
  @remarks 内部状態は変更しない。
  無効な値の場合は何もしない。
  */
  public fn SetSize input = (
    if classOf input == Point2 and this.inDialog this.rolloutDef do (
      setDialogSize this.rolloutDef input
      this.StateChanged.Notify #SizeChanged undefined
    )
    this.GetSize()
  ),

  /*-
  二重境界線を持つかどうかを設定する。
  @param input <BooleanClass>
  @returns <BooleanClass>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetStyleBorder input = (
    if classOf input == BooleanClass do (
      this.styleBorder = input
      this.StateChanged.Notify #StyleBorder this.styleBorder
    )
    this.GetStyleBorder()
  ),

  /*-
  最大化ボタンを持つかどうかを設定する。
  @param input <BooleanClass>
  @returns <BooleanClass>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetStyleMaximizeBox input = (
    if classOf input == BooleanClass do (
      this.styleMaximizeBox = input
      this.StateChanged.Notify #StyleMaximizeBox this.styleMaximizeBox
    )
    this.GetStyleMaximizeBox()
  ),

  /*-
  最小化ボタンを持つかどうかを設定する。
  @param input <BooleanClass>
  @returns <BooleanClass>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetStyleMinimizeBox input = (
    if classOf input == BooleanClass do (
      this.styleMinimizeBox = input
      this.StateChanged.Notify #StyleMinimizeBox this.styleMinimizeBox
    )
    this.GetStyleMinimizeBox()
  ),

  /*-
  サイズ変更可能かどうかを設定する。
  @param input <BooleanClass>
  @returns <BooleanClass>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetStyleResizing input = (
    if classOf input == BooleanClass do (
      this.styleResizing = input
      this.StateChanged.Notify #StyleResizing this.styleResizing
    )
    this.GetStyleResizing()
  ),

  /*-
  境界線の内側をくぼませるかどうかを設定する。
  @param input <BooleanClass>
  @returns <BooleanClass>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetStyleSunkenedge input = (
    if classOf input == BooleanClass do (
      this.styleSunkenedge = input
      this.StateChanged.Notify #StyleSunkenedge this.styleSunkenedge
    )
    this.GetStyleSunkenedge()
  ),

  /*-
  タイトルバーに各種ボタンが表示されるかどうかを設定する。
  @param input <BooleanClass>
  @returns <BooleanClass>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetStyleSysmenu input = (
    if classOf input == BooleanClass do (
      this.styleSysmenu = input
      this.StateChanged.Notify #StyleSysmenu this.styleSysmenu
    )
    this.GetStyleSysmenu()
  ),

  /*-
  タイトルバーを持つかどうかを設定する。
  @param input <BooleanClass>
  @returns <BooleanClass>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetStyleTitleBar input = (
    if classOf input == BooleanClass do (
      this.styleTitleBar = input
      this.StateChanged.Notify #StyleTitleBar this.styleTitleBar
    )
    this.GetStyleTitleBar()
  ),

  /*-
  ツールウィンドウにするかどうかを設定する。
  @param input <BooleanClass>
  @returns <BooleanClass>
  @remarks 無効な値の場合は何もしない。
  */
  public fn SetStyleToolWindow input = (
    if classOf input == BooleanClass do (
      this.styleToolWindow = input
      this.StateChanged.Notify #StyleToolWindow this.styleToolWindow
    )
    this.GetStyleToolWindow()
  ),

  /*-
  コンフィグ用のキーを生成する。
  @returns <Name>
  */
  private fn generateConfigKey = (
    local rolloutKey = ""
    if this.isValidRolloutDef this.rolloutDef do (
      rolloutKey = this.rolloutDef.Name as String + "."
    )
    (rolloutKey + "Dialog") as Name
  ),

  /*-
  プロパティの状態に基づいてスタイルフラグの配列を生成する。
  @returns <Array[<Name>]>
  */
  private fn generateStyle = (
    local style = #()
    if this.styleBorder do append style #Style_Border
    if this.styleMaximizeBox do append style #Style_MaximizeBox
    if this.styleMinimizeBox do append style #Style_MinimizeBox
    if this.styleResizing do append style #Style_Resizing
    if this.styleSunkenedge do append style #Style_Sunkenedge
    if this.styleSysmenu do append style #Style_Sysmenu
    if this.styleTitleBar do append style #Style_TitleBar
    if this.styleToolWindow do append style #Style_ToolWindow
    style
  ),

  /*-
  @param obj <RolloutClass>
  @returns <BooleanClass>
  */
  private fn inDialog obj = (
    this.isValidRolloutDef obj and obj.InDialog
  ),

  /*-
  @param obj <Any>
  @returns <BooleanClass>
  */
  private fn isValidConfig obj = (
    isStruct obj \
        and isProperty obj #StructName \
        and classOf obj.StructName == MAXScriptFunction \
        and obj.StructName() == #ConfigStruct
  ),

  /*-
  @param obj <Any>
  @returns <BooleanClass>
  */
  private fn isValidMenuDef obj = (
    (classOf obj as String) as Name == #RCMenu
  ),

  /*-
  @param obj <Any>
  @returns <BooleanClass>
  */
  private fn isValidRolloutDef obj = (
    classOf obj == RolloutClass
  ),

  /*- @returns <Name> */
  public fn StructName = #DialogStruct,

  /*-
  @param indent: <String>
  @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
  @returns <OkClass>
  */
  public fn Dump indent:"" out:listener = (
    format "%DialogStruct\n" indent to:out
    format "%  initPosition:%\n" indent this.initPosition to:out
    format "%  initSize:%\n" indent this.initSize to:out
    format "%  isDialogDestroyed:%\n" indent this.isDialogDestroyed to:out
    format "%  menuDef:%\n" indent this.menuDef to:out
    format "%  rolloutDef:%\n" indent this.rolloutDef to:out
    format "%  styleBorder:%\n" indent this.styleBorder to:out
    format "%  styleMaximizeBox:%\n" indent this.styleMaximizeBox to:out
    format "%  styleMinimizeBox:%\n" indent this.styleMinimizeBox to:out
    format "%  styleResizing:%\n" indent this.styleResizing to:out
    format "%  styleSunkenedge:%\n" indent this.styleSunkenedge to:out
    format "%  styleSysmenu:%\n" indent this.styleSysmenu to:out
    format "%  styleTitleBar:%\n" indent this.styleTitleBar to:out
    format "%  styleToolWindow:%\n" indent this.styleToolWindow to:out
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

  /*- @prop <Struct:ObservableStruct> */
  public StateChanged,

  on Create do (
    this.StateChanged = (::standardDefinitionPool[@"Observable.ms"])()
    this.SetRolloutDef this._CP1_
    this.SetInitSize this._CP2_
    this.SetInitPosition this._CP3_
    this.SetMenuDef this._CP4_
  )
)
