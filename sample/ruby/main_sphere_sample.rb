require 'voxelamming_gem'

room_name = '1000'
build_box = VoxelammingGem::BuildBox.new(room_name)

build_box.set_box_size(0.5)
build_box.set_build_interval(0.01)

radius = 11

build_box.set_box_size(0.5)
build_box.set_build_interval(0.01)
build_box.translate(0, radius, 0, pitch: 0, yaw: 0, roll: 0)

for i in -radius...radius + 1
  for j in -radius...radius + 1
    for k in -radius...radius + 1
      if ((radius -1 ) ** 2 <= i ** 2 + j ** 2 + k ** 2) and (i ** 2 + j ** 2 + k ** 2 < radius ** 2)
        puts i, j, k
        build_box.create_box(i, j, k, r: 0, g: 1, b: 1)
      end
    end
  end
end

build_box.send_data()
