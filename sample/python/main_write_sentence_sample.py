# voxelammingパッケージからVoxelammingクラスをインポートします
from voxelamming import Voxelamming
# from voxelamming_local import Voxelamming  # ローカルで開発している場合はこちらを使う


# Voxelammingアプリに表示されている部屋名を指定してください
room_name = "1000"
# Voxelammingクラスのインスタンスを生成します
vox = Voxelamming(room_name)
# ボクセルの設定を行います
vox.set_box_size(0.5)
vox.set_build_interval(0.01)

# ボクセルを配置するため、位置と色を設定します
# フォントサイズは、8, 12, 16, 24から選びます
# is_fixed_widthをTrueにすると、文字間隔が固定されます
vox.write_sentence("Voxel", 0, 130, 0, r=1, g=0, b=1, alpha=1, font_size=24)
vox.write_sentence("Voxel", 0, 106, 0, r=1, g=0, b=1, alpha=1, font_size=24, is_fixed_width=True)
vox.write_sentence("Hello World", 0, 90, 0, r=1, g=0, b=0, alpha=1, font_size=16)
vox.write_sentence("Hello World", 0, 64, 0, r=1, g=0, b=0, alpha=1, font_size=16, is_fixed_width=True)
vox.write_sentence("こんにちは", 0, 48, 0, r=0, g=1, b=0, alpha=1, font_size=12)
vox.write_sentence("こんにちは", 0, 32, 0, r=0, g=1, b=0, alpha=1, font_size=12, is_fixed_width=True)
vox.write_sentence("今日は", 0, 16, 0, r=0, g=0, b=1, alpha=1, font_size=8)
vox.write_sentence("今日は", 0, 0, 0, r=0, g=0, b=1, alpha=1, font_size=8, is_fixed_width=True)
# ボクセルデータをアプリに送信します。
vox.send_data("write_sentence")
