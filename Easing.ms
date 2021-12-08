/*! © 2021 imaoki | MIT License | https://github.com/imaoki */
/*-
各種イージングメソッドを提供する。
*/
struct EasingStruct (
  /*-
  逆方向の変化を伴う。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @returns <Float>
  */
  public fn BackIn v = (
    v = this.clamp v
    v ^ 3 - v * sin (v * radToDeg ::pi)
  ),

  /*-
  逆方向の変化を伴う。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @returns <Float>
  */
  public fn BackInOut v = (
    v = this.clamp v
    if v < 0.5 then (
      local f = 2.0 * v
      0.5 * (f ^ 3 - f * sin (f * radToDeg ::pi))
    )
    else (
      local f = 1.0 - (2.0 * v - 1.0)
      0.5 * (1.0 - (f ^ 3 - f * sin (f * radToDeg ::pi))) + 0.5
    )
  ),

  /*-
  逆方向の変化を伴う。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @returns <Float>
  */
  public fn BackOut v = (
    v = this.clamp v
    local f = 1.0 - v
    1.0 - (f ^ 3 - f * sin (f * radToDeg ::pi))
  ),

  /*-
  ベジェ曲線を使用する。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @param tangent1 <Point2|Point3> 始点のアウトタンジェント。`0.0`から`1.0`の範囲の値。
  @param tangent2 <Point2|Point3> 終点のインタンジェント。`0.0`から`1.0`の範囲の値。
  @param start: <Float> 始点の値。`0.0`から`1.0`の範囲の値。既定値は`0.0`。
  @param end: <Float> 終点の値。`0.0`から`1.0`の範囲の値。既定値は`1.0`。
  @returns <Float>
  @remarks 参考
  :   [math \- Interpolating values between interval, interpolation as per Bezier curve \- Stack Overflow](https://stackoverflow.com/questions/5883264/interpolating-values-between-interval-interpolation-as-per-bezier-curve)
  */
  public fn Bezier v tangent1 tangent2 start:0.0 end:1.0 = (
    v = this.clamp v
    local p1 = this.clamp [0.0, start]
    local p2 = this.clamp [tangent1.X, tangent1.Y]
    local p3 = this.clamp [tangent2.X, tangent2.Y]
    local p4 = this.clamp [1.0, end]

    local t = 0.0
    if v <= p1.X then (
      t = 0.0
    )
    else (
      if p4.X <= v then (
        t = 1.0
      )
      else (
        local a = -p1.X + 3.0 * p2.X - 3.0 * p3.X + p4.X
        local b = 3.0 * p1.X - 6.0 * p2.X + 3.0 * p3.X
        local c = -3.0 * p1.X + 3.0 * p2.X
        local d = p1.X - v
        t = this.solveCubicEquation a b c d
      )
    )
    (1.0 - t) ^ 3 * p1.Y + 3.0 * (1.0 - t) ^ 2 * t * p2.Y + 3.0 * (1.0 - t) * t ^ 2 * p3.Y + t ^ 3 * p4.Y
  ),

  /*-
  バウンス効果を作成する。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @returns <Float>
  */
  public fn BounceIn v = (
    v = 1.0 - (this.clamp v)
    if v < 4.0 / 11.0 then (
      1.0 - ((121.0 * v ^ 2) / 16.0)
    )
    else (
      if v < 8.0 / 11.0 then (
        1.0 - ((363/40.0 * v ^ 2) - (99/10.0 * v) + 17.0 / 5.0)
      )
      else (
        if v < 9.0 / 10.0 then (
          1.0 - ((4356.0 / 361.0 * v ^ 2) - (35442.0 / 1805.0 * v) + 16061.0 / 1805.0)
        )
        else (
          1.0 - ((54.0 / 5.0 * v ^ 2) - (513.0 / 25.0 * v) + 268.0 / 25.0)
        )
      )
    )
  ),

  /*-
  バウンス効果を作成する。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @returns <Float>
  */
  public fn BounceInOut v = (
    v = this.clamp v
    if v < 0.5 then (
      v = 1.0 - v * 2.0
      if v < 4.0 / 11.0 then (
        0.5 * (1.0 - ((121.0 * v ^ 2) / 16.0))
      )
      else (
        if v < 8.0 / 11.0 then (
          0.5 * (1.0 - ((363/40.0 * v ^ 2) - (99/10.0 * v) + 17.0 / 5.0))
        )
        else (
          if v < 9.0 / 10.0 then (
            0.5 * (1.0 - ((4356.0 / 361.0 * v ^ 2) - (35442.0 / 1805.0 * v) + 16061.0 / 1805.0))
          )
          else (
            0.5 * (1.0 - ((54.0 / 5.0 * v ^ 2) - (513.0 / 25.0 * v) + 268.0 / 25.0))
          )
        )
      )
    )
    else (
      v = v * 2.0 - 1.0
      if v < 4.0 / 11.0 then (
        0.5 * ((121.0 * v ^ 2) / 16.0) + 0.5
      )
      else (
        if v < 8.0 / 11.0 then (
          0.5 * ((363/40.0 * v ^ 2) - (99/10.0 * v) + 17.0 / 5.0) + 0.5
        )
        else (
          if v < 9.0 / 10.0 then (
            0.5 * ((4356.0 / 361.0 * v ^ 2) - (35442.0 / 1805.0 * v) + 16061.0 / 1805.0) + 0.5
          )
          else (
            0.5 * ((54.0 / 5.0 * v ^ 2) - (513.0 / 25.0 * v) + 268.0 / 25.0) + 0.5
          )
        )
      )
    )
  ),

  /*-
  バウンス効果を作成する。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @returns <Float>
  */
  public fn BounceOut v = (
    v = this.clamp v
    if v < 4.0 / 11.0 then (
      (121.0 * v ^ 2) / 16.0
    )
    else (
      if v < 8.0 / 11.0 then (
        (363/40.0 * v ^ 2) - (99/10.0 * v) + 17.0 / 5.0
      )
      else (
        if v < 9.0 / 10.0 then (
          (4356.0 / 361.0 * v ^ 2) - (35442.0 / 1805.0 * v) + 16061.0 / 1805.0
        )
        else (
          (54.0 / 5.0 * v ^ 2) - (513.0 / 25.0 * v) + 268.0 / 25.0
        )
      )
    )
  ),

  /*-
  円弧上に変化する。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @returns <Float>
  */
  public fn CircularIn v = (
    v = this.clamp v
    1.0 - sqrt (1.0 - v ^ 2)
  ),

  /*-
  円弧上に変化する。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @returns <Float>
  */
  public fn CircularInOut v = (
    v = this.clamp v
    if v < 0.5 then (
      0.5 * (1.0 - sqrt (1.0 - 4.0 * (v ^ 2)))
    )
    else (
      0.5 * (sqrt (-(2.0 * v - 3.0) * (2.0 * v - 1.0)) + 1.0)
    )
  ),

  /*-
  円弧上に変化する。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @returns <Float>
  */
  public fn CircularOut v = (
    v = this.clamp v
    sqrt ((2.0 - v) * v)
  ),

  /*-
  三次関数を使用する。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @returns <Float>
  */
  public fn CubicIn v = (
    v = this.clamp v
    v ^ 3
  ),

  /*-
  三次関数を使用する。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @returns <Float>
  */
  public fn CubicInOut v = (
    v = this.clamp v
    if v < 0.5 then (
      4.0 * (v ^ 3)
    )
    else (
      4.0 * ((v - 1.0) ^ 3) + 1.0
    )
  ),

  /*-
  三次関数を使用する。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @returns <Float>
  */
  public fn CubicOut v = (
    v = this.clamp v
    (v - 1.0) ^ 3 + 1.0
  ),

  /*-
  弾性効果を作成する。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @param frequency: <Integer> 振動数。`0`から`100`の範囲の値。既定値は`3`。
  @param damping: <Float> 減衰。`0.0`から`100.0`の範囲の値。既定値は`10.0`。
  @param flat: <BooleanClass> 始点と終点を`1.0`にする場合は`true`、始点を`0.0`、終点を`1.0`にする場合は`false`。既定値は`false`。
  @returns <Float>
  */
  public fn ElasticIn v frequency:3 damping:10.0 flat:false = (
    v = this.clamp v
    frequency = this.clamp frequency lower:0 high:100
    damping = this.clamp damping lower:0.0 high:100.0
    local f = frequency as Float * 2.0 + (if flat then 0.0 else 0.5)
    local s = sin (f * radToDeg ::pi * v)
    local d = 2.0 ^ (damping * (v - 1.0))
    s * d + (if flat then 1.0 else 0.0)
  ),

  /*-
  弾性効果を作成する。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @param frequency: <Integer> 振動数。`0`から`100`の範囲の値。既定値は`3`。
  @param damping: <Float> 減衰。`0.0`から`100.0`の範囲の値。既定値は`10.0`。
  @param flat: <BooleanClass> 始点と終点を`1.0`にする場合は`true`、始点を`0.0`、終点を`1.0`にする場合は`false`。既定値は`false`。
  @returns <Float>
  */
  public fn ElasticInOut v frequency:3 damping:10.0 flat:false = (
    v = this.clamp v
    frequency = this.clamp frequency lower:0 high:100
    damping = this.clamp damping lower:0.0 high:100.0
    local f = frequency as Float * 2.0 + (if flat then 0.0 else 0.5)
    if v < 0.5 then (
      local s = sin (f * radToDeg ::pi * (v * 2.0))
      local d = 2.0 ^ (damping * (v * 2.0 - 1.0))
      s * d * 0.5 + (if flat then 1.0 else 0.0)
    )
    else (
      local s = sin (-f * (if flat then -1 else 1) * radToDeg ::pi * (v * 2.0 + (if flat then 1.0 else 0.0)))
      local d = 2.0 ^ (-damping * (v * 2.0 - 1.0))
      s * d * 0.5 + 1.0
    )
  ),

  /*-
  弾性効果を作成する。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @param frequency: <Integer> 振動数。`0`から`100`の範囲の値。既定値は`3`。
  @param damping: <Float> 減衰。`0.0`から`100.0`の範囲の値。既定値は`10.0`。
  @param flat: <BooleanClass> 始点と終点を`1.0`にする場合は`true`、始点を`0.0`、終点を`1.0`にする場合は`false`。既定値は`false`。
  @returns <Float>
  */
  public fn ElasticOut v frequency:3 damping:10.0 flat:false = (
    v = this.clamp v
    frequency = this.clamp frequency lower:0 high:100
    damping = this.clamp damping lower:0.0 high:100.0
    local f = frequency as Float * 2.0 + (if flat then 0.0 else 0.5)
    local s = sin (-f * (if flat then -1 else 1) * radToDeg ::pi * (v + 1.0))
    local d = 2.0 ^ (-damping * v)
    s * d + 1.0
  ),

  /*-
  指数関数を使用する。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @returns <Float>
  */
  public fn ExponentialIn v = (
    v = this.clamp v
    case v of (
      (0.0): v
      (1.0): v
      default: 2.0 ^ (10.0 * (v - 1.0))
    )
  ),

  /*-
  指数関数を使用する。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @returns <Float>
  */
  public fn ExponentialInOut v = (
    v = this.clamp v
    case v of (
      (0.0): v
      (1.0): v
      default: (
        if v < 0.5 then (
          2.0 ^ (10.0 * (2.0 * v - 1.0) - 1.0)
        )
        else (
          1.0 - (2.0 ^ (-10.0 * (2.0 * v - 1.0) - 1.0))
        )
      )
    )
  ),

  /*-
  指数関数を使用する。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @returns <Float>
  */
  public fn ExponentialOut v = (
    v = this.clamp v
    case v of (
      (0.0): v
      (1.0): v
      default: -(2.0 ^ (-10.0 * v)) + 1.0
    )
  ),

  /*-
  線形補間。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @returns <Float>
  */
  public fn Linear v = (
    this.clamp v
  ),

  /*-
  二次関数を使用する。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @returns <Float>
  */
  public fn QuadraticIn v = (
    v = this.clamp v
    v ^ 2
  ),

  /*-
  二次関数を使用する。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @returns <Float>
  */
  public fn QuadraticInOut v = (
    v = this.clamp v
    if v < 0.5 then (
      2.0 * (v ^ 2)
    )
    else (
      1.0 - 2.0 * ((v - 1.0) ^ 2)
    )
  ),

  /*-
  二次関数を使用する。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @returns <Float>
  */
  public fn QuadraticOut v = (
    v = this.clamp v
    -v * (v - 2.0)
  ),

  /*-
  四次関数を使用する。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @returns <Float>
  */
  public fn QuarticIn v = (
    v = this.clamp v
    v ^ 4
  ),

  /*-
  四次関数を使用する。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @returns <Float>
  */
  public fn QuarticInOut v = (
    v = this.clamp v
    if v < 0.5 then (
      8.0 * (v ^ 4)
    )
    else (
      1.0 - 8.0 * ((v - 1.0) ^ 4)
    )
  ),

  /*-
  四次関数を使用する。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @returns <Float>
  */
  public fn QuarticOut v = (
    v = this.clamp v
    1.0 - (v - 1.0) ^ 4
  ),

  /*-
  五次関数を使用する。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @returns <Float>
  */
  public fn QuinticIn v = (
    v = this.clamp v
    v ^ 5
  ),

  /*-
  五次関数を使用する。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @returns <Float>
  */
  public fn QuinticInOut v = (
    v = this.clamp v
    if v < 0.5 then (
      16.0 * (v ^ 5)
    )
    else (
      16.0 * ((v - 1.0) ^ 5) + 1.0
    )
  ),

  /*-
  五次関数を使用する。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @returns <Float>
  */
  public fn QuinticOut v = (
    v = this.clamp v
    (v - 1.0) ^ 5 + 1.0
  ),

  /*-
  シグモイド関数を使用する。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @param inflection <Float> 変曲点。`-0.5`から`0.5`の範囲の値。
  @param slope <Float> 傾き。`-0.5`から`0.5`の範囲の値。
  @returns <Float>
  */
  public fn Sigmoid v inflection slope = (
    v = this.clamp v
    inflection = 0.5 + this.clamp inflection lower:-0.5 high:0.5
    slope = 0.5 + this.clamp slope lower:-0.5 high:0.5
    local c = (2.0 / (1.0 - slope * 0.8)) - 1.0
    if v <= inflection then (
      if inflection == 0 then 0.0 else (v ^ c) / (inflection ^ (c - 1.0))
    )
    else (
      (1.0 - ((1.0 - v) ^ c) / ((1.0 - inflection) ^ (c - 1.0)))
    )
  ),

  /*-
  サイン関数を使用する。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @returns <Float>
  */
  public fn SineIn v = (
    v = this.clamp v
    sin ((v - 1.0) * radToDeg ::pi / 2.0) + 1.0
  ),

  /*-
  サイン関数を使用する。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @returns <Float>
  */
  public fn SineInOut v = (
    v = this.clamp v
    0.5 * (1.0 - cos (v * radTodeg ::pi))
  ),

  /*-
  サイン関数を使用する。
  @param v <Float> `0.0`から`1.0`の範囲の値。
  @returns <Float>
  */
  public fn SineOut v = (
    v = this.clamp v
    sin (v * radToDeg ::pi / 2.0)
  ),

  /*-
  値を範囲内に収める。
  @param input <Integer|Float|Point2>
  @param lower: <Float> 下限。既定値は`0.0`。
  @param high: <Float> 上限。既定値は`1.0`。
  @returns <Integer|Float|Point2>
  */
  private fn clamp input lower:0.0 high:1.0 = (
    case classOf input of (
      (Integer): (
        lower = lower as Integer
        high = high as Integer
        if input < lower do input = lower
        if input > high do input = high
        input
      )
      (Float): (
        if input < lower do input = lower
        if input > high do input = high
        input
      )
      (Point2): (
        if input.X < lower do input.X = lower
        if input.Y < lower do input.Y = lower
        if input.X > high do input.X = high
        if input.Y > high do input.Y = high
        input
      )
      default: input
    )
  ),

  /*-
  @param v <Float>
  @returns <BooleanClass>
  */
  private fn isNormalized v = (
    0.0 <= v and v <= 1.0
  ),

  /*-
  三次方程式を解決する。
  @param a <Float>
  @param b <Float>
  @param c <Float>
  @param d <Float>
  @returns <Float>
  @remarks 参考
  :   [math \- Interpolating values between interval, interpolation as per Bezier curve \- Stack Overflow](https://stackoverflow.com/questions/5883264/interpolating-values-between-interval-interpolation-as-per-bezier-curve)
  */
  private fn solveCubicEquation a b c d = (
    local result = 0.0
    if a == 0.0 then (
      result = this.solveQuadraticEquation b c d
    )
    else (
      if d != 0.0 do (
        b /= a
        c /= a
        d /= a

        local q = (3.0 * c - b ^ 2) / 9.0
        local r = (-27.0 * d + b * (9.0 * c - 2.0 * (b ^ 2))) / 54.0
        local discriminant = q ^ 3 + r ^ 2
        local term1 = b / 3.0

        if discriminant > 0.0 then (
          local s = r + sqrt discriminant
          s = if s < 0.0 then -(-s ^ (1.0 / 3.0)) else s ^ (1.0 / 3.0)

          local t = r - sqrt discriminant
          t = if t < 0.0 then -(-t ^ (1.0 / 3.0)) else t ^ (1.0 / 3.0)

          local x = -term1 + s + t
          if this.isNormalized result do (
            result = x
          )
        )
        else (
          if discriminant == 0.0 then (
            local r13 = if r < 0.0 then -(-r ^ (1.0 / 3.0)) else r ^ (1.0 / 3.0)
            local x1 = -term1 + 2.0 * r13
            local x2 = -(r13 + term1)

            if this.isNormalized x1 then (
              result = x1
            )
            else (
              if this.isNormalized x2 do (
                result = x2
              )
            )
          )
          else (
            q = -q
            local dum1 = q ^ 3
            dum1 = acos (r / sqrt dum1)

            local r13 = 2.0 * sqrt q
            local x1 = -term1 + r13 * cos (dum1 / 3.0)
            local x2 = -term1 + r13 * cos ((dum1 + 2.0 * radToDeg PI) / 3.0)
            local x3 = -term1 + r13 * cos ((dum1 + 4.0 * radToDeg PI) / 3.0)

            if this.isNormalized x1 then (
              result = x1
            )
            else (
              if this.isNormalized x2 then (
                result = x2
              )
              else (
                if this.isNormalized x3 do (
                  result = x3
                )
              )
            )
          )
        )
      )
    )
    result
  ),

  /*-
  二次方程式を解決する。
  @param a <Float>
  @param b <Float>
  @param c <Float>
  @returns <Float>
  @remarks 参考
  :   [math \- Interpolating values between interval, interpolation as per Bezier curve \- Stack Overflow](https://stackoverflow.com/questions/5883264/interpolating-values-between-interval-interpolation-as-per-bezier-curve)
  */
  private fn solveQuadraticEquation a b c = (
    local result = 0.0
    local x1 = (-b + sqrt (b ^ 2 - 4.0 * a * c)) / 2.0 * a
    local x2 = (-b - sqrt (b ^ 2 - 4.0 * a * c)) / 2.0 * a
    if this.isNormalized x1 then (
      result = x1
    )
    else (
      if this.isNormalized x2 do (
        result = x2
      )
    )
    result
  ),

  /*- @returns <Name> */
  public fn StructName = #EasingStruct,

  /*-
  @param indent: <String>
  @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
  @returns <OkClass>
  */
  public fn Dump indent:"" out:listener = (
    format "%EasingStruct\n" indent to:out
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
