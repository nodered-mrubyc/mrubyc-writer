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
