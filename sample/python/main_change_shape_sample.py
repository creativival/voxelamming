import time
# voxelammingパッケージからVoxelammingクラスをインポートします
from voxelamming import Voxelamming
# from voxelamming_local import Voxelamming  # ローカルで開発している場合はこちらを使う

# Voxelammingアプリに表示されている部屋名を指定してください
room_name = "1000"
# Voxelammingクラスのインスタンスを生成します
voxelamming = Voxelamming(room_name)
# ボクセルの設定を行います
voxelamming.set_box_size(0.5)
voxelamming.set_build_interval(0.01)

# ボクセルを配置するため、位置と色を設定します
for i in range(10):
    voxelamming.create_box(-1, i, 0, r=0, g=1, b=1, alpha=1)
    voxelamming.create_box(0, i, 0, r=1, g=0, b=0, alpha=1)
    voxelamming.create_box(1, i, 0, r=1, g=1, b=0, alpha=1)
    voxelamming.create_box(2, i, 0, r=0, g=1, b=1, alpha=1)

for i in range(5):
    voxelamming.remove_box(0, i * 2 + 1, 0)
    voxelamming.remove_box(1, i * 2, 0)

voxelamming.send_data('box')  # ボクセルデータをアプリに送信します。

time.sleep(0.1)

voxelamming.transform(10, 0, 0, pitch=0, yaw=0, roll=0)
voxelamming.change_shape('sphere')
voxelamming.send_data('sphere')  # sphereのボクセルデータをアプリに送信します。

time.sleep(0.1)

voxelamming.transform(20, 0, 0, pitch=0, yaw=0, roll=0)
voxelamming.change_shape('plane')
# ボクセルデータをアプリに送信します。
voxelamming.send_data('plane')  # planeのボクセルデータをアプリに送信します。
