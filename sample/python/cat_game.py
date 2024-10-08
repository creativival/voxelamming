import pyxel
from voxelamming import Voxelamming
# from voxelamming_local import Voxelamming  # ローカルで開発している場合はこちらを使う


class Cat:
    def __init__(self, app):
        self.app = app
        self.name = 'cat_8x8'
        self.dot_data = (
            '-1 -1 9 -1 9 -1 -1 -1 -1 -1 9 9 9 9 -1 -1 '
            '-1 -1 9 0 9 0 9 -1 -1 -1 9 9 7 7 7 -1 -1 -1 '
            '9 9 9 -1 -1 -1 9 9 9 9 9 9 9 -1 -1 -1 9 9 7 '
            '-1 -1 -1 -1 9 9 -1 9 9 -1 -1'
        )
        self.direction = 0
        self.x = 0
        self.y = 0
        self.img = 0
        self.u = 0
        self.v = 0
        self.w = 8
        self.h = 8
        self.speed = 0.1  # 猫の移動速度
        self.diameter = 4  # 初期の猫のサイズ（円の直径）

    def chase(self, mouse):
        # 猫がマウスを追いかける
        if self.x < mouse.x:
            self.x += self.speed
            self.w = 8
            self.h = 8
            self.direction = 0
        elif self.x > mouse.x:
            self.x -= self.speed
            self.w = -8
            self.h = 8
            self.direction = -180  # 画像を反転させる

        if self.y < mouse.y:
            self.y += self.speed
        elif self.y > mouse.y:
            self.y -= self.speed

        # 猫のサイズを徐々に大きくする
        self.diameter += 0.05


