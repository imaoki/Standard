/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
/*-
2つのオブジェクトが等しいかどうかを比較する。
@remarks 戻り値が以下のような関係になるように実装する。

| 値   | 関係               |
| ---- | ------------------ |
| `-1` | `a`は`b`より小さい |
| `0`  | `a`と`b`は等しい   |
| `1`  | `a`は`b`より大きい |
*/
struct ComparerStruct (
  /*- @prop <DotNetMethod> */
  private stringLogicalComparer,

  /*
  public fn CompareName a b = (),
  public fn CompareNodeHandle a b = (),
  public fn CompareProperty a b propName: = (),
  public fn CompareStringLogical a b = (),

  private fn simpleCompare a b = (),
  */

  /*-
  `Name`プロパティを比較する。
  @param a <Any>
  @param b <Any>
  @returns <Integer>
  @remarks 値が文字列の場合は`CompareStringLogical`を利用する。
  */
  public fn CompareName a b = (
    if classOf a.Name == String and classOf b.Name == String then (
      this.CompareStringLogical a.Name b.Name
    )
    else (
      this.simpleCompare a.Name b.Name
    )
  ),

  /*-
  ノードハンドルを比較する。
  @param a <Node>
  @param b <Node>
  @returns <Integer>
  */
  public fn CompareNodeHandle a b = (
    this.simpleCompare a.INode.Handle b.INode.Handle
  ),

  /*-
  任意のプロパティを比較する。
  @param a <Any>
  @param b <Any>
  @param propName: <Name|String> プロパティ名。
  @returns <Integer>
  @remarks 値が文字列の場合は`CompareStringLogical`を利用する。
  */
  public fn CompareProperty a b propName: = (
    local aValue = getProperty a propName
    local bValue = getProperty b propName
    if classOf aValue == String and classOf bValue == String then (
      this.CompareStringLogical aValue bValue
    )
    else (
      this.simpleCompare aValue bValue
    )
  ),

  /*-
  文字列中の数字を数値として比較する。
  @param a <String>
  @param b <String>
  @returns <Integer>
  @remarks
  例
  :   ```maxscript
      (
        local strings = #(
          "20string",
          "2string",
          "3string",
          "st20ring",
          "st2ring",
          "st3ring",
          "string2",
          "string20",
          "string3"
        )
        qsort strings (::ComparerStruct()).CompareStringLogical

        for str in strings do format "-- \"%\"\n" str
        ok
      )
      -- 実行結果
      -- "2string"
      -- "3string"
      -- "20string"
      -- "st2ring"
      -- "st3ring"
      -- "st20ring"
      -- "string2"
      -- "string3"
      -- "string20"
      ```
  */
  public fn CompareStringLogical a b = (
    this.stringLogicalComparer a b
  ),

  /*-
  @param a <Any>
  @param b <Any>
  @returns <Integer>
  */
  private fn simpleCompare a b = (
    case of (
      (a < b): -1
      (a > b): 1
      default: 0
    )
  ),

  /*- @returns <Name> */
  public fn StructName = #ComparerStruct,

  /*-
  @param indent: <String>
  @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
  @returns <OkClass>
  */
  public fn Dump indent:"" out:listener = (
    format "%ComparerStruct\n" indent to:out
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
    this.stringLogicalComparer = (
      local code = StringStream ""
      format "using System;\n" to:code
      format "using System.Collections;\n" to:code
      format "using System.Runtime.InteropServices;\n" to:code
      format "public sealed class StringLogicalComparer : IComparer {\n" to:code
      format "  [DllImport(\"shlwapi.dll\", CharSet = CharSet.Unicode, ExactSpelling = true)]\n" to:code
      format "  static extern int StrCmpLogicalW(String a, String b);\n" to:code
      format "  public int Compare(object a, object b) {\n" to:code
      format "    return StrCmpLogicalW((String)a, (String)b);\n" to:code
      format "  }\n" to:code
      format "}" to:code
      code = code as String
      local provider = DotNetObject "Microsoft.CSharp.CSharpCodeProvider"
      local params = DotNetObject "System.CodeDom.Compiler.CompilerParameters"
      params.GenerateInMemory = true
      local compilerResults = provider.CompileAssemblyFromSource params #(code)
      local assembly = compilerResults.CompiledAssembly
      (assembly.CreateInstance "StringLogicalComparer").Compare
    )
  )
)
