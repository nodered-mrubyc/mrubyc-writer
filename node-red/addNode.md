# ノードを追加する際の注意事項
- 同じ名前のノードは使うことができない
- `category`は名前を変更するだけでNode-REDに反映される
- `defaults`内に値を設定しておくと、ノードの初期値が設定される
- `package.json`ファイルの`nodes`部分び新しく作ったノードを指定

`json2mruby.rb`
- 新しく作ったノードタイプを既存のノードタイプに合わせる(合わせるノードのプログラム記述の後)
```
# example
if node[1][:type] == "sampleLED"
    node[1][:type] = "LED"
end
  ```