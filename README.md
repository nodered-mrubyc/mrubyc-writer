# mrubyc-writer

## 注意：
公開リポジトリには Node-RED の出力する JSON ファイルを Ruby コードに変換するためのスクリプトやライブラリは含まれていません．それらは，現在，mrubyc-writer-priv (プライベートリポジトリ) にて限定公開しています．

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
docker-compose exec mrbwrite2 bash
```

バックグランドで動かす場合は `-d` をつける。

## アクセス方法

ブラウザで `http://localhost/` にアクセスする。

## デモ

https://github.com/nodered-mrubyc/mrubyc-writer/assets/32918854/c550f5e2-f766-4150-8089-24b6b8cf508a

