z_distance = 0;
xy_distance = 0;

show_ground = false;
show_rc522 = false;
show_top = false;

show_bottom_left = false;
show_bottom_right = false;
show_top_left = false;
show_top_right = false;

module recoboard(side)
{
    size = 4;
    field_width = 60;
    rc522_width = 39.4;
    rc522_height = 5.5;
    plate_height = 1.2;


        pcb_mount = 6;
        pcb_height = 6;
        pcb_width = 50.2;
        pcb_length = 70.5;
        pcb_screw_d = 2.75;
        pin_height = 15;
        cable_corner = 5;
        ground_height = plate_height + pcb_mount + pcb_height + pin_height + cable_corner;
        total_height = ground_height + plate_height + rc522_height + plate_height;
        wall_width = 4.8;
            inner_walls_height = plate_height + pcb_mount + pcb_height + pin_height + cable_corner;

    module ground()
    {

        module mount_screw_hole(height)
        {
            difference(){
                cylinder(h=height, r=pcb_screw_d + 3, $fn=4);
                cylinder(h=height, r=pcb_screw_d, $fn=16);
            }
        }
        module mount_screw_holes(distance_x, distance_y, thickness)
        {
            translate([0,0,0]) {
                mount_screw_hole(pcb_mount);
            }
            translate([distance_x,0,0]) {    
                mount_screw_hole(pcb_mount);
            }
            translate([0,distance_y,0]) {    
                mount_screw_hole(pcb_mount);
            }
            translate([distance_x,distance_y,0]) {    
                mount_screw_hole(pcb_mount);
            }

        }

        module expander_mount(){

            mount_thickness = pcb_screw_d + 2;
            mount_x_screw = 45.5;
            mount_y_screw = 65.2;
            add = 7;
            add_plate_x = (field_width - mount_x_screw) / 2 + field_width / 2;
            add_plate_y = (field_width - mount_y_screw) / 2 + field_width / 2;

            translate([add_plate_x - 30 + add,            add_plate_y - 30 + add,            0]) cube([30, 30, plate_height]);
            translate([add_plate_x + mount_x_screw - add, add_plate_y - 30 + add,            0]) cube([30, 30, plate_height]);
            translate([add_plate_x - 30 + add,            add_plate_y + mount_y_screw - add, 0]) cube([30, 30, plate_height]);
            translate([add_plate_x + mount_x_screw - add, add_plate_y + mount_y_screw - add, 0]) cube([30, 30, plate_height]);

            translate([add_plate_x, add_plate_y, plate_height]) mount_screw_holes(mount_x_screw, mount_y_screw);
            
        }

        module pi_mount()
        {
            mount_thickness = pcb_screw_d + 2;
            mount_x_screw = 48.5;
            mount_y_screw = 57.5;

            add = 7;
            add_plate_x = 3.5;
            add_plate_y = (field_width - mount_y_screw) / 2 + field_width / 2;

            translate([add_plate_x + mount_x_screw - add, add_plate_y - 30 + add,            0]) cube([add*2, 30, plate_height]);
            translate([add_plate_x + mount_x_screw - add, add_plate_y + mount_y_screw - add, 0]) cube([add*2, 30, plate_height]);

            translate([add_plate_x, add_plate_y, plate_height]) mount_screw_holes(mount_x_screw, mount_y_screw);

        }

        module wall_left()
        {
            translate([-1 * wall_width / 2, 0, 0])
            cube([wall_width / 2, field_width * size, total_height]);

        }
        module wall_right()
        {
            translate([field_width * size, 0, 0])
            cube([wall_width / 2, field_width * size, total_height]);
        }
        module wall_top()
        {
            top_y_addition = 10;

            translate([-1 * wall_width/2, field_width * size, 0]) {
                difference(){
                    cube([field_width * size + wall_width, top_y_addition, total_height]);
                    
                    translate([wall_width/2, wall_width/2, plate_height])
                        cube([field_width * size, top_y_addition - wall_width, total_height - plate_height]);


                    for(x = [0:size - 1]) {
                        translate([x * field_width + wall_width/2, 0, total_height - plate_height]) {
                            real_field_indicator();
                        }
                    }
                }

            }
        }
        module wall_bottom()
        {
            translate([-1* wall_width / 2, -1 * wall_width / 2, 0])
            cube([field_width * size + wall_width, wall_width / 2, total_height]);
        }