class Mouse:
    def __init__(self, app):
        self.app = app
        self.name = 'mouse_8x8'
        self.dot_data = (
            '-1 -1 -1 -1 -1 -1 -1 -1 -1 13 -1 -1 13 -1 -1 -1 '
            '-1 13 13 13 -1 -1 -1 -1 -1 13 13 13 13 0 13 -1 '
            '13 13 13 13 13 13 13 0 -1 13 13 13 13 0 13 -1 '
            '-1 13 13 13 -1 -1 -1 -1 -1 13 -1 -1 13 -1 -1 -1'
        )
        self.direction = 0
        self.x = 20
        self.y = 0
        self.img = 0
        self.u = 0
        self.v = 8
        self.w = 8
        self.h = 8
        self.speed = 0.5  # マウスの移動速度
        self.diameter = 8  # マウスのサイズ（円の直径）

    def move(self):
        # 矢印キーでマウスを動かす
        if pyxel.btn(pyxel.KEY_LEFT):
            self.x -= self.speed
            self.u = 0
            self.v = 8
            self.w = -8
            self.h = 8
            self.direction = 180  # 180度回転させる
        if pyxel.btn(pyxel.KEY_RIGHT):
            self.x += self.speed
            self.u = 0
            self.v = 8
            self.w = 8
            self.h = 8
            self.direction = 0
        if pyxel.btn(pyxel.KEY_UP):
            self.y += self.speed
            self.u = 8
            self.v = 8
            self.w = 8
            self.h = 8
            self.direction = 90
        if pyxel.btn(pyxel.KEY_DOWN):
            self.y -= self.speed
            self.u = 8
            self.v = 8
            self.w = 8
            self.h = -8
            self.direction = -90

        # 画面内に動きを制限する
        self.x = max(-self.app.window_width // 2, min(self.app.window_width // 2, self.x))
        self.y = max(-self.app.window_height // 2, min(self.app.window_height // 2, self.y))


class App:
    def __init__(self):
        # Pyxelの初期化
        self.dot_size = 1  # AR空間で表示されるスプライトのドットのサイズ（センチメートル）
        self.window_width = int(64 * 4 / 3)  # ARウインドウの横幅はself.dot_sizeを掛けた値になる（センチメートル）
        self.window_height = 64  # ARウインドウの縦幅はself.dot_sizeを掛けた値になる（センチメートル）
        self.window_angle = 80  # ARウインドウの傾き（度）
        self.sprite_base_diameter = 8  # スプライトの基本直径（スプライトの送信スケールの基準値）
        self.cat = Cat(self)
        self.mouse = Mouse(self)
        self.game_started = False
        self.game_over = False
        self.score = 0  # 初期スコア
        self.last_score_update_time = 0  # スコアを更新するためのタイマー

        # Voxelammingの初期化
        self.vox = Voxelamming('1000')
        self.vox.set_box_size(self.dot_size)
        self.vox.set_game_screen(self.window_width, self.window_height, self.window_angle, red=1, green=1, blue=0, alpha=0.8)
        self.vox.set_game_score(self.score)
        cat_scale = self.cat.diameter / self.sprite_base_diameter
        mouse_scale = self.mouse.diameter / self.sprite_base_diameter
        self.vox.create_sprite(self.cat.name, self.cat.dot_data, self.cat.x, self.cat.y, self.cat.direction, cat_scale,
                               True)
        self.vox.create_sprite(self.mouse.name, self.mouse.dot_data, self.mouse.x, self.mouse.y, self.mouse.direction,
                               mouse_scale, True)
        self.vox.send_data()
        self.vox.clear_data()

        pyxel.init(self.window_width, self.window_height, title='Cat Game')

        pyxel.load('cat_game.pyxres')

        pyxel.run(self.update, self.draw)

    def update(self):
        if not self.game_started:
            if pyxel.btnp(pyxel.MOUSE_BUTTON_LEFT):
                self.reset_game()
            return

        if self.game_over:
            if pyxel.btnp(pyxel.MOUSE_BUTTON_LEFT):
                self.reset_game()
            return

        self.mouse.move()  # マウスの位置を更新
        self.cat.chase(self.mouse)  # 猫がマウスを追いかける

        # 衝突判定: 猫の円がマウスに触れるとゲームオーバー
        if ((self.cat.x - self.mouse.x) ** 2 + (self.cat.y - self.mouse.y) ** 2) < (
                self.cat.diameter / 2 + self.mouse.diameter / 2) ** 2:
            self.game_over = True

            # ゲームオーバーを送信（ウインドウを赤に変更）
            self.vox.set_box_size(self.dot_size)
            self.vox.set_game_screen(self.window_width, self.window_height, self.window_angle, red=1, green=0, blue=0, alpha=0.8)
            self.vox.set_game_score(self.score)
            self.vox.set_command('gameOver')
            self.vox.send_data()
            self.vox.clear_data()

        # スコアを1秒ごとに加算
        if pyxel.frame_count - self.last_score_update_time >= 30:  # PyxelのデフォルトFPSは30
            self.score += 1
            self.last_score_update_time = pyxel.frame_count

        # スプライトの情報を0.1秒ごとに送信
        if pyxel.frame_count - self.last_score_update_time >= 3:  # PyxelのデフォルトFPSは30
            if not self.game_over:  # ゲームオーバー直後に送信しないようにする
                self.vox.set_box_size(self.dot_size)
                self.vox.set_game_screen(self.window_width, self.window_height, self.window_angle, red=1, green=1, blue=0, alpha=0.5)
                self.vox.set_game_score(self.score)
                cat_scale = self.cat.diameter / self.sprite_base_diameter
                mouse_scale = self.mouse.diameter / self.sprite_base_diameter
                self.vox.move_sprite(self.cat.name, self.cat.x, self.cat.y, self.cat.direction, cat_scale, True)
                self.vox.move_sprite(self.mouse.name, self.mouse.x, self.mouse.y, self.mouse.direction, mouse_scale, True)
                self.vox.send_data()
                self.vox.clear_data()

    def draw(self):
        pyxel.cls(1)

        # スコアを左上に表示する
        pyxel.text(2, 2, f"Score: {self.score}", pyxel.COLOR_WHITE)

        if not self.game_started:
            pyxel.text(self.window_width // 2 - 26, self.window_height // 2 - 8, "Click to start",
                       pyxel.frame_count % 16)
            self.draw_cursor()  # カスタムカーソルの描画
            return

        if self.game_over:
            pyxel.text(self.window_width // 2 - 26, self.window_height // 2 - 8, "Game Over!", pyxel.frame_count % 16)
            pyxel.text(self.window_width // 2 - 26, self.window_height // 2 + 8, "Click to start",
                       pyxel.frame_count % 16)
            self.draw_cursor()  # カスタムカーソルの描画
            return

        # 徐々に大きくなる円を描画する
        cat_x, cat_y = self.get_sprite_position(self.cat.x, self.cat.y)
        pyxel.circ(cat_x + 4, cat_y + 4, self.cat.diameter / 2, pyxel.COLOR_RED)

        # 猫のスプライトを描画する
        pyxel.blt(cat_x, cat_y, self.cat.img, self.cat.u, self.cat.v, self.cat.w, self.cat.h, 1)

        # マウスのスプライトを描画する
        mouse_x, mouse_y = self.get_sprite_position(self.mouse.x, self.mouse.y)
        pyxel.blt(mouse_x, mouse_y, self.mouse.img, self.mouse.u, self.mouse.v, self.mouse.w, self.mouse.h, 1)

    def get_sprite_position(self, x, y):
        return self.window_width // 2 + x - 4, self.window_height // 2 - y - 4

    def reset_game(self):
        self.score = 0  # スコアをリセット
        self.last_score_update_time = pyxel.frame_count  # タイマーをリセット
        self.cat = Cat(self)  # 猫の初期化(位置、サイズ)
        self.mouse = Mouse(self)  # マウスの初期化(位置)
        self.game_started = True
        self.game_over = False

    @staticmethod
    def draw_cursor():
        cursor_x = pyxel.mouse_x
        cursor_y = pyxel.mouse_y
        pyxel.blt(cursor_x - 4, cursor_y - 4, 0, 0, 16, 8, 8, 1)


App()
