require 'voxelamming_gem'

room_name = '1000'
build_box = VoxelammingGem::BuildBox.new(room_name)

build_box.set_box_size(0.5)
build_box.set_build_interval(0.01)

build_box.translate(0, 16, 0, pitch: 0, yaw: 0, roll: 0)
build_box.write_sentence("Hello World", 0, 0, 0, r: 1, g: 0, b: 0, alpha: 1)
build_box.send_data()

sleep(1)

build_box.translate(0, 0, 0, pitch: 0, yaw: 0, roll: 0)
build_box.write_sentence("こんにちは", 0, 0, 0, r: 0, g: 1, b: 0, alpha: 1)
build_box.send_data()