        module side_bottom_left()
        {
            module pi_connectors()
            {
                translate([
                    -1 * wall_width / 2, 
                    field_width * 2 + (field_width * 2 - 57.5 - 14) / 2,
                    plate_height
                    ])
                cube([wall_width*2, 57.5 + 14, 100]);
            }

            difference() {
                wall_left();
                pi_connectors();
            }

            wall_bottom();

            translate([0, field_width * size / 2, 0]) pi_mount();

            difference(){
                base();
                pi_connectors();
            }

        }
        module side_top_left()
        {
            wall_left();
            wall_top();
            base();
        }
        module side_top_right()
        {
            wall_right();
            wall_top();

            translate([0, 0, 0]) expander_mount();
            translate([0, field_width * size / 2, 0]) expander_mount();

            base();
        }
        module side_bottom_right()
        {
            wall_right();
            wall_bottom();

            translate([0, 0, 0]) expander_mount();
            translate([0, field_width * size / 2, 0]) expander_mount();

            base();
        }

        module main(){


            module inner_walls()
            {
                translate([0, 0 , 0])
                cube([wall_width / 2, field_width * size, inner_walls_height]);
                translate([(field_width * size / 2) - wall_width / 2, 0 , 0])
                cube([wall_width, field_width * size, inner_walls_height]);
                translate([(field_width * size) - wall_width / 2, 0 , 0])
                cube([wall_width/2, field_width * size, inner_walls_height]);


                translate([0, 0 , 0])
                cube([field_width * size, wall_width/2, inner_walls_height]);
                translate([0, (field_width * size / 2) - wall_width / 2 , 0])
                cube([field_width * size, wall_width, inner_walls_height]);
                translate([0, (field_width * size) - wall_width / 2 , 0])
                cube([field_width * size, wall_width / 2, inner_walls_height]);
            }

            difference(){
                inner_walls();

                translate([field_width / 2, 0, 0]){
                    cube([field_width, field_width * size, inner_walls_height]);
                }
                translate([2 * field_width + field_width / 2, 0, 0]){
                    cube([field_width, field_width * size, inner_walls_height]);
                }
                translate([0, field_width / 2, 0]){
                    cube([field_width * size, field_width, inner_walls_height]);
                }
                translate([0, 2 * field_width + field_width / 2, 0]){
                    cube([field_width * size, field_width, inner_walls_height]);
                }

            }

            difference(){
                cube([
                    field_width * size, 
                    field_width * size, 
                    plate_height
                    ]);

                translate([field_width, field_width, 0]) cylinder(d=field_width * 1.7, h=plate_height, $fn=32);
                translate([field_width*3, field_width, 0]) cylinder(d=field_width * 1.7, h=plate_height, $fn=32);
                translate([field_width*3, field_width*3, 0]) cylinder(d=field_width * 1.7, h=plate_height, $fn=32);
                translate([field_width, field_width*3, 0]) cylinder(d=field_width * 1.7, h=plate_height, $fn=32);


                base_holes_margin = 12;
                translate([base_holes_margin, base_holes_margin, 0]) cylinder(d=3, h=plate_height, $fn=8);
                translate([field_width * size - base_holes_margin, base_holes_margin, 0]) cylinder(d=3, h=plate_height, $fn=8);
                translate([base_holes_margin, field_width * size - base_holes_margin, 0]) cylinder(d=3, h=plate_height, $fn=8);
                translate([field_width * size - base_holes_margin, field_width * size - base_holes_margin, 0]) cylinder(d=3, h=plate_height, $fn=8);
            }


            // screw corner places
            translate([0,                       0,                       0]) cube([10, 10, inner_walls_height]);
            translate([0,                       field_width * size - 10, 0]) cube([10, 10, inner_walls_height]);
            translate([field_width * size - 10, 0,                       0]) cube([10, 10, inner_walls_height]);
            translate([field_width * size - 10, field_width * size - 10, 0]) cube([10, 10, inner_walls_height]);
            translate([field_width * size / 2 - 5,  field_width * size / 2 - 5,  0]) cube([10, 10, inner_walls_height]);
        }

