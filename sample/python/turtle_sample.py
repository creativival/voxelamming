# voxelammingパッケージからBuildBoxクラスとTurtleクラスをインポートします
from voxelamming import BuildBox, Turtle

# Voxelammingアプリに表示されている部屋名を指定してください
room_name = "1000"
# BuildBoxクラスのインスタンスを生成します
build_box = BuildBox(room_name)
# ボクセルの設定を行います
build_box.set_box_size(0.3)
build_box.set_build_interval(0.01)

# ボクセルを配置するため、位置と色を設定します
t = Turtle(build_box)

t.set_color(1, 0, 0, 1)

t.forward(10)
t.left(90)
t.forward(10)
t.left(90)
t.forward(10)
t.left(90)
t.forward(10)
t.left(90)

t.up(90)
t.forward(10)
t.down(90)

t.forward(10)
t.left(90)
t.forward(10)
t.left(90)
t.forward(10)
t.left(90)
t.forward(10)

# ボクセルデータをアプリに送信します。
build_box.send_data("turtle_sample")
