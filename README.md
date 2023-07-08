# How to use mrbwrite2

## コンテナのセットアップ

ダウンロードしたリポジトリのディレクトリに移動し，
コンテナのビルドと起動を行う．

```sh
docker-compose build
docker-compose up
```

- mrbwrite2 は sinatra を使っており，ポート番号 4567 を利用する．sinatraの 4567 番ポートは Docker デスクトップの 80 番ポートにマッピングされる
- 時々，apt install や gem install で Web サイトにアクセスできないという理由で docker-compose up が失敗するとこがある．その場合は docker-compose build コマンドでコンテナを作り直すのが良い．

## コンテナにログインする方法

```sh
docker-compose exec mrbwrite bash
```

バックグランドで動かす場合は `-d` をつける。

## アクセス方法

ブラウザで `http://localhost/` にアクセスする。

