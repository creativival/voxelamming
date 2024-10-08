from time import sleep
# voxelammingパッケージからVoxelammingクラスをインポートします
from voxelamming import Voxelamming
# from voxelamming_local import Voxelamming  # ローカルで開発している場合はこちらを使う

texture_names = ["grass", "stone", "dirt", "planks", "bricks"]
# Voxelammingアプリに表示されている部屋名を指定してください
room_name = "1000"
# Voxelammingクラスのインスタンスを生成します
vox = Voxelamming(room_name)

# ボクセルの設定を行います
vox.set_box_size(1)
vox.set_build_interval(0.01)

# ボクセルを配置するため、位置と色を設定します
for i, texture in enumerate(texture_names):
    vox.create_box(0, len(texture_names) - i - 1, 0, texture=texture)

# ボクセルデータをアプリに送信します。
vox.send_data()
# ボクセルデータをクリアします。
vox.clear_data()
sleep(0.1)

# ボクセルの設定を行います
vox.set_box_size(1)
vox.set_build_interval(0.01)
vox.change_shape('sphere')

# ボクセルを配置するため、位置と色を設定します
for i, texture in enumerate(texture_names):
    vox.create_box(1, len(texture_names) - i - 1, 0, texture=texture)

# ボクセルデータをアプリに送信します。
vox.send_data()
# ボクセルデータをクリアします。
vox.clear_data()
sleep(0.1)

# ボクセルの設定を行います
vox.set_box_size(1)
vox.set_build_interval(0.01)
vox.change_shape('plane')

# ボクセルを配置するため、位置と色を設定します
for i, texture in enumerate(texture_names):
    vox.create_box(2, len(texture_names) - i - 1, 0, texture=texture)

# ボクセルデータをアプリに送信します。
vox.send_data()
