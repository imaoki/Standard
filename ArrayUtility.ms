/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
/*-
配列操作の追加メソッドを提供する。
*/
struct ArrayUtilityStruct (
  /*
  public fn MoveItems targetIndices destination = (),
  */

  /*-
  インデックスで指定した要素を移動する。
  @param items <Array[<Any>]> 操作対象の配列。
  @param targetIndices <Array[<Integer>]> 対象要素のインデックス配列。
  @param destination <Integer> 操作前のインデックスを基にした移動先のインデックス。
  @returns <Array[<Integer>]> 操作後の対象要素のインデックス配列。
  */
  public fn MoveItems items targetIndices destination = (
    local newIndices = #()
    if classOf items == Array and items.Count > 1 \
        and classOf targetIndices == Array \
        and classOf destination == Integer and destination > 0 do (
      local itemCount = items.Count
      local itemIndices = #{1..itemCount} as Array
      local targetCount = targetIndices.Count
      if 1 <= targetCount and targetCount <= itemCount do (
        for i = targetCount to 1 by -1 do (
          local index = targetIndices[i]
          if index >= destination do (
            index += targetCount - i
          )
          local item = items[index]
          local itemIndex = itemIndices[index]
          deleteItem items index
          deleteItem itemIndices index
          if index <= destination do (
            destination -= 1
          )
          insertItem item items destination
          insertItem itemIndex itemIndices destination
        )
        newIndices = for i in targetIndices collect (
          findItem itemIndices i
        )
      )
    )
    newIndices
  ),

  /*- @returns <Name> */
  public fn StructName = #ArrayUtilityStruct,

  /*-
  @param indent: <String>
  @param out: <FileStream|StringStream|WindowStream> 出力先。既定値は`listener`。
  @returns <OkClass>
  */
  public fn Dump indent:"" out:listener = (
    format "%ArrayUtilityStruct\n" indent to:out
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
