from math import floor
# voxelammingパッケージからVoxelammingクラスをインポートします
from voxelamming import Voxelamming
# from voxelamming_local import Voxelamming  # ローカルで開発している場合はこちらを使う

stone_base = [
    [1, 33, 36],
    [2, 31, 34],
    [3, 29, 32],
    [4, 27, 30],
    [5, 27, 30],
    [6, 25, 28],
    [7, 25, 28],
]
white_wall = [
    [8, 23, 26],
    [9, 23, 26],
    [10, 23, 26],
    [11, 23, 26],
    [12, 23, 26],
    [15, 17, 20],
    [16, 17, 20],
    [17, 17, 20],
    [21, 11, 14],
    [22, 11, 14],
    [23, 11, 14],
    [24, 11, 14],
]
red_roof = [
    [12, 27, 30],
    [12, 25, 28],
    [13, 23, 26],
    [13, 21, 24],
    [14, 19, 22],
    [18, 21, 24],
    [18, 19, 22],
    [19, 17, 20],
    [19, 15, 18],
    [20, 13, 16],
    [25, 15, 18],
    [25, 13, 16],
    [26, 11, 14],
    [26, 9, 12],
    [27, 7, 10],
    [28, 5, 8],
    [29, 3, 6],
    [30, 1, 4],
]
yellow_fish = [
    [31, 0, -2],
    [31, 0, 1],
    [32, 0, -3],
    [32, 0, 2]
]
roof_edge = [
    [13, -13, -15],
    [13, -13, 14],
    [13, 13, -15],
    [13, 13, 14],
    [19, -10, -12],
    [19, -10, 11],
    [19, 10, -12],
    [19, 10, 11],
    [26, -7, -9],
    [26, -7, 8],
    [26, 7, -9],
    [26, 7, 8],
]

castle = {
    "stone_base": {
        "color": [0.5, 0.5, 0.5],
        "size": stone_base
    },
    "white_wall": {
        "color": [1, 1, 1],
        "size": white_wall
    },
    "red_roof": {
        "color": [1, 0, 0],
        "size": red_roof
    }
}


def draw_square(voxelamming, w, d, h, r, g, b):
    for i in range(-floor(w / 2), floor(w / 2) + 1):
        for j in [-floor(d / 2), floor(d / 2) - 1]:
            vox.create_box(i, h, j, r=r, g=g, b=b, alpha=1)
    for i in range(-floor(d / 2), floor(d / 2)):
        for j in [-floor(w / 2), floor(w / 2)]:
            vox.create_box(j, h, i, r=r, g=g, b=b, alpha=1)


def main():
    # Voxelammingアプリに表示されている部屋名を指定してください
    room_name = "1000"
    # Voxelammingクラスのインスタンスを生成します
    vox = Voxelamming(room_name)
    vox.set_box_size(0.3)
    vox.set_build_interval(0.001)

    #   vox.set_command('japaneseCastle')

    # ボクセルを配置するため、位置と色を設定します
    for key in castle:
        color = castle[key]["color"]
        size = castle[key]["size"]
        for s in size:
            w = s[1]
            d = s[2]
            h = s[0]
            draw_square(voxelamming, w, d, h, color[0], color[1], color[2])

    for p in yellow_fish:
        vox.create_box(p[1], p[0], p[2], r=1, g=1, b=0, alpha=1)

    for p in roof_edge:
        vox.remove_box(p[1], p[0] - 1, p[2])
        vox.create_box(p[1], p[0], p[2], r=1, g=0, b=0, alpha=1)

    # ボクセルデータをアプリに送信します。
    vox.send_data("japanese_castle")


main()
