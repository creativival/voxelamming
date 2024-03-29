# ボクセラミング - ARを使ったプログラミング学習アプリ

ボクセラミングは、プログラミング初心者とジェネラティブアーティストのための、iOSに対応したARを使ったプログラミング学習アプリです。

ボクセラミング・スタジオは、Apple Vision Proに対応した新バージョンです。操作はボクセラミングとほぼ同じですが、一部機能制限があります。

<a href="https://apps.apple.com/jp/app/%E3%83%9C%E3%82%AF%E3%82%BB%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0/id6451427658?itsct=apps_box_badge&amp;itscg=30200" style="display: inline-block; overflow: hidden; border-radius: 13px; width: 250px; height: 83px;"><img src="https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/ja-jp?size=250x83&amp;releaseDate=1690502400" alt="Download on the App Store" style="border-radius: 13px; width: 250px; height: 83px;"></a>

<p align="center"><img src="https://creativival.github.io/voxelamming/image/voxelamming_ladder.png" alt="VoxelLadder" width="100%"/></p>

[//]: # (<p align="center"><video width="1280" height="720" controls>)

[//]: # (    <source src="video/voxelamming_top_video.mp4" type="video/mp4">)

[//]: # (</video></p>)

* Read this in other languages: [English](README.en.md), [日本語](README.md)*

## ボクセラミングとは

ボクセラミング = ボクセル + プログラミング

ボクセラミングは、ARを使ったプログラミング学習アプリです。ARに対応したiPhone、iPad（iOS 16以上）とApple Vision Proで無料で使用できます。パソコンでプログラムしたボクセル（ピクセルと同様に3D空間における最小単位の立方体）を仮想空間上に配置して遊ぶことができます。

## 使い方

### パソコンの準備

パソコンは、Windows、Macの両対応です。お使いのパソコンに、プログラミング言語（Python、Node.js、Ruby、Swift）がインストールされていないときは、使いたい言語をインストールしてください。パソコンとデバイス（iPhone、iPad、Apple Vision Pro）のデータ通信はインターネット回線を使います（同じ回線に繋がなくてもよい）。以上で、パソコンの準備ができました。

### 平面アンカーの設置

#### iPhone、iPad
ボクセラミングアプリを起動します。初回の起動時のみ、カメラの使用許可を求められるので「はい」で許可してください。ガメラが起動すると、ARが自動で現実世界の平面を探します。平面検知の印（赤緑青の座標軸）が出たら、画面をタップして平面アンカーを設置します。平面アンカーは白と黒のタイルで構成されています。以上でボクセルを設置する準備が整いました。

#### Apple Vision Pro

ボクセラミング・スタジオアプリを起動します。「Set Base Anchor」ボタンをタップして、ベースアンカーを設置します。ベースアンカーは白と黒のタイルで構成されています。以上でボクセルを設置する準備が整いました。なお、ベースアンカーはドラッグして移動できます。

### ボクセルのモデリング（プログラミング）

パソコン（Windows、Mac）でボクセルを設置するための「ボクセルデータ」をプログラミングします。ボクセルデータには、「位置、色、サイズ、設置する間隔など」の情報が含まれます。対応の言語は、Scratch3 MOD、Python、JavaScript (Node.js)、Ruby、Swiftです。

スクリプトを作成しましょう。[sampleフォルダー](https://github.com/creativival/voxelamming/tree/main/sample) のスクリプトを参考にしてください。WebSocketサーバーのルームに接続するために、変数room_name（roomName）をデバイス（iPhone、iPad、Apple Vision Pro）の画面中央に表示されている文字列に合わせることを忘れないようにしてください。

次に、各言語の繰り返し文や条件式などを使って、ボクセルデータを作成します。ボクセルの位置は、平面アンカーを基準にして、x軸、y軸、z軸の値を指定します。x軸は左右、y軸は上下、z軸は奥行き（手前がプラス）を表します（単位はセンチメートル）。ボクセルの大きさは、1.0cmを基準にして小数で指定します。色はRGB値で0から1までの小数で指定します。そして、ボクセルを設置する間隔を秒で指定します。ボクセルを設置する間隔を指定することで、ボクセルが一気に設置されるのではなく、時間をかけて設置されるようになります。

### ARボクセルのビルド

スクリプトを実行すると、WebSocket通信でボクセルデータがデバイス（iPhone、iPad、Apple Vision Pro）に送信されます。データが受信できたら、デバイス画面の平面アンカーを基準にして、ARボクセルが設置されます。

＊ WebSocketサーバーが休止しているとき、データ送信が失敗する場合があります。そのときは、しばらく待ってから再度実行してください。

## メソッドの説明

スクリプトで使用するメソッドを説明します。各言語のメソッド名は、以下の通りです。

* set_room_name(room_name)：デバイス（iPhone、iPad、Apple Vision Pro）と通信するためのルームネームを指定します。ルームネームはアプリを実行すると、画面中央に表示されます。同じルームネームを指定することで、デバイスとパソコンが通信できます。
* set_box_size(size)：ボクセルの大きさを設定します。単位はセンチメートルです。デフォルトは1.0です。
* set_build_interval(interval)：ボクセルを設置する間隔（インターバル）を設定します。ボクセルを一つずつ設置するアニメーションを表現できます。単位は秒です。デフォルトは0.01です。
* change_shape：ボクセルを形状を変更します。立方体（box）、球体（square）、平面（plane）が選べます。
* change_material(is_metallic, roughness)：ボクセルを材質を変更します。is_metallicを「オン」にすると金属調になります。roughnessは粗さを表し、0から1の小数で指定します。
* create_box(x, y, z, r, g, b, alpha)：ボクセルを設置します。x軸、y軸、z軸の位置と、色を指定します。色はRGBA値で0から1までの小数で指定します。alphaは透明度を表し、0から1の小数で指定します。
* create_box(x, y, z, texture)：テクスチャー付きのボクセルを設置します。x軸、y軸、z軸の位置と、テクスチャーを指定します。grass, stone, dirt, planks, bricksから選びます。
* remove_box(x, y, z)：ボクセルを削除します。x軸、y軸、z軸の位置を指定します。（指定位置にボクセルがないときは、何もしません）
* write_sentence(sentence, x, y, z, r, g, b, alpha)：1行の文sentenceをボクセルで描きます。x軸、y軸、z軸の位置と、色をRGBA値で指定します。
* set_light(x, y, z, r, g, b, alpha, intensity, interval, light_type)：ライトを配置します。ライトの位置（x, y, z）色（r, g, b, alpha）を指定します。強さ（intensity）のデフォルトは1000です。点滅させるには間隔（interval）を秒で指定します（0にすると点滅しない）light_typeは「ポイント、スポット、ディレクショナル」のいずれかを選びます。
* set_command(command)：コマンドを設定します。コマンドは、"axis"（座標を表示する）、"japaneseCastle"（日本のお城を建築する）、"float"（小数点の位置にボクセルが置ける）、"liteRender"（描画を簡略化して処理を軽くする）が実装されています。
* draw_line(x1, y1, z1, x2, y2, z2, r, g, b, alpha)：2点間を線で結びます。x1, y1, z1は始点、x2, y2, z2は終点です。色はRGBA値で0から1までの小数で指定します。
* send_data()：ボクセルデータをデバイス（iPhone、iPad、Apple Vision Pro）に送信します。ARボクセルを設置するとき実行します。
* clear_data()：ボクセルデータを初期化します。サイズ、インターバルも初期化します（送信後、ボクセルデータを初期化したいときに実行してください。）。
* translate(x, y, z, pitch, yaw, roll):ボクセルをまとめるノードの位置（x, y, z）と角度（pitch, yaw, roll）を指定します。
* animate(x, y, z, pitch, yaw, roll, scale, interval):ノードのアニメーション。移動（x, y, z）、回転（pitch, yaw, roll）、拡大（scale）、設置する間隔（interval）を指定します。（RealityKitの制限のため、回転角度は180度以下にしてください）
* animate_global(x, y, z, pitch, yaw, roll, scale, interval):全てのボクセルの「ベースアンカーを基準にした」アニメーション。移動（x, y, z）、回転（pitch, yaw, roll）、拡大（scale）、設置する間隔（interval）を指定します。（RealityKitの制限のため、回転角度は180度以下にしてください）
* push_matrix(): 座標系を保存します。現在のノードの位置と角度をスタックに保存します。
* pop_matrix(): 座標系を復元します。スタックに保存したノードの位置と角度を復元します。
* frame_in(): フレームの撮影を開始します。ボクセルを設置する前に実行してください。フレームはアニメーションとして再生できます。
* frame_out(): フレームの撮影を終了します。ボクセルを設置した後に実行してください。
* set_frame_fps(fps): フレームの再生速度を設定します。デフォルトは2です。
* set_frame_repeats(repeats): フレームの再生回数を設定します。デフォルトは10です。

＊ スネークケースとキャメルケースは読み替えてください。（set_box_size -> setBoxSize）

## サンプルスクリプト

[sampleフォルダー](https://github.com/creativival/voxelamming/tree/main/sample)に、サンプルスクリプトを用意しました。以下のスクリプトを実行すると、トップ画像のようなボクセルが設置されます。

### Scratch3 MOD

ボクセラミング拡張機能を読み込んで、スクリプトを作成してください。

[Xcratchで、サンプルプロジェクトを再生する](https://xcratch.github.io/editor/#https://creativival.github.io/voxelamming-extension/projects/example.sb3)

<p align="center"><img src="https://creativival.github.io/voxelamming/image/voxelamming_scratch3.png" alt="voxelamming_scratch3" width="100%"/></p>

### Scratch3 MOD（タートルプログラミング）

Scratch3 MODのタートルプログラミングを使って、ボクセルを設置することができます。直感的にボクセルを設置できるので、プログラミング初心者、特に子どもにおすすめです。

[Xcratchで、サンプルプロジェクトを再生する](https://xcratch.github.io/editor/#https://creativival.github.io/voxelamming-turtle-extension/projects/example.sb3)

<p align="center"><img src="https://creativival.github.io/voxelamming/image/voxelamming_turtle_scratch3.png" alt="voxelamming_turtle_scratch3" width="100%"/></p>

### Python (3.6以上)

#### スクリプト

```python
# Python
from build_box import BuildBox

room_name = "1000"
build_box = BuildBox(room_name)

build_box.set_box_size(0.5)
build_box.set_build_interval(0.01)
build_box.translate(0, 0, 0, pitch=0, yaw=0, roll=0)
build_box.animate(0, 0, 10, pitch=0, yaw=30, roll=0, scale=2, interval= 10)

for i in range(100):
  build_box.create_box(-1, i, 0, r=0, g=1, b=1)
  build_box.create_box(0, i, 0, r=1, g=0, b=0)
  build_box.create_box(1, i, 0, r=1, g=1, b=0)
  build_box.create_box(2, i, 0, r=0, g=1, b=1)

for i in range(50):
  build_box.remove_box(0, i * 2 + 1, 0)
  build_box.remove_box(1, i * 2, 0)

build_box.send_data()
```

#### 実行方法

```bash
$ sample/python
$ python main.py

or  

$ python3 main.py
```

### JavaScript (Node.js)

#### スクリプト

```javascript
// JavaScript (Node.js)
import BuildBox from './buildBox.mjs';

const roomName = '1000';
const buildBox = new BuildBox(roomName);

buildBox.setBoxSize(0.5);
buildBox.setBuildInterval(0.01);

for (let i = 0; i < 100; i++) {
  buildBox.createBox(-1, i, 0, 0, 1, 1);
  buildBox.createBox(0, i, 0, 1, 0, 0);
  buildBox.createBox(1, i, 0, 1, 1, 0);
  buildBox.createBox(2, i, 0, 0, 1, 1);
}

for (let i = 0; i < 50; i++) {
  buildBox.removeBox(0, i * 2, 0);
  buildBox.removeBox(1, i * 2 + 1, 0);
}

buildBox.sendData();
```

#### 実行方法

```bash
$ sample/javascipt
$ node main.mjs
```

### Ruby

#### スクリプト

```ruby
# Ruby
require_relative 'build_box'

room_name = '1000'
build_box = BuildBox.new(room_name)

build_box.set_box_size(0.5)
build_box.set_build_interval(0.01)

for i in 0...100
  build_box.create_box(-1, i, 0, 0, 1, 1)
  build_box.create_box(0, i, 0, 1, 0, 0)
  build_box.create_box(1, i, 0, 1, 1, 0)
  build_box.create_box(2, i, 0, 0, 1, 1)
end

for i in 0...50
  build_box.remove_box(0, i * 2, 0)
  build_box.remove_box(1, i * 2 + 1, 0)
end

build_box.send_data
```

#### 実行方法

```bash
$ sample/ruby
$ ruby main.rb
```

### Swift

#### スクリプト

```swift
// Swift
import Foundation

if #available(iOS 15.0, macOS 12.0, *) {
    let roomName = "1000"
    let buildBox = BuildBox(roomName: roomName)
    buildBox.setBoxSize(0.5)
    buildBox.setBuildInterval(0.01)

    Task {
        do {
            for i in 0..<100 {
                buildBox.createBox(-1, Double(i), 0, r: 0, g: 1, b: 1)
                buildBox.createBox(0, Double(i), 0, r: 1, g: 0, b: 0)
                buildBox.createBox(1, Double(i), 0, r: 1, g: 1, b: 0)
                buildBox.createBox(2, Double(i), 0, r: 0, g: 1, b: 1)
            }

            for i in 0..<50 {
                buildBox.removeBox(0, Double(i * 2), 0)
                buildBox.removeBox(1, Double(i * 2 + 1), 0)
            }

            try await buildBox.sendData()
        } catch {
            print("An error occurred: \(error)")
        }
    }

    RunLoop.main.run(until: Date(timeIntervalSinceNow: 10)) // Or longer depending on your needs
} else {
    fatalError("This script requires iOS 15.0 / macOS 12.0 or later.")
}

```

#### 実行方法

```bash
$ cd sample/swift/main
$ swift run
```
## ショーケース

### 球体

<p align="center"><img src="https://creativival.github.io/voxelamming/image/square_sample.png" alt="square_sample" width="50%"/></p>

### ノードの配置

<p align="center"><img src="https://creativival.github.io/voxelamming/image/move_sample.png" alt="move_sample" width="50%"/></p>

### ノードの回転

<p align="center"><img src="https://creativival.github.io/voxelamming/image/rotation_sample.png" alt="rotation_sample" width="50%"/></p>

### ノードのアニメーション

<p align="center"><img src="https://creativival.github.io/voxelamming/image/animation_sample.png" alt="animation_sample" width="50%"/></p>

### グローバルのアニメーション

<p align="center"><img src="https://creativival.github.io/voxelamming/image/global_animation_sample.png" alt="animation_sample" width="50%"/></p>

### 文字表示

<p align="center"><img src="https://creativival.github.io/voxelamming/image/sentence_sample.png" alt="sentence_sample" width="50%"/></p>

### 地図

liteRenderコマンドを使って、描画を軽くしています。

<p align="center"><img src="https://creativival.github.io/voxelamming/image/japan_map.png" alt="japan_map" width="50%"/></p>

### MagicaVoxelで作成したモデルの表示

<p align="center"><img src="https://creativival.github.io/voxelamming/image/voxel_model.png" alt="voxel_model" width="50%"/></p>

### 透明ボクセル

<p align="center"><img src="https://creativival.github.io/voxelamming/image/set_alpha_sample.png" alt="set_alpha_sample" width="50%"/></p>

### 線を引く

<p align="center"><img src="https://creativival.github.io/voxelamming/image/draw_line.png" alt="draw_line" width="50%"/></p>

### 形状を変更（立方体、球体、平面）

<p align="center"><img src="https://creativival.github.io/voxelamming/image/change_shape.png" alt="change_shape" width="50%"/></p>

### マテリアル（材質）を変更

<p align="center"><img src="https://creativival.github.io/voxelamming/image/change_material.png" alt="change_material" width="50%"/></p>

### ライト（iOSのみ）

<p align="center"><img src="https://creativival.github.io/voxelamming/image/light_sample.png" alt="light_sample" width="50%"/></p>

### コマンド

<p align="center"><img src="https://creativival.github.io/voxelamming/image/command_sample.png" alt="command_sample" width="50%"/></p>

### リセットコマンド

モデルの作成とリセットを交互に繰り返すことで、モデルのアニメーションを作成できます。

<p align="center"><img src="https://creativival.github.io/voxelamming/image/reset_command.png" alt="reset_command" width="50%"/></p>

### フロートコマンド

<p align="center"><img src="https://creativival.github.io/voxelamming/image/float_command.png" alt="float_command" width="50%"/></p>

### 座標系の保存と復元

<p align="center"><img src="https://creativival.github.io/voxelamming/image/push_matrix.png" alt="push_matrix" width="50%"/></p>

### テクスチャー

<p align="center"><img src="https://creativival.github.io/voxelamming/image/texture.png" alt="texture" width="50%"/></p>

### フレームアニメーション

羽ばたく蝶々がフレームアニメーションとして再生されます。

<p align="center"><img src="https://creativival.github.io/voxelamming/image/frame_animation.png" alt="frame_animation" width="50%"/></p>

### ユーザー共有

準備中

## 設定

画面右上の「Settings」ボタンから設定画面に移動できます。デバッグモードをオフにすると、画面の情報表示が無効になります。

## ARワールドのリセット

画面右下の「リセット」ボタンからARワールドをリセットできます。リセットすると、ユーザーが作成したボクセルは全て削除されます。

## ライセンス

[MIT License](https://github.com/creativival/voxelamming/blob/master/LICENSE)

## 作者

creativival

## コンタクト

[コンタクト](https://creativival.github.io/voxelamming/contact.html)

## プライバシーポリシー

[プライバシーポリシー](https://creativival.github.io/voxelamming/privacy.html)


