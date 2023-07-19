# Standard

<!-- [![GitHub release (latest by date)](https://img.shields.io/github/v/release/imaoki/Standard)](https://github.com/imaoki/Standard/releases/latest) -->
[![GitHub](https://img.shields.io/github/license/imaoki/Standard)](https://github.com/imaoki/Standard/blob/main/LICENSE)

汎用的な機能をまとめた標準ライブラリ。
<!-- Standard library of general-purpose functions. -->

## ライセンス
<!-- ## License -->

[MIT License](https://github.com/imaoki/Standard/blob/main/LICENSE)

## 開発環境
<!-- ## Development Environment -->

`3ds Max 2024`

## インストール
<!-- ## Install -->

Execute `install.ms`.

<!-- `install.ms`を実行する。 -->
## アンインストール
<!-- ## Uninstall -->

`uninstall.ms`を実行する。
<!-- Execute `uninstall.ms`. -->

## 単一ファイル版
<!-- ## Single File Version -->

### インストール
<!-- ### Install -->

`Distribution\Standard.min.ms`を実行する。
<!-- Execute `Distribution\Standard.min.ms`. -->

### アンインストール
<!-- ### Uninstall -->

```maxscript
::std.Uninstall()
```

## 使い方
<!-- ## Usage -->

### 基本的なオブザーバーパターン
<!-- ### Basic Observer Pattern -->

```maxscript
(
  struct TestStruct (
    private count = 0,

    public fn Increment = (
      this.count += 1
      this.StateChanged.Notify #Count this.count
      ok
    ),

    public StateChanged,

    on Create do (
      this.StateChanged = ::std.ObservableStruct()
    )
  )

  fn countChanged type param = (
    case type of (
      (#Count): format "countChanged count:%\n" param
      default: ()
    )
    ok
  )

  local testObj = TestStruct()
  testObj.StateChanged.Subscribe countChanged

  testObj.Increment()
  ok
)
```
