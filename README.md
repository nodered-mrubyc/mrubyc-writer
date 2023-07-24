# mrubyc-writer

## clone：

git submodule を使っているので，--recursive を付けて下さい．

```sh
git clone --recursive https://github.com/nodered-mrubyc/mrubyc-writer.git
```

## コンテナのセットアップ

ダウンロードしたリポジトリのディレクトリに移動し，
コンテナのビルドと起動を行う．

```sh
docker-compose build
docker-compose up -d
```

- mrbwrite2 は sinatra を使っており，ポート番号 4567 を利用する．sinatraの 4567 番ポートは Docker デスクトップの 80 番ポートにマッピングされる
- バックグランドで動かす場合は `-d` オプションをつける。

## コンテナにログインする方法

```sh
docker-compose exec mrbwrite2 bash
```

## アクセス方法

ブラウザで `http://localhost/` にアクセスする。

## デモ

https://github.com/nodered-mrubyc/mrubyc-writer/assets/32918854/c550f5e2-f766-4150-8089-24b6b8cf508a

