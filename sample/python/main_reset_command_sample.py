from time import sleep
# voxelammingパッケージからBuildBoxクラスをインポートします
from voxelamming import BuildBox
from ply_util import get_boxes_from_ply

# 変数の設定
animation_settings = [
    {
        'model': 'frog1.ply',
        'position': [0, 0, 0, 0, 0, 0],
    },
    {
        'model': 'frog2.ply',
        'position': [0, 0, 0, 0, 0, 0],
    },
    {
        'model': 'frog3.ply',
        'position': [0, 0, 0, 0, 0, 0],
    },
    {
        'model': 'frog4.ply',
        'position': [0, 5, 0, 0, 0, 0],
    },
    {
        'model': 'frog5.ply',
        'position': [0, 10, 0, 0, 0, 0],
    },
    {
        'model': 'frog4.ply',
        'position': [0, 5, 0, 0, 0, 0],
    },
    {
        'model': 'frog3.ply',
        'position': [0, 0, 0, 0, 0, 0],
    },
    {
        'model': 'frog2.ply',
        'position': [0, 0, 0, 0, 0, 0],
    },
]

# Voxelammingアプリに表示されている部屋名を指定してください
room_name = "1000"
# BuildBoxクラスのインスタンスを生成します
build_box = BuildBox(room_name)

for _ in range(3):
    for i in range(len(animation_settings)):
        model = animation_settings[i]['model']
        position = animation_settings[i]['position']

        for box in get_boxes_from_ply(model):
            build_box.create_box(*box)

        build_box.set_box_size(0.5)
        build_box.set_build_interval(0)
        build_box.translate(*position)
        build_box.send_data()
        sleep(0.5)

        build_box.clear_data()
        build_box.set_command('reset')
        build_box.send_data()
        build_box.clear_data()
        sleep(0.5)