        module base()
        {
            difference(){
                main();

                translate([5,                      5,                      plate_height]) screw_hole(total_height);
                translate([5,                      field_width * size - 5, plate_height]) screw_hole(total_height);
                translate([field_width * size - 5, 5,                      plate_height]) screw_hole(total_height);
                translate([field_width * size - 5, field_width * size - 5, plate_height]) screw_hole(total_height);
                translate([field_width * size / 2, field_width * size / 2, plate_height]) screw_hole(total_height);
            }
        }

        if(1 == side) { side_bottom_left(); }
        if(2 == side) { side_top_left(); }
        if(3 == side) { side_top_right(); }
        if(4 == side) { side_bottom_right(); }
    }

    module rc522()
    {
        module case(){
            module plate()
            {
                difference() {
                    cube([field_width, field_width, plate_height]);
                    translate([5,5,0]){
                        cube([field_width - 10, field_width - 10, plate_height]);
                        
                    }

                    pin_spareout_x_length = 8 * 2.5 + 4;
                    translate([(field_width - pin_spareout_x_length)/2, 0, 0]){
                        cube([pin_spareout_x_length, 3.2, plate_height]);
                    }
                    translate([(field_width - pin_spareout_x_length)/2, field_width - 2, 0]){
                        cube([pin_spareout_x_length, 2, plate_height]);
                    }

                    translate([11.8, 2.6, 0]) cube([2.4,2.4, plate_height]);
                }
            }

            module stage()
            {
                block_x_length = (field_width - rc522_width) / 2;

                cube([block_x_length, 5, rc522_height]);
                translate([field_width - block_x_length, 0, 0]) {
                    cube([block_x_length, 5, rc522_height]);
                }
                translate([0,field_width - 5, 0]) {
                    cube([block_x_length, 5, rc522_height]);
                }
                translate([field_width - block_x_length,field_width - 5, 0]) {
                    cube([block_x_length, 5, rc522_height]);
                }
            }

            module nasty_pin_spareout()
            {
                translate([11.8, 2.6, 0]) cube([2.4,2.4, plate_height]);
            }

            plate();

            translate([0,0,plate_height]){
                stage();
            }
        }

        module main() 
        {
            for(x = [0:size - 1]) {
                for(y = [0:size - 1]) {
                    translate([
                        x*field_width,
                        y*field_width,
                        0
                    ]) {
                        case();
                    }
                }
            }

            // screw corner places
            translate([0,                       0, 0])                      cube([10, 10, plate_height + rc522_height]);
            translate([0,                       field_width * size - 10,0]) cube([10, 10, plate_height + rc522_height]);
            translate([field_width * size - 10, 0, 0])                      cube([10, 10, plate_height + rc522_height]);
            translate([field_width * size - 10, field_width * size - 10,0]) cube([10, 10, plate_height + rc522_height]);
        }

        difference(){
            main();

            screw_hole_z = plate_height + rc522_height + plate_height - 2;
            translate([5,                      5,                      0]) {
                screw_hole(plate_height + rc522_height); 
                translate([0, 0, screw_hole_z]) screw_head_hole();
            }
            translate([5,                      field_width * size - 5, 0]) {
                screw_hole(plate_height + rc522_height); 
                translate([0, 0, screw_hole_z]) screw_head_hole();
            }
            translate([field_width * size - 5, 5,                      0]) {
                screw_hole(plate_height + rc522_height); 
                translate([0, 0, screw_hole_z]) screw_head_hole();
            }
            translate([field_width * size - 5, field_width * size - 5, 0]) {
                screw_hole(plate_height + rc522_height); 
                translate([0, 0, screw_hole_z]) screw_head_hole();
            }
            translate([field_width * size / 2, field_width * size / 2, 0]) {
                screw_hole(plate_height + rc522_height); 
                translate([0, 0, screw_hole_z]) screw_head_hole();
            }

        }


    }

