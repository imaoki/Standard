# Standard

<!-- [![GitHub release (latest by date)](https://img.shields.io/github/v/release/imaoki/Standard)](https://github.com/imaoki/Standard/releases/latest) -->
[![GitHub](https://img.shields.io/github/license/imaoki/Standard)](https://github.com/imaoki/Standard/blob/main/LICENSE)

Standard library of general-purpose functions.
<!-- 汎用的な機能をまとめた標準ライブラリ。 -->

## Development Environment
<!-- 開発環境 -->

`3ds Max 2024`

## Install
<!-- インストールする -->

Execute `install.ms`.
<!-- `install.ms`を実行する。 -->

## Uninstall
<!-- アンインストールする -->

Execute `uninstall.ms`.
<!-- `uninstall.ms`を実行する。 -->

## Standalone version
<!-- スタンドアローン版 -->

### Install
<!-- インストールする -->

Execute `Distribution\Standard.min.ms`.
<!-- `Distribution\Standard.min.ms`を実行する。 -->

### Uninstall
<!-- アンインストールする -->

```maxscript
::std.Uninstall()
```

## Usage
<!-- 使い方 -->

### Basic Observer Pattern

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

  fn testNotification type param = (
    case type of (
      (#Count): format "count:%\n" param
      default: ()
    )
    ok
  )

  local testObj = TestStruct()
  testObj.StateChanged.Subscribe (::std.ObserverStruct testNotification)

  testObj.Increment()
  ok
)
```

## License
<!-- ライセンス -->

[MIT License](https://github.com/imaoki/Standard/blob/main/LICENSE)
