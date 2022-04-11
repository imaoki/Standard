/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
/*-
文字列操作を行うためのメソッドを提供する。
*/
struct StringUtilityStruct (
  /*- @prop <DotNetClass:System.Text.RegularExpressions.Regex> */
  private regexClass = DotNetClass "System.Text.RegularExpressions.Regex",
  /*- @prop <Struct:EnumStruct> `"System.Text.RegularExpressions.RegexOptions"`列挙型。 */
  private regexOptionsEnum,
  /*- @prop <DotNetClass:System.String> */
  private stringClass = DotNetClass "System.String",
  /*- @prop <Struct:EnumStruct> `"System.StringSplitOptions"`列挙型。 */
  private stringSplitOptionsEnum,

  /*- @prop <DotNetObject:System.Text.RegularExpressions.Regex> `\\\\`に一致する正規表現オブジェクト。 */
  private backslashRegex,
  /*- @prop <DotNetObject:System.Text.RegularExpressions.Regex> `(?<=\b)\w|(?<=[a-z])[A-Z]|(?<=[0-9_])[a-z]`に一致する正規表現オブジェクト。 */
  private camelRegex,
  /*- @prop <DotNetObject:System.Text.RegularExpressions.Regex> `\s*,\s*`に一致する正規表現オブジェクト。 */
  private commaRegex,
  /*- @prop <DotNetObject:System.Text.RegularExpressions.Regex> `\r`に一致する正規表現オブジェクト。 */
  private crRegex,
  /*- @prop <Struct:DotNetUtilityStruct> */
  private dotNetUtility,
  /*- @prop <DotNetObject:System.Text.RegularExpressions.Regex> `\\\"`に一致する正規表現オブジェクト。 */
  private doubleQuoteRegex,
  /*- @prop <StructDef:EnumStruct> */
  private enumDef,
  /*- @prop <DotNetObject:System.Text.RegularExpressions.Regex> `(?<!\\\\)%`に一致する正規表現オブジェクト。 */
  private formatRegex,
  /*- @prop <DotNetObject:System.Text.RegularExpressions.Regex> `\n`に一致する正規表現オブジェクト。 */
  private lfRegex,
  /*- @prop <DotNetObject:System.Text.RegularExpressions.Regex> `\W`に一致する正規表現オブジェクト。 */
  private nonWordRegex,
  /*- @prop <DotNetObject:System.Text.RegularExpressions.Regex> `\\\\%`に一致する正規表現オブジェクト。 */
  private percentRegex,
  /*- @prop <DotNetObject:System.Text.RegularExpressions.Regex> `\t`に一致する正規表現オブジェクト。 */
  private tabRegex,

  /*
  public fn ClipString input digit:40 = (),
  public fn CreateRegex pattern options:#(#IgnoreCase, #Singleline) = (),
  public fn EscapeBackslash input = (),
  public fn EscapeWhiteSpace input = (),
  public fn FormatString input values = (),
  public fn FromCodePoint codePoints = (),
  public fn GetRegexOptions obj asStringArray:false = (),
  public fn GetRegexPattern obj = (),
  public fn GetUnicodeCodePointFromSurrogatePair highSurrogate lowSurrogate = (),
  public fn GetValidUnicodeCodePoint codePoint = (),
  public fn IsRegexObject obj = (),
  public fn Join input separator:"" = (),
  public fn PadLeft input width char = (),
  public fn PadRight input width char = (),
  public fn Serialize input = (),
  public fn Split input separator removeEmpty:true = (),
  public fn SplitByLF input = (),
  public fn ToCharArray input = (),
  public fn ToPascalCase input = (),
  public fn Trim input = (),
  public fn TrimEnd input chars = (),
  public fn TrimStart input chars = (),
  */

  /*-
  入力文字列を指定の桁数に収まるよう省略する。
  @param input <String>
  @param digit: <Integer> 桁数。既定値は`40`。
  @returns <String>
  */
  public fn ClipString input digit:40 = (
    local result = copy input
    if input.Count > digit do (
      result = substring result 1 (digit - 3) + "..."
    )
    result
  ),

  /*-
  正規表現オブジェクトを作成する。
  @param pattern <String> 正規表現パターン文字列。
  @param options: <Array[<Name>]> 正規表現のオプション。既定値は`#(#IgnoreCase, #Singleline)`。
  有効な値は次の通り。

  | 値                         | 効果                                                                                                                                                     |
  | -------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
  | `#Compiled`                | 正規表現をアセンブリにコンパイルする。                                                                                                                   |
  | `#CultureInvariant`        | 言語のカルチャの違いを無視する。                                                                                                                         |
  | `#ECMAScript`              | 式のECMAScript準拠の動作を有効にする。                                                                                                                   |
  | `#ExplicitCapture`         | 名前のないグループをキャプチャしない。`(?<name>subexpression)`という形式で、明示的に名前または番号が付加されたグループのみを有効なキャプチャ対象とする。 |
  | `#IgnoreCase`              | 大文字と小文字を区別しない一致を使用する。                                                                                                               |
  | `#IgnorePatternWhitespace` | エスケープされていない空白をパターンから除外し、シャープ記号`#`の後ろのコメントを有効にする。                                                            |
  | `#Multiline`               | 複数行モードを使用する。`^`と`$`は、(入力文字列の先頭および末尾ではなく)各行の先頭および末尾と一致する。                                                 |
  | `#None`                    | 既定の動作を使用する。                                                                                                                                   |
  | `#RightToLeft`             | 検索の方向を変更する。左から右ではなく、右から左に検索する。                                                                                             |
  | `#Singleline`              | 単一行モードを使用する。このモードでは、ピリオド`.`は任意の1文字と一致する(`\n`を除くすべての文字の代用)。                                               |

  詳細は[RegexOptions 列挙型](https://docs.microsoft.com/ja-jp/dotnet/api/system.text.regularexpressions.regexoptions?view=netframework-4.8)、および[正規表現のオプション](https://docs.microsoft.com/ja-jp/dotnet/standard/base-types/regular-expression-options)を参照。
  @returns <DotNetObject:System.Text.RegularExpressions.Regex>
  */
  public fn CreateRegex pattern options:#(#IgnoreCase, #Singleline) = (
    if options.Count == 0 do (
      options = #(#None)
    )
    local optionsObject = this.regexOptionsEnum.Create options
    DotNetObject this.regexClass pattern optionsObject
  ),

  /*-
  入力文字列中の`\`、`\%`、`\"`、`\n`、`\r`、および`\t`をエスケープ処理する。
  @param input <String>
  @returns <String>
  */
  public fn EscapeBackslash input = (
    this.tabRegex.Replace (
      this.crRegex.Replace (
        this.lfRegex.Replace (
          this.doubleQuoteRegex.Replace (
            this.backslashRegex.Replace input "\\\\"
          ) "\\\""
        ) "\\n"
      ) "\\r"
    ) "\\t"
  ),

  /*-
  入力文字列中の`\n`、`\r`、および`\t`をエスケープ処理する。
  @param input <String>
  @returns <String>
  */
  public fn EscapeWhiteSpace input = (
    this.tabRegex.Replace (
      this.crRegex.Replace (
        this.lfRegex.Replace input "\\n"
      ) "\\r"
    ) "\\t"
  ),

  /*-
  `format`関数のパラメータを配列で渡せるようにしたメソッド。
  @param input <String> フォーマット文字列。
  @param values <Array[<Any>]> フォーマット文字列中の`%`の数に対応した配列。
  @returns <String>
  */
  public fn FormatString input values = (
    local result = copy input
    local matches = this.formatRegex.Matches input
    if matches.Count == values.Count do (
      for i = values.Count to 1 by -1 do (
        local index = matches.Item[i - 1].Index + 1
        local replacement = case classOf values[i] of (
          (Name): this.ToPascalCase values[i]
          default: values[i] as String
        )
        result = replace result index 1 replacement
      )
      result = this.percentRegex.Replace result "%"
    )
    result
  ),

  /*-
  Unicodeコードポイントの配列を文字列に変換する。
  @param codePoints <Array[<Integer>]> 10進数、または16進数のコードポイント配列。
  @returns <String>
  @remarks `0x10000`以上は補助コードポイントとして処理する。
  */
  public fn FromCodePoint codePoints = (
    local result = ""
    for cp in codePoints where floor cp 0 == cp do (
      local validCodePoints = this.GetValidUnicodeCodePoint cp
      for vcp in validCodePoints do (
        result += Bit.IntAsChar vcp
      )
    )
    result
  ),

  /*-
  正規表現オブジェクトのオプションを配列として取得する。
  @param obj <DotNetObject:System.Text.RegularExpressions.Regex> 正規表現オブジェクト。
  @param asStringArray: <BooleanClass> 文字列配列として取得する場合は`true`、名前配列として取得する場合は`false`。既定値は`false`。
  @returns <Array[<Name>]|Array[<String>]>
  */
  public fn GetRegexOptions obj asStringArray:false = (
    local options = #()
    if this.IsRegexObject obj do (
      options = filterString (obj.Options.ToString()) ", "
      sort options
      if not asStringArray do (
        for i = 1 to options.Count do (
          options[i] = options[i] as Name
        )
      )
    )
    options
  ),

  /*-
  正規表現オブジェクトの正規表現パターン文字列を取得する。
  @param obj <DotNetObject:System.Text.RegularExpressions.Regex> 正規表現オブジェクト。
  @returns <String>
  */
  public fn GetRegexPattern obj = (
    local pattern = ""
    if this.IsRegexObject obj do (
      pattern = this.EscapeWhiteSpace (obj.ToString())
    )
    pattern
  ),

  /*-
  サロゲートペアからUnicodeコードポイントを取得する。
  @param highSurrogate <Integer> 上位サロゲートコードポイント。
  @param lowSurrogate <Integer> 下位サロゲートコードポイント。
  @returns <Integer> Unicodeコードポイント。
  */
  public fn GetUnicodeCodePointFromSurrogatePair highSurrogate lowSurrogate = (
    0x10000 + (Bit.Shift (highSurrogate - 0xD800) 10) + (lowSurrogate - 0xDC00)
  ),

  /*-
  Unicodeコードポイントから正しい文字に変換可能なUnicodeコードポイントの配列を取得する。
  @param codePoint <Integer> 10進数、または16進数の整数値。
  @returns <Array[<Integer>]> `codePoint`が`0x10000`以上の場合は1番目が上位サロゲートコードポイント、2番目が下位サロゲートコードポイントの配列、`0xFFFF`以下の場合は渡されたコードポイントのみの配列。
  */
  public fn GetValidUnicodeCodePoint codePoint = (
    if codePoint <= 0xFFFF then (
      #(codePoint)
    )
    else (
      codePoint -= 0x10000
      #(0xD800 + Bit.Shift codePoint -10, 0xDC00 + Bit.And codePoint 0x3FF)
    )
  ),

  /*-
  @param obj <DotNetObject:System.Text.RegularExpressions.Regex> 正規表現オブジェクト。
  @returns <BooleanClass>
  */
  public fn IsRegexObject obj = (
    this.dotNetUtility.IsInstanceOf "System.Text.RegularExpressions.Regex" obj
  ),

  /*-
  文字列配列の全ての要素を連結する。
  @param input <Array[<String>]> 文字列配列。
  @param separator: <String> 区切り文字。既定値は`""`。
  @returns <String>
  */
  public fn Join input separator:"" = (
    this.stringClass.Join separator input
  ),

  /*-
  文字列の左側に任意の文字を埋め込むことで現在の文字列を右寄せした新しい文字列を生成する。
  @param input <String>
  @param width <Integer> 生成される文字列の文字数。
  @param char <String> 埋め込み文字。二文字以上の文字列を指定した場合は一文字目を使用する。
  @returns <String>
  @remarks
  | `input` | `width` | `char` | 結果           |
  | ------- | ------- | ------ | -------------- |
  | `"foo"` | `10`    | `-`    | `"-------foo"` |
  */
  public fn PadLeft input width char = (
    (DotNetObject this.stringClass input).PadLeft width char
  ),

  /*-
  文字列の右側に任意の文字を埋め込むことで現在の文字列を左寄せした新しい文字列を生成する。
  @param input <String>
  @param width <Integer> 生成される文字列の文字数。
  @param char <String> 埋め込み文字。二文字以上の文字列を指定した場合は一文字目を使用する。
  @returns <String>
  @remarks
  | `input` | `width` | `char` | 結果           |
  | ------- | ------- | ------ | -------------- |
  | `"foo"` | `10`    | `-`    | `"foo-------"` |
  */
  public fn PadRight input width char = (
    (DotNetObject this.stringClass input).PadRight width char
  ),

  /*-
  値をシリアライズする。
  @param input <Any>
  @returns <String>
  */
  public fn Serialize input = (
    local result = ""
    case classOf input of (
      (Array): (
        result = "#("
        for i = 1 to input.Count do (
          if i > 1 do result += ", "
          result += this.Serialize input[i]
        )
        result += ")"
      )
      (BigMatrix): (
        local rows = input.Rows as Integer
        local cols = input.Columns as Integer
        result = "(local _ = BigMatrix " + rows as String + " " + cols as String
        for i = 1 to rows do (
          for j = 1 to cols do (
            result += ";_[" + i as String + "][" + j as String + "] = "
            result += this.Serialize input[i][j]
          )
        )
        result += ";_)"
      )
      (DataPair): (
        local propNames = getPropNames input
        local isExplicitPropNames = propNames.Count == 4
        local v1Value = this.Serialize input.V1
        local v2Value = this.Serialize input.V2
        if isExplicitPropNames do (
          local v1Name = this.TrimStart (this.ToPascalCase propNames[3]) "#"
          local v2Name = this.TrimStart (this.ToPascalCase propNames[4]) "#"
          v1Value = v1Name + ":" + v1Value
          v2Value = v2Name + ":" + v2Value
        )
        result = "(DataPair " + v1Value + " " + v2Value + ")"
      )
      (Dictionary): (
        result = "(Dictionary " + this.Serialize input.Type
        for key in input.Keys do (
          local keyText = this.Serialize key
          local valueText = this.Serialize input[key]
          result += " #(" + keyText + ", " + valueText + ")"
        )
        result += ")"
      )
      (Float): result += formattedPrint input format:"f"
      (String): result = "\"" + this.EscapeBackslash input + "\""
      (StringStream): (
        result = "(StringStream " + this.Serialize (input as String) + ")"
      )
      default : result = this.ToPascalCase input
    )
    if not (classOf input == Name or classOf input == String) \
        and this.commaRegex.IsMatch result do (
      result = this.commaRegex.Replace result ", "
    )
    result
  ),

  /*-
  文字列を部分文字列に分割する。
  @param input <String>
  @param separator <String|Array[<String>]>
  区切り文字として使用する文字列、もしくは文字列配列。
  文字列を指定した場合は文字一つ一つが区切り文字となる。
  @param removeEmpty: <BooleanClass> 空の配列要素を省略する場合は`true`、空の配列要素も含める場合は`false`。既定値は`true`。
  @returns <Array[<String>]>
  @remarks
  `removeEmpty`が`false`の時、一致する区切り文字が一つの場合は空要素が省略される。

  ```maxscript
  (
    format "%\n" ((::StringUtilityStruct()).Split "foo.bar.baz" ".a" removeEmpty:false)
    -- 結果
    #("foo", "b", "r", "b", "z")
  )
  ```

  一致する区切り文字が二つ以上連続する場合、空要素は省略されない。
  ただしこの場合もそれぞれの区切り文字が個別の空要素になるのではなく、一つの空要素にまとめられる。

  ```maxscript
  (
    format "%\n" ((::StringUtilityStruct()).Split "foo.bar.baz" ".b" removeEmpty:false)
    -- 結果
    #("foo", "", "ar", "", "az")
  )
  ```

  文字列配列の指定に対しても同様の法則が適用される。

  ```maxscript
  (
    format "%\n" ((::StringUtilityStruct()).Split "foo.bar.baz" #(".b") removeEmpty:false)
    -- 結果
    #("foo", "ar", "az")
  )
  ```
  */
  public fn Split input separator removeEmpty:true = (
    local options = if removeEmpty then #(#RemoveEmptyEntries) else #(#None)
    local optionsObject = this.stringSplitOptionsEnum.Create options
    (DotNetObject this.stringClass input).Split separator optionsObject
  ),

  /*-
  `\n`の位置で部分文字列に分割する。
  @param input <String>
  @returns <Array[<String>]>
  */
  public fn SplitByLF input = (
    this.lfRegex.Split input
  ),

  /*-
  入力値の各文字を要素とする配列に変換する。
  @param input <String>
  @returns <Array[<String>]>
  @remarks 空文字列の場合は空配列を返す。
  */
  public fn ToCharArray input = (
    (DotNetObject this.stringClass input).ToCharArray()
  ),

  /*-
  入力値をパスカル形式の文字列に変換する。
  @param input <Any>
  @returns <String>
  @remarks
  `BooleanClass`、`OkClass`、`UndefinedClass`、`UnsuppliedClass`のリテラルは全て小文字になる。
  文字列リテラル中のエスケープシーケンスのエスケープ処理は行わない。
  */
  public fn ToPascalCase input = (
    local result = ""
    case classOf input of (
      (Array): (
        result = "#("
        for i = 1 to input.Count do (
          if i > 1 do result += ", "
          local elementValue = this.ToPascalCase input[i]
          if classOf input[i] == String do (
            elementValue = "\"" + elementValue + "\""
          )
          result += elementValue
        )
        result += ")"
      )
      (BigMatrix): (
        result = "#BigMatrix("
        for i = 1 to input.Rows do (
          if i > 1 do result += ", "
          result += "["
          for j = 1 to input.Columns do (
            if j > 1 do result += ", "
            result += input[i][j] as String
          )
          result += "]"
        )
        result += ")"
      )
      (BooleanClass): result = toLower (input as String)
      (DataPair): (
        local propNames = getPropNames input
        local isExplicitPropNames = propNames.Count == 4
        local v1Value = this.ToPascalCase input.V1
        local v2Value = this.ToPascalCase input.V2
        if classOf input.V1 == String do (
          v1Value = "\"" + v1Value + "\""
        )
        if classOf input.V2 == String do (
          v2Value = "\"" + v2Value + "\""
        )
        if isExplicitPropNames do (
          local v1Name = this.TrimStart (this.ToPascalCase propNames[3]) "#"
          local v2Name = this.TrimStart (this.ToPascalCase propNames[4]) "#"
          v1Value = v1Name + ":" + v1Value
          v2Value = v2Name + ":" + v2Value
        )
        result = "(DataPair " + v1Value + " " + v2Value + ")"
      )
      (Dictionary): (
        result = "(Dictionary " + this.ToPascalCase input.Type
        for key in input.Keys do (
          local keyText = this.ToPascalCase key
          local valueText = this.ToPascalCase input[key]
          if classOf key == String do (
            keyText = "\"" + keyText + "\""
          )
          if classOf input[key] == String do (
            valueText = "\"" + valueText + "\""
          )
          result += " #(" + keyText + ", " + valueText + ")"
        )
        result += ")"
      )
      (Interval): (
        result = "(Interval"
        result += " " + toLower (input.Start as String)
        result += " " + toLower (input.End as String)
        result += ")"
      )
      (OkClass): result = toLower (input as String)
      (StringStream): (
        result = "(StringStream \"" + this.ToPascalCase (input as String) + "\")"
      )
      (Time): result = toLower (input as String)
      (UndefinedClass): result = toLower (input as String)
      (UnsuppliedClass): result = toLower (input as String)
      default: (
        result = input as String
        local matches = this.camelRegex.Matches result
        if matches.Count > 0 do (
          result = toLower result
          for i = 1 to matches.Count do (
            local index = matches.Item[i - 1].Index + 1
            result[index] = toUpper result[index]
          )
        )
        if classOf input == Name do (
          if this.nonWordRegex.IsMatch result do (
            result = "'" + result + "'"
          )
          result = "#" + result
        )
      )
    )
    if not (classOf input == Name or classOf input == String) \
        and this.commaRegex.IsMatch result do (
      result = this.commaRegex.Replace result ", "
    )
    result
  ),

  /*-
  先頭および末尾の空白文字を全て削除する。
  @param input <String>
  @returns <String>
  */
  public fn Trim input = (
    (DotNetObject this.stringClass input).Trim()
  ),

  /*-
  末尾から指定した文字セットを全て削除する。
  @param input <String>
  @param chars <String> 削除する文字の文字列。
  @returns <String>
  */
  public fn TrimEnd input chars = (
    (DotNetObject this.stringClass input).TrimEnd chars
  ),

  /*-
  先頭から指定した文字セットを全て削除する。
  @param input <String>
  @param chars <String> 削除する文字の文字列。
  @returns <String>
  */
  public fn TrimStart input chars = (
    (DotNetObject this.stringClass input).TrimStart chars
  ),

  /*- @returns <Name> */
  public fn StructName = #StringUtilityStruct,

  /*-
  @param indent: <String>
  @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
  @returns <OkClass>
  */
  public fn Dump indent:"" out:listener = (
    format "%StringUtilityStruct\n" indent to:out
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
    this.dotNetUtility = (::standardDefinitionPool[@"DotNetUtility.ms"])()
    this.enumDef = ::standardDefinitionPool[@"Enum.ms"]

    this.regexOptionsEnum = this.enumDef "System.Text.RegularExpressions.RegexOptions"
    this.stringSplitOptionsEnum = this.enumDef "System.StringSplitOptions"

    this.backslashRegex = this.CreateRegex "\\\\"
    this.camelRegex = this.CreateRegex "(?<=\b)\w|(?<=[a-z])[A-Z]|(?<=[0-9_])[a-z]" options:#()
    this.commaRegex = this.CreateRegex "\s*,\s*"
    this.crRegex = this.CreateRegex "\r"
    this.doubleQuoteRegex = this.CreateRegex "\\\""
    this.formatRegex = this.CreateRegex "(?<!\\\\)%"
    this.lfRegex = this.CreateRegex "\n"
    this.nonWordRegex = this.CreateRegex "\W"
    this.percentRegex = this.CreateRegex "\\\\%"
    this.tabRegex = this.CreateRegex "\t"
  )
)
