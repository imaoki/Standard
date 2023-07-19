# Standard

<!-- [![GitHub release (latest by date)](https://img.shields.io/github/v/release/imaoki/Standard)](https://github.com/imaoki/Standard/releases/latest) -->
[![GitHub](https://img.shields.io/github/license/imaoki/Standard)](https://github.com/imaoki/Standard/blob/main/LICENSE)

汎用的な機能をまとめた標準ライブラリ。

## ライセンス

[MIT License](https://github.com/imaoki/Standard/blob/main/LICENSE)

## 要件

* （任意）[imaoki/StartupLoader](https://github.com/imaoki/StartupLoader)
  導入済みの場合はインストール/アンインストールでスタートアップスクリプトの登録/解除が行われる。
  未使用の場合はスクリプトの評価のみ行われる。

## 開発環境

`3ds Max 2024`

## インストール

Execute `install.ms`.

## アンインストール

`uninstall.ms`を実行する。

## 単一ファイル版

### インストール

`Distribution\Standard.min.ms`を実行する。

### アンインストール

```maxscript
::std.Uninstall()
```

## 使い方

### 基本的なオブザーバーパターン

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
