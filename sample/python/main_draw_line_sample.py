import time
from build_box import BuildBox

room_name = "1000"
build_box = BuildBox(room_name)

build_box.set_box_size(0.5)
build_box.set_build_interval(0.01)
# build_box.set_command('float')

build_box.draw_line(0, 0, 0, 5, 10, 20, r=1, g=0, b=0, alpha=1)
build_box.send_data()

build_box.send_data()
