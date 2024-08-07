require 'voxelamming_gem'
require_relative 'ply_util'

room_name = "1000"
build_box = VoxelammingGem::BuildBox.new(room_name)

animation_settings = [
    {
        model: 'frog1.ply',
        position: [0, 0, 0, 0, 0, 0],
    },
    {
        model: 'frog2.ply',
        position: [0, 0, 0, 0, 0, 0],
    },
    {
        model: 'frog3.ply',
        position: [0, 0, 0, 0, 0, 0],
    },
    {
        model: 'frog4.ply',
        position: [0, 5, 0, 0, 0, 0],
    },
    {
        model: 'frog5.ply',
        position: [0, 10, 0, 0, 0, 0],
    },
    {
        model: 'frog4.ply',
        position: [0, 5, 0, 0, 0, 0],
    },
    {
        model: 'frog3.ply',
        position: [0, 0, 0, 0, 0, 0],
    },
    {
        model: 'frog2.ply',
        position: [0, 0, 0, 0, 0, 0],
    },
]

3.times do
  animation_settings.each do |setting|
    model = setting[:model]
    position = setting[:position]

    boxes = get_boxes_from_ply(model)
    boxes.each do |b|
      build_box.create_box(b[0], b[1], b[2], r: b[3], g: b[4], b: b[5])
    end

    build_box.set_box_size(0.5)
    build_box.set_build_interval(0)
    build_box.translate(*position)
    build_box.send_data
    sleep(0.5)

    build_box.clear_data
    build_box.set_command('reset')
    build_box.send_data
    build_box.clear_data
    sleep(0.5)
  end
end
