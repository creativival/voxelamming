require 'voxelamming_gem'

room_name = '1000'
build_box = VoxelammingGem::BuildBox.new(room_name)

build_box.set_box_size(0.5)
build_box.set_build_interval(0.01)

build_box.draw_line(0, 0, 0, 5, 10, 20, r: 1, g: 0, b: 0, alpha: 1)

build_box.send_data()
