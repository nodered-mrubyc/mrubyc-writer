# Docker_node-red

以下のコマンドで、全てのサービスが起動する。

```sh
docker-compose up
```

- Node-REDは、ポート番号1880
- sinatraは、ポート番号4567
- sinatraの 4567 は、80 にマッピングされる

## Node-REDの起動方法

```sh
docker-compose up node-red
```

## sinatraの起動方法

```sh
docker-compose up sinatra
```

## 各環境へ入る方法

Node-REDの環境へ入るには、以下を実行する。`<service>`の部分には、`node-red`または`sinatra`を指定する。

```sh
docker-compose exec <service> bash
```

バックグランドで動かす場合は `-d` をつける。

## アクセス方法

ブラウザで `http://localhost/` にアクセスする。

## ノード作成・追加方法

(1)jsファイル、htmlファイル、jsonファイルを作成する。
以下にLEDノードの場合の例を示す。

・jsファイル
```sh
module.exports = function(RED){

function LED_Node(config){

node.on('input', function(){
*
});
}
RED.nodes.registerType("LED",LED_Node);
```

・htmlファイル
```sh
<script type="text/javascript">
    RED.nodes.registerType('LED', {　　
        category: 'mruby_Rboad_Nodes', //ノードのグループ名（common,fnction,network,parsers,sequence,storage,オリジナル）
        color: "#ffe3a6",
        defaults: {
           * //必要変数の設定
        },
        inputs: 1,　　//ノードの入力
        outputs: 0,　　//ノードの出力
        icon: "light.svg",　　//ノードのアイコン
        label: function () {
            return this.name || "LED";　　
        },

