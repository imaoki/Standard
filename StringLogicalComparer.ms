/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
(
  /*-
  文字列を自然順でソートする。
  @param a <String> 比較する最初の文字列。
  @param b <String> 比較する2番目の文字列。
  @returns <Integer> 2つの比較対照値の構文上の関係を示す 32 ビット符号付き整数。

  | 値              | 条件                                           |
  | --------------- | ---------------------------------------------- |
  | `0`より小さい値 | 並べ替え順序において`a`は`b`の前になる。       |
  | `0`             | `a`は並べ替え順序で、`b`と同じ位置に出現する。 |
  | `0`より大きい値 | 並べ替え順序において`a`は`b`の後ろになる。     |
  @remarks
  例
  : ```maxscript
    (
      local compare = fileIn @"StringLogicalComparer.ms"

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
      qsort strings compare

      for str in strings do format "\"%\"\n" str
      ok
    )
    -- 実行結果
    "2string"
    "3string"
    "20string"
    "st2ring"
    "st3ring"
    "st20ring"
    "string2"
    "string3"
    "string20"
    ```
  */
  fn _ = (
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
)()
