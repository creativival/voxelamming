require 'voxelamming'
# require_relative 'voxelamming'

room_name = '1000'
vox = Voxelamming::VoxelammingManager.new(room_name)
# vox = VoxelammingManager.new(room_name)

vox.set_box_size(0.5)
vox.set_build_interval(0.01)

for i in 0...100
  alpha = (100 - i) / 100.0
  vox.create_box(-1, i, 0, r: 0, g: 1, b: 1, alpha: alpha)
  vox.create_box(0, i, 0, r: 1, g: 0, b: 0, alpha: alpha)
  vox.create_box(1, i, 0, r: 1, g: 1, b: 0, alpha: alpha)
  vox.create_box(2, i, 0, r: 0, g: 1, b: 1, alpha: alpha)
end

for i in 0...50
  vox.remove_box(0, i * 2, 0)
  vox.remove_box(1, i * 2 + 1, 0)
end

vox.send_data(name: 'set_alpha_sample')
