from time import sleep
from math import sin, cos, radians, pi, sqrt
# voxelammingパッケージからBuildBoxクラスをインポートします
from voxelamming import BuildBox

# Voxelammingアプリに表示されている部屋名を指定してください
room_name = "1000"
size = 1
radius = 1.5
repeat_count = 100

# BuildBoxクラスのインスタンスを生成します
build_box = BuildBox(room_name)
# ボクセルの設定を行います
build_box.set_build_interval(0.01)
build_box.set_box_size(size)
build_box.change_shape("sphere")
build_box.set_command('float')

# ボクセルを配置するため、位置と色を設定します
for i in range(repeat_count):
    angle = radians(i * 720 / repeat_count)
    x = radius * cos(angle)
    y = i
    z = radius * sin(angle)

    build_box.create_box(x, y, z, r=0, g=1, b=1, alpha=1)
    build_box.create_box(-x, y, -z, r=0, g=1, b=1, alpha=1)
    if i % 2 == 0:
        build_box.create_box(x / 3, y, z / 3, r=1, g=0, b=0, alpha=1)
    else:
        build_box.create_box(-x / 3, y, -z / 3, r=1, g=1, b=0, alpha=1)

# ボクセルデータをアプリに送信します。
build_box.send_data("main_float_command_sample")