    module top()
    {
        read_width = rc522_width - 4;
        read_length = 42 - 4;
        read_offset_y = field_width - 42 + 2;
        spareout_vertical_width = (field_width - rc522_width) / 2 - 5;

        module stage()
        {
            stage_height = rc522_height - plate_height;
            difference(){
                translate([(field_width - read_width - 3.2) / 2, read_offset_y-2, -1 * stage_height]){
                    cube([read_width + 3.2, read_length + 4, stage_height]);
                }
                translate([(field_width - read_width) / 2, read_offset_y, -1 * stage_height]){
                    cube([read_width, read_length, stage_height]);
                }
            }
        }

        module spareout_read()
        {
            translate([(field_width - read_width) / 2, read_offset_y, 0]){
                cube([read_width, read_length, plate_height]);
            }
        }

        module spareout_left()
        {
            width = (field_width - rc522_width) / 2 - 5;
            length = 42 - 10;
            s2oy = field_width - 42 + 5;

            translate([5, 0, 0]){
                spareout_vertical();
            }

        }

        module spareout_right() {
            translate([field_width - spareout_vertical_width - 5, 0, 0]){
                spareout_vertical();
            }
        }

        module spareout_vertical(){
            translate([0, field_width - 42 + 5, 0]){
                cube([spareout_vertical_width, 42 - 10, plate_height]);
            }
        }

        module spareout_bottom() {
            width = field_width - 10;
            length = field_width - 42 - 5;
            translate([(field_width - width) / 2, 5, 0]){
                cube([width, length, plate_height]);
            }
        }

        module main(){

            for(x = [0:size - 1]) {
                for(y = [0:size - 1]) {
                    translate([
                        x*field_width,
                        y*field_width,
                        0
                        ]) {
                        difference() {
                            cube([field_width, field_width, plate_height]);

                            spareout_read();
                            spareout_bottom();
                            spareout_left();
                            spareout_right();
                            real_field_indicator();
                        }

                        stage();
                    }
                }
            }

            // screw corner places
            translate([2,                       2, 0])                      cube([8, 8, plate_height]);
            translate([2,                       field_width * size - 10,0]) cube([10, 8, plate_height]);
            translate([field_width * size - 10, 2, 0])                      cube([8, 8, plate_height]);
            translate([field_width * size - 12, field_width * size - 10,0]) cube([10, 8, plate_height]);
        }

        difference(){
            main();

            screw_hole_z = plate_height - 2;
            translate([5,                      5,                      screw_hole_z]) screw_head_hole();
            translate([5,                      field_width * size - 5, screw_hole_z]) screw_head_hole();
            translate([field_width * size - 5, 5,                      screw_hole_z]) screw_head_hole();
            translate([field_width * size - 5, field_width * size - 5, screw_hole_z]) screw_head_hole();
            translate([field_width * size / 2, field_width * size / 2, screw_hole_z]) screw_head_hole();
        }
    }

    module real_field_indicator()
    {
        translate([0,10,0])
        {
            r = 0.4;
            cylinder(h=plate_height, r=r, center=false, $fn=8);
            translate([field_width, 0, 0])
            cylinder(h=plate_height, r=r, center=false, $fn=8);
        }
    }

    module screw_head_hole()
    {
        cylinder(h=2, d1=2.75, d2=5.6, $fn=16);
    }
    module screw_hole(depth)
    {
        cylinder(h=depth, d=2.75, $fn=16);
    }


    if(true == show_ground) {
        ground();
    }
    if(true == show_rc522) {
        translate([0,0, inner_walls_height + z_distance])
        rc522();
    }
    if(true == show_top) {
        translate([0,0, inner_walls_height + z_distance + plate_height + rc522_height + z_distance])
        top();
    }
}

if(true == show_bottom_left) {
    translate([-60*4 - xy_distance, -60*4 - xy_distance])
        recoboard(1);
}

if(true == show_bottom_right) {
    translate([xy_distance, -60*4 - xy_distance])
        recoboard(4);
}

if(true == show_top_left) {
    translate([-60*4 -xy_distance, xy_distance])
        recoboard(2);
}

if(true == show_top_right) {
    translate([xy_distance, xy_distance])
        recoboard(3);
}
