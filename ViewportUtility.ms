/*! © 2021 imaoki | MIT License | https://github.com/imaoki */
/*-
ビューポート用の追加メソッドを提供する。
*/
struct ViewportUtilityStruct (
  /*
  public fn GetDistancePerPixel = (),
  public fn PixelDistance v1 v2 = (),
  */

  /*-
  アクティブビューポートのスクリーン座標系における1ピクセル辺りのワールド距離を取得する。
  @returns <Float>
  @remarks スケール係数がビューの縦サイズと一致する時、ワールド距離の`1.0`は`1`ピクセルになる。
  */
  public fn GetDistancePerPixel = (
    1.0 / ((getViewSize()).Y / (getScreenScaleFactor [0, 0, 0]))
  ),

  /*-
  ワールド座標系の2ベクトル間の距離からスクリーン座標系におけるピクセル距離を算出する。
  @param v1 <Point3>
  @param v2 <Point3>
  @returns <Float>
  */
  public fn PixelDistance v1 v2 = (
    local result = 0.0
    if classOf v1 == Point3 and classOf v2 == Point3 do (
      local viewTM = getViewTM()
      local p1 = v1 * viewTM * [1, 1, 0]
      local p2 = v2 * viewTM * [1, 1, 0]
      local worldDist = distance p1 p2
      result = worldDist / this.GetDistancePerPixel()
    )
    result
  ),

  /*- @returns <Name> */
  public fn StructName = #ViewportUtilityStruct,

  /*-
  @param indent: <String>
  @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
  @returns <OkClass>
  */
  public fn Dump indent:"" out:listener = (
    format "%ViewportUtilityStruct\n" indent to:out
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
