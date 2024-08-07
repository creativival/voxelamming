import time
# voxelammingパッケージからBuildBoxクラスをインポートします
from voxelamming import BuildBox

# Voxelammingアプリに表示されている部屋名を指定してください
room_name = "1000"
# BuildBoxクラスのインスタンスを生成します
build_box = BuildBox(room_name)
# ボクセルの設定を行います
build_box.set_box_size(0.5)
build_box.set_build_interval(0.01)
# build_box.set_command('float')

# draw_lineメソッドを使って直線を描画します
build_box.draw_line(0, 0, 0, 5, 10, 20, r=1, g=0, b=0, alpha=1)
build_box.send_data()

# ボクセルデータをアプリに送信します。
build_box.send_data("main_draw_line_sample")
