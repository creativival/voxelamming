# voxelammingパッケージからBuildBoxクラスをインポートします
from voxelamming import BuildBox
from map_util import get_map_data_from_csv, get_box_color

# 変数の設定
column_num, row_num = 257, 257
csv_file = '../map_file/map_38_138_100km.csv'
height_scale = 100
high_color = (0.5, 0, 0)
low_color = (0, 1, 0)

# Voxelammingアプリに表示されている部屋名を指定してください
room_name = "1000"
# BuildBoxクラスのインスタンスを生成します
build_box = BuildBox(room_name)

# ボクセルの設定を行います
build_box.set_box_size(1)
build_box.set_build_interval(0.001)
build_box.set_command('liteRender')  # 描画を軽くするためのコマンド

# ボクセルを配置するため、位置と色を設定します
map_data = get_map_data_from_csv(csv_file, height_scale)
boxes = map_data['boxes']
max_height = map_data['maxHeight']
# skip = 1  # high power device
skip = 2  # normal
# skip = 4  # low power device

for j in range(row_num // skip):
    for i in range(column_num // skip):
        print(i, j)
        x = i - column_num // (skip * 2)
        z = j - row_num // (skip * 2)
        y = boxes[j * skip][i * skip]
        r, g, b = get_box_color(y, max_height, high_color, low_color)

        if y > 0:
            build_box.create_box(x, y, z, r, g, b, 1)

# ボクセルデータをアプリに送信します。
build_box.send_data("main_map_sample")
