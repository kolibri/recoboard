PI_HOST=pi@192.168.178.25

.PHONY: setup-rbpi
setup-rbpi:
	ssh $(PI_HOST) 'bash -s' < ./rbpi/setup.sh

.PHONY: create-stls
create-stls:
	rm -rf stls
	mkdir -p stls

	openscad scad/recoboard.scad -o stls/base_a1.stl  -D show_ground=true -D show_a1=true
	openscad scad/recoboard.scad -o stls/base_a8.stl  -D show_ground=true -D show_a8=true
	openscad scad/recoboard.scad -o stls/base_h1.stl  -D show_ground=true -D show_h1=true
	openscad scad/recoboard.scad -o stls/base_h8.stl  -D show_ground=true -D show_h8=true
	openscad scad/recoboard.scad -o stls/rc522_a1.stl -D show_rc522=true  -D show_a1=true
	openscad scad/recoboard.scad -o stls/rc522_a8.stl -D show_rc522=true  -D show_a8=true
	openscad scad/recoboard.scad -o stls/rc522_h1.stl -D show_rc522=true  -D show_h1=true
	openscad scad/recoboard.scad -o stls/rc522_h8.stl -D show_rc522=true  -D show_h8=true
	openscad scad/recoboard.scad -o stls/top_a1.stl   -D show_top=true    -D show_a1=true
	openscad scad/recoboard.scad -o stls/top_a8.stl   -D show_top=true    -D show_a8=true
	openscad scad/recoboard.scad -o stls/top_h1.stl   -D show_top=true    -D show_h1=true
	openscad scad/recoboard.scad -o stls/top_h8.stl   -D show_top=true    -D show_h8=true

	openscad scad/duponyx.scad -o stls/dupont_case_7.stl   -D count=7    -D solid=20
	openscad scad/duponyx.scad -o stls/dupont_case_8.stl   -D count=8    -D solid=20

#.PHONY: gcodes
#gcodes:
#	CURA_ENGINE_SEARCH_PATH=/usr/share/cura/resources/definitions CuraEngine slice -v -j cura_cr10v2.def.json -o test.gcode -l stls/top_a1.stl -s mesh_position_x=120 -s mesh_position_y=120 -s mesh_position_z=0