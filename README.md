# Examples of JSON-Fortran

Fortran用のJSON APIを提供する[JSON-Fortran](https://github.com/jacobwilliams/json-fortran)の使用例．

## 要求ソフトウェア
- fpm
- JSON-Fortran
- Fortranコンパイラ
    - gfortran
    - Intel oneAPI

## ビルドおよび実行
ビルドおよび実行には[fpm](https://github.com/fortran-lang/fpm)を用いる．

### gfortranによるビルド
```console
fpm build
```
を実行してビルドする．ビルドが成功した後，次のコマンドによってプログラムを実行する．
```console
fpm run
```

### Intel Fortranによるビルド
コンパイラの選択とコンパイラに渡すフラグを設定するオプションが必要である．Linux版のifortでは，`/fpp`ではなく`-fpp`を用いる．

```console
fpm build --compiler ifort --flag "/fpp"
```

```console
fpm run --compiler ifort --flag "/fpp"
```

## JSON-Fortranの使用例
JSON-Fortranの使用例をまとめたモジュールを作成し，その中にモジュールサブルーチンとして使用例を実装した．使用例は3種類作成した．

1. 非常に単純なJSONファイルを読み込み，値を取得する．
2. 1よりは複雑なJSONファイルを読み込む．配列や入れ子になったデータを読み込む．
3. プログラム内でJSON書式の文字列を作成し，それを処理する．

## サブルーチン一覧
### `read_sample1_json_and_get_value()`
sample1.jsonを読み込んでkeyの値を取得する例．

```JSON
{
    "key": "value"
}
```

### `read_sample2_json_and_get_numerical_values()`
sample2.jsonを読み込んで，数値や配列を取得する例．
実数は表記の形式に依存しないことや，配列の取得に際して要素数が判らなくても可能なことが確認できる．

```JSON
{
    "value": {
        "integer": 1,
        "real": {
            "standard notation": 1.0,
            "exponential notation": 1e-4
        },
        "string": "str",
        "logical": "true"
    },
    "array": {
        "integer": [10, 9, 8, 7],
        "real": [6.0, 5.0, 4.0],
        "string": ["3", "2", "1", "-1"]
    }
}
```

### `create_json_from_string()`
文字列からjsonを取り扱うオブジェクトを生成する例．
プログラム内で下記のような文字列を作成し，JSON-Fortranで処理する．

```JSON
{
"value":{
"integer":2,
"real":1e+1,
"string":"str",
"logical":"false"
}
}
```

このような作成方法は，簡易的な連想リストの定義に利用できる．
