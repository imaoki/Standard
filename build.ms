/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
(
  /* 初期化 */
  local mp = ::MxsPackStruct (getSourceFileName())
  /* 出力先ディレクトリ削除 */
  -- mp.DeleteDirectory @".\Distribution"

  /* コード切り出し */
  local AttributeUtilityCode = mp.ClipFile @".\AttributeUtility.ms" 93 -1
  local ComparerCode = mp.ClipFile @".\Comparer.ms" 259 -1
  local ConfigCode = mp.ClipFile @".\Config.ms" 85 -1
  local definitionPoolCode = mp.ClipFile @".\definitionPool.ms" 1 1345
  local DialogCode = mp.ClipFile @".\Dialog.ms" 1949 -1
  local DotNetUtilityCode = mp.ClipFile @".\DotNetUtility.ms" 90 -1
  local EasingCode = mp.ClipFile @".\Easing.ms" 89 -1
  local EncodingCode = mp.ClipFile @".\Encoding.ms" 181 -1
  local EnumCode = mp.ClipFile @".\Enum.ms" 183 -1
  local FileUtilityCode = mp.ClipFile @".\FileUtility.ms" 173 -1
  local ObservableCode = mp.ClipFile @".\Observable.ms" 324 -1
  local PathUtilityCode = mp.ClipFile @".\PathUtility.ms" 96 -1
  local StandardCode = mp.ClipFile @".\Standard.ms" 1 -1
  local StringUtilityCode = mp.ClipFile @".\StringUtility.ms" 93 -1
  local TimerCode = mp.ClipFile @".\Timer.ms" 1246 -1
  local TimerGlobalCode = mp.ClipFile @".\Timer.ms" 263 565
  local ViewportUtilityCode = mp.ClipFile @".\ViewportUtility.ms" 92 -1

  /* コード置換 */
  local code = mp.ReplaceText definitionPoolCode 1327 19 ConfigCode
  code = mp.ReplaceText code 1208 24 FileUtilityCode
  code = mp.ReplaceText code 1073 18 TimerCode
  code = mp.ReplaceText code 976 19 DialogCode
  code = mp.ReplaceText code 893 21 EncodingCode
  code = mp.ReplaceText code 783 26 StringUtilityCode
  code = mp.ReplaceText code 689 17 EnumCode
  code = mp.ReplaceText code 598 28 ViewportUtilityCode
  code = mp.ReplaceText code 523 24 PathUtilityCode
  code = mp.ReplaceText code 453 23 ObservableCode
  code = mp.ReplaceText code 388 19 EasingCode
  code = mp.ReplaceText code 320 26 DotNetUtilityCode
  code = mp.ReplaceText code 250 21 ComparerCode
  code = mp.ReplaceText code 177 29 AttributeUtilityCode
  code = mp.ClipText code 64 -1
  code = mp.ReplaceText StandardCode 64 27 code
  code = mp.InsertText code 64 "\n"
  code = mp.InsertText code 64 TimerGlobalCode

  /* インストールコード追加 */
  code = mp.AppendText code "::StandardStruct.Install()\n::StandardStruct\n"
  /* インストーラーオプション削除 */
  code = mp.RemoveInstallerOption code
  /* バンドルファイルを保存 */
  -- mp.WriteAllText @".\Distribution\Standard.bundle.ms" code
  /* 最小化ファイルを保存 */
  code = mp.Minify code
  mp.WriteAllText @".\Distribution\Standard.min.ms" code
  /* ファイルコピー */
  -- mp.CopyDirectory @".\Standard.SubDir" @".\Distribution\Standard.SubDir"
  ok
)
