require 'json'
require 'faye/websocket'
require 'eventmachine'
require 'date'
require_relative 'matrix_util'

class VoxelammingManager
  @@texture_names = ["grass", "stone", "dirt", "planks", "bricks"]
  @@model_names = ["Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune", "Pluto", "Sun",
    "Moon", "ToyBiplane", "ToyCar", "Drummer", "Robot", "ToyRocket", "RocketToy1", "RocketToy2", "Skull"]

  def initialize(room_name)
    @room_name = room_name
    @is_allowed_matrix = 0
    @saved_matrices = []
    @node_transform = [0, 0, 0, 0, 0, 0]
    @matrix_transform = [0, 0, 0, 0, 0, 0]
    @frame_transforms = []
    @global_animation = [0, 0, 0, 0, 0, 0, 1, 0]
    @animation = [0, 0, 0, 0, 0, 0, 1, 0]
    @boxes = []
    @frames = []
    @sentences = []
    @lights = []
    @commands = []
    @models = []
    @model_moves = []
    @sprites = []
    @sprite_moves = []
    @game_score = []
    @game_screen = []  # width, height, angle=90, red=1, green=1, blue=1, alpha=0.5
    @size = 1
    @shape = 'box'
    @is_metallic = 0
    @roughness = 0.5
    @is_allowed_float = 0
    @build_interval = 0.01
    @is_framing = false
    @frame_id = 0
    @websocket = nil
    @last_sent_time = nil
    @timer = nil
  end

  def clear_data
    @is_allowed_matrix = 0
    @saved_matrices = []
    @node_transform = [0, 0, 0, 0, 0, 0]
    @matrix_transform = [0, 0, 0, 0, 0, 0]
    @frame_transforms = []
    @global_animation = [0, 0, 0, 0, 0, 0, 1, 0]
    @animation = [0, 0, 0, 0, 0, 0, 1, 0]
    @boxes = []
    @frames = []
    @sentences = []
    @sprites = []
    @sprite_moves = []
    @game_score = []
    @game_screen = []  # width, height, angle=90, red=1, green=1, blue=1, alpha=0.5
    @lights = []
    @commands = []
    @models = []
    @model_moves = []
    @size = 1
    @shape = 'box'
    @is_metallic = 0
    @roughness = 0.5
    @is_allowed_float = 0
    @build_interval = 0.01
    @is_framing = false
    @frame_id = 0
  end

  def set_frame_fps(fps = 2)
    @commands << "fps #{fps}"
  end

  def set_frame_repeats(repeats = 10)
    @commands << "repeats #{repeats}"
  end

  def frame_in
    @is_framing = true
  end

  def frame_out
    @is_framing = false
    @frame_id += 1
  end

  def push_matrix
    @is_allowed_matrix += 1
    @saved_matrices.push(@matrix_transform)
  end

  def pop_matrix
    @is_allowed_matrix -= 1
    @matrix_transform = @saved_matrices.pop
  end

  def transform(x, y, z, pitch: 0, yaw: 0, roll: 0)
    if @is_allowed_matrix > 0
      # 移動用のマトリックスを計算する
      matrix = @saved_matrices.last
      puts "before matrix: #{matrix}"
      base_position = matrix[0..2]

      if matrix.length == 6
        base_rotation_matrix = get_rotation_matrix(matrix[3], matrix[4], matrix[5])
      else
        base_rotation_matrix = [matrix[3..5], matrix[6..8], matrix[9..11]]
      end

      # Compute the new position after transform
      add_x, add_y, add_z = transform_point_by_rotation_matrix([x, y, z], transpose_3x3(base_rotation_matrix))
      x, y, z = add_vectors(base_position, [add_x, add_y, add_z])
      x, y, z = round_numbers([x, y, z])

      # Compute the rotation after transform
      transform_rotation_matrix = get_rotation_matrix(-pitch, -yaw, -roll)
      rotate_matrix = matrix_multiply(transform_rotation_matrix, base_rotation_matrix)
      @matrix_transform = [x, y, z, *rotate_matrix[0], *rotate_matrix[1], *rotate_matrix[2]]
    else
      x, y, z = round_numbers([x, y, z])

      if @is_framing
        @frame_transforms.append([x, y, z, pitch, yaw, roll, @frame_id])
      else
        @node_transform = [x, y, z, pitch, yaw, roll]
      end
    end
  end

  def create_box(x, y, z, r: 1, g: 1, b: 1, alpha: 1, texture: '')
    if @is_allowed_matrix > 0
      # 移動用のマトリックスにより位置を計算する
      matrix = @matrix_transform
      base_position = matrix[0..2]

      if matrix.length == 6
        base_rotation_matrix = get_rotation_matrix(matrix[3], matrix[4], matrix[5])
      else
        base_rotation_matrix = [matrix[3..5], matrix[6..8], matrix[9..11]]
      end

      # Compute the new position after transform
      add_x, add_y, add_z = transform_point_by_rotation_matrix([x, y, z], transpose_3x3(base_rotation_matrix))
      x, y, z = add_vectors(base_position, [add_x, add_y, add_z])
    end

    x, y, z = round_numbers([x, y, z])
    r, g, b, alpha = round_two_decimals([r, g, b, alpha])

    # 重ねておくことを防止
    remove_box(x, y, z)
    if !@@texture_names.include?(texture)
      texture_id = -1
    else
      texture_id = @@texture_names.index(texture)
    end

    if @is_framing
      @frames.append([x, y, z, r, g, b, alpha, texture_id, @frame_id])
    else
      @boxes.append([x, y, z, r, g, b, alpha, texture_id])
    end
  end

  def remove_box(x, y, z)
    x, y, z = round_numbers([x, y, z])

    if @is_framing
      @frames.reject! { |frame| frame[0] == x && frame[1] == y && frame[2] == z && frame[8] == @frame_id }
    else
      @boxes.reject! { |box| box[0] == x && box[1] == y && box[2] == z }
    end
  end

  def animate_global(x, y, z, pitch: 0, yaw: 0, roll: 0, scale: 1, interval: 10)
    x, y, z = round_numbers([x, y, z])
    @global_animation = [x, y, z, pitch, yaw, roll, scale, interval]
  end

  def animate(x, y, z, pitch: 0, yaw: 0, roll: 0, scale: 1, interval: 10)
    x, y, z = round_numbers([x, y, z])
    @animation = [x, y, z, pitch, yaw, roll, scale, interval]
  end

  def set_box_size(box_size)
    @size = box_size
  end

  def set_build_interval(interval)
    @build_interval = interval
  end

  def write_sentence(sentence, x, y, z, r: 1, g: 1, b: 1, alpha: 1, font_size: 8, is_fixed_width: false)
    x, y, z = round_numbers([x, y, z]).map(&:to_s)
    r, g, b, alpha = round_two_decimals([r, g, b, alpha])
    r, g, b, alpha, font_size =  [r, g, b, alpha, font_size].map(&:floor).map(&:to_s)
    @sentences << [sentence, x, y, z, r, g, b, alpha, font_size, is_fixed_width ? "1" : "0"]
  end

  def set_light(x, y, z, r: 1, g: 1, b: 1, alpha: 1, intensity: 1000, interval: 1, light_type: 'point')
    x, y, z = round_numbers([x, y, z])
    r, g, b, alpha = round_two_decimals([r, g, b, alpha])

    if light_type == 'point'
      light_type = 1
    elsif light_type == 'spot'
      light_type = 2
    elsif light_type == 'directional'
      light_type = 3
    else
      light_type = 1
    end
    @lights << [x, y, z, r, g, b, alpha, intensity, interval, light_type]
  end

  def set_command(command)
    @commands << command

    if command == 'float'
      @is_allowed_float = 1
    end
  end

  def draw_line(x1, y1, z1, x2, y2, z2, r: 1, g: 1, b: 1, alpha: 1)
    x1, y1, z1, x2, y2, z2 = [x1, y1, z1, x2, y2, z2].map(&:floor)
    diff_x = x2 - x1
    diff_y = y2 - y1
    diff_z = z2 - z1
    max_length = [diff_x.abs, diff_y.abs, diff_z.abs].max

    return false if diff_x == 0 && diff_y == 0 && diff_z == 0

    if diff_x.abs == max_length
      if x2 > x1
        (x1..x2).each do |x|
          y = y1 + (x - x1) * diff_y.to_f / diff_x
          z = z1 + (x - x1) * diff_z.to_f / diff_x
          create_box(x, y, z, r: r, g: g, b: b, alpha: alpha)
        end
      else
        x1.downto(x2 + 1) do |x|
          y = y1 + (x - x1) * diff_y.to_f / diff_x
          z = z1 + (x - x1) * diff_z.to_f / diff_x
          create_box(x, y, z, r: r, g: g, b: b, alpha: alpha)
        end
      end
    elsif diff_y.abs == max_length
      if y2 > y1
        (y1..y2).each do |y|
          x = x1 + (y - y1) * diff_x.to_f / diff_y
          z = z1 + (y - y1) * diff_z.to_f / diff_y
          create_box(x, y, z, r: r, g: g, b: b, alpha: alpha)
        end
      else
        y1.downto(y2 + 1) do |y|
          x = x1 + (y - y1) * diff_x.to_f / diff_y
          z = z1 + (y - y1) * diff_z.to_f / diff_y
          create_box(x, y, z, r: r, g: g, b: b, alpha: alpha)
        end
      end
    elsif diff_z.abs == max_length
      if z2 > z1
        (z1..z2).each do |z|
          x = x1 + (z - z1) * diff_x.to_f / diff_z
          y = y1 + (z - z1) * diff_y.to_f / diff_z
          create_box(x, y, z, r: r, g: g, b: b, alpha: alpha)
        end
      else
        z1.downto(z2 + 1) do |z|
          x = x1 + (z - z1) * diff_x.to_f / diff_z
          y = y1 + (z - z1) * diff_y.to_f / diff_z
          create_box(x, y, z, r: r, g: g, b: b, alpha: alpha)
        end
      end
    end
  end

  def change_shape(shape)
    @shape = shape
  end

  def change_material(is_metallic: false, roughness: 0.5)
    @is_metallic = is_metallic ? 1 : 0
    @roughness = roughness
  end

  def create_model(model_name, x: 0, y: 0, z: 0, pitch: 0, yaw: 0, roll: 0, scale: 1, entity_name: '')
    if @@model_names.include?(model_name)
      x, y, z, pitch, yaw, roll, scale = round_two_decimals([x, y, z, pitch, yaw, roll, scale])
      x, y, z, pitch, yaw, roll, scale = [x, y, z, pitch, yaw, roll, scale].map(&:to_s)

      @models << [model_name, x, y, z, pitch, yaw, roll, scale, entity_name]
    else
      puts "No model name: #{model_name}"
    end
  end

  def move_model(entity_name, x: 0, y: 0, z: 0, pitch: 0, yaw: 0, roll: 0, scale: 1)
    x, y, z, pitch, yaw, roll, scale = round_two_decimals([x, y, z, pitch, yaw, roll, scale])
    x, y, z, pitch, yaw, roll, scale = [x, y, z, pitch, yaw, roll, scale].map(&:to_s)

    @model_moves << [entity_name, x, y, z, pitch, yaw, roll, scale]
  end

  # Game API

  def set_game_screen(width, height, angle = 90, r = 1, g = 1, b = 0, alpha = 0.5)
    @game_screen = [width, height, angle, r, g, b, alpha]
  end

  def set_game_score(score, x = 0, y = 0)
    score, x, y = [score, x, y].map(&:to_f)
    @game_score = [score, x, y]
  end

  def send_game_over
    @commands << 'gameOver'
  end

  def send_game_clear
    @commands << 'gameClear'
  end

  def set_rotation_style(sprite_name, rotation_style = 'all around')
    @rotation_styles[sprite_name] = rotation_style
  end

  # スプライトの作成と表示について、テンプレートとクローンの概念を導入する
  # テンプレートはボクセルの集合で、標準サイズは8x8に設定する
  # この概念により、スプライトの複数作成が可能となる（敵キャラや球など）
  # スプライトは、ボクセラミングアプリ上で、テンプレートとして作成される（isEnable=falseにより表示されない）
  # スプライトは、テンプレートのクローンとして画面上に表示される
  # 送信ごとに、クローンはすべて削除されて、新しいクローンが作成される
  # 上記の仕様により、テンプレートからスプライトを複数作成できる

  # スプライトのテンプレートを作成（スプライトは配置されない）
  def create_sprite_template(sprite_name, color_list)
    @sprites << [sprite_name, color_list]
  end

  # スプライトのテンプレートを使って、複数のスプライトを表示する
  def display_sprite_template(sprite_name, x, y, direction = 0, scale = 1)
    # x, y, directionを丸める
    x, y, direction = round_numbers([x, y, direction])
    x, y, direction, scale = [x, y, direction, scale].map(&:to_s)

    # rotation_styleを取得
    if @rotation_styles[sprite_name]
      rotation_style = @rotation_styles[sprite_name]

      # rotation_styleが変更された場合、新しいスプライトデータを配列に追加
      if rotation_style == 'left-right'
        direction_mod = direction.to_i % 360  # 常に0から359の範囲で処理（常に正の数になる）
        if direction_mod > 90 && direction_mod < 270
          direction = "-180"  # -180は左右反転するようにボクセラミング側で実装されている
        else
          direction = "0"
        end
      elsif rotation_style == "don't rotate"
        direction = "0"
      else
        direction = direction.to_s
      end
    else
      direction = direction.to_s
    end

    # sprite_moves 配列から指定されたスプライト名の情報を検索
    matching_sprites = @sprite_moves.select { |info| info[0] == sprite_name }

    # スプライトの移動データを保存または更新
    if matching_sprites.empty?
      @sprite_moves.push([sprite_name, x, y, direction, scale])
    else
      index = @sprite_moves.index(matching_sprites[0])
      @sprite_moves[index] += [x, y, direction, scale]
    end
  end

  # 通常のスプライトの作成
  def create_sprite(sprite_name, color_list, x = 0, y = 0, direction = 0, scale = 1, visible = true)
    # スプライトのテンプレートデータを配列に追加
    create_sprite_template(sprite_name, color_list)

    # スプライトの移動データを配列に追加
    if visible || !(x == 0 && y == 0 && direction == 0 && scale == 1)
      x, y, direction = round_numbers([x, y, direction])
      x, y, direction, scale = [x, y, direction, scale].map(&:to_s)
      @sprite_moves.push([sprite_name, x, y, direction, scale])
    end
  end

  # 通常のスプライトの移動
  def move_sprite(sprite_name, x, y, direction = 0, scale = 1, visible = true)
    if visible
      display_sprite_template(sprite_name, x, y, direction, scale)
    end
  end

  # スプライトクローンの移動
  def move_sprite_clone(sprite_name, x, y, direction = 0, scale = 1)
    display_sprite_template(sprite_name, x, y, direction, scale)
  end

  # ドット（弾）を表示する
  def display_dot(x, y, direction = 0, color_id = 10, width = 1, height = 1)
    template_name = "dot_#{color_id}_#{width}_#{height}"
    display_sprite_template(template_name, x, y, direction, 1)
  end

  # テキストを表示する
  def display_text(text, x, y, direction = 0, scale = 1, color_id = 7, is_vertical = false, align = '')
    text_format = ''
    align = align.downcase  # 破壊的メソッドの代わりに非破壊的メソッドを使用

    text_format += 't' if align.include?('top')
    text_format += 'b' if align.include?('bottom')
    text_format += 'l' if align.include?('left')
    text_format += 'r' if align.include?('right')

    text_format += is_vertical ? 'v' : 'h'

    template_name = "text_#{text}_#{color_id}_#{text_format}"
    display_sprite_template(template_name, x, y, direction, scale)
  end

  def send_data(name: '')
    puts 'send_data'
    now = DateTime.now
    data_to_send = {
      "nodeTransform": @node_transform,
      "frameTransforms": @frame_transforms,
      "globalAnimation": @global_animation,
      "animation": @animation,
      "boxes": @boxes,
      "frames": @frames,
      "sentences": @sentences,
      "lights": @lights,
      "commands": @commands,
      "models": @models,
      "modelMoves": @model_moves,
      "sprites": @sprites,
      "spriteMoves": @sprite_moves,
      "gameScore": @game_score,
      "gameScreen": @game_screen,
      "size": @size,
      "shape": @shape,
      "interval": @build_interval,
      "isMetallic": @is_metallic,
      "roughness": @roughness,
      "isAllowedFloat": @is_allowed_float,
      "name": name,
      "date": now.to_s
    }.to_json

    EM.run do
      if @websocket.nil?
        @websocket = Faye::WebSocket::Client.new('wss://websocket.voxelamming.com')

        @websocket.on :open do |_event|
          p [:open]
          puts 'WebSocket connection open'
          @websocket.send(@room_name)
          puts "Joined room: #{@room_name}"
          send_data_to_server(data_to_send)
        end

        @websocket.on :error do |event|
          puts "WebSocket error: #{event.message}"
          EM.stop
        end

        @websocket.on :close do |_event|
          puts 'WebSocket connection closed'
          EM.stop
        end
      else
        send_data_to_server(data_to_send)
      end
    end
  end

  def send_data_to_server(data)
    if @websocket && @websocket.ready_state == Faye::WebSocket::API::OPEN
      @websocket.send(data)
      puts 'Sent data to server'
      @last_sent_time = Time.now

      reset_close_timer
    end
  end

  def reset_close_timer
    EM.cancel_timer(@timer) if @timer

    @timer = EM.add_timer(2) do
      if Time.now - @last_sent_time >= 2
        close_connection
      end
    end
  end

  def close_connection
    if @websocket
      puts 'Closing WebSocket connection.'
      @websocket.close
      @websocket = nil
      EM.stop
    end
  end

  def round_numbers(num_list)
    if @is_allowed_float == 1
      round_two_decimals(num_list)
    else
      num_list.map { |val| val.round(1).floor }
    end
  end

  def round_two_decimals(num_list)
    num_list.map { |val| val.round(2) }
  end
end
