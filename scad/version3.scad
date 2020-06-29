module case_base(){
    module plate()
    {
        difference() {
            cube([field_size, field_size, plate_height]);
            translate([5,5,0]){
                cube([field_size - 10, field_size - 10, plate_height]);
                
            }

            pin_spareout_x_length = 8 * 2.5 + 4;
            translate([(field_size - pin_spareout_x_length)/2, 0, 0]){
                cube([pin_spareout_x_length, 3.2, plate_height]);
            }
            translate([(field_size - pin_spareout_x_length)/2, field_size - 2, 0]){
                cube([pin_spareout_x_length, 2, plate_height]);
            }
        }
    }

    module stage()
    {
        block_x_length = (field_size - rc522_width) / 2;

        cube([block_x_length, 5, rc522_height]);
        translate([field_size - block_x_length, 0, 0]) {
            cube([block_x_length, 5, rc522_height]);
        }
        translate([0,field_size - 5, 0]) {
            cube([block_x_length, 5, rc522_height]);
        }
        translate([field_size - block_x_length,field_size - 5, 0]) {
            cube([block_x_length, 5, rc522_height]);
        }
    }



    plate();
    translate([0,0,plate_height]){
        stage();
    }
    translate([0,0,plate_height + rc522_height]) {
        connector();
    }
}


module connector()
{
    height = plate_height;


    block_x_length = (field_size - rc522_width) / 2 - 3;
    block_y_length = 2;

    cube([block_x_length, block_y_length, height]);
    translate([field_size - block_x_length, 0, 0]) {
        cube([block_x_length, block_y_length, height]);
    }
    translate([0,field_size - block_y_length, 0]) {
        cube([block_x_length, block_y_length, height]);
    }
    translate([field_size - block_x_length,field_size - block_y_length, 0]) {
        cube([block_x_length, block_y_length, height]);
    }


//
    cube([1.5, 5, height]);
    
    translate([field_size - 1.5,0,0]) {
        cube([1.5, 5, height]);
    }
    translate([0,field_size - 5,0]) {
        cube([1.5, 5, height]);
    }
    translate([field_size - 1.5,field_size - 5,0]) {
        cube([1.5, 5, height]);
    }

}

module top_base()
{
    module real_field_outline()
    {
        translate([0,10,0])
        {
            difference(){
                cube([field_size, field_size, 0.4]);

                translate([0.2, 0.2, 0]){
                    cube([field_size -0.4, field_size -0.4, 0.4]);
                }

                translate([0.4, 0, 0]){
                    cube([field_size -0.8, field_size, 0.4]);
                }
                translate([0, 0.4, 0]){
                    cube([field_size, field_size -0.8, 0.4]);
                }

            }
        }
    }

    module case()
    {
        read_width = rc522_width - 4;
        read_length = 42 - 4;
        read_offset_y = field_size - 42 + 2;
        difference() {
            cube([field_size, field_size, plate_height]);

            connector();

            translate([(field_size - read_width) / 2, read_offset_y, 0]){
                cube([read_width, read_length, plate_height]);
            }


            s1w = field_size - 10;
            s1l = field_size - 42 - 5;
            translate([(field_size - s1w) / 2, 5, 0]){
                cube([s1w, s1l, plate_height]);
            }


            s2w = (field_size - rc522_width) / 2 - 5;
            s2l = 42 - 10;
            s2oy = field_size - 42 + 5;

            translate([5, s2oy, 0]){
                cube([s2w, s2l, plate_height]);
            }

            s3w = (field_size - rc522_width) / 2 - 5;
            s3l = 42 - 10;
            s3oy = field_size - 42 + 5;

            translate([field_size - s3w - 5, s3oy, 0]){
                cube([s3w, s3l, plate_height]);
            }
        }

        difference(){
            translate([(field_size - read_width - 4) / 2, read_offset_y-2, plate_height]){
                cube([read_width + 4, read_length + 4, 3]);
            }
            translate([(field_size - read_width) / 2, read_offset_y, plate_height]){
                cube([read_width, read_length, 3]);
            }
        }
    }


    translate([0,0,plate_height]){
        real_field_outline();
    }
    case();
}

module case(size)
{
    for(x = [0:size - 1]) {
        for(y = [0:size - 1]) {
            translate([
                x*field_size,
                y*field_size,
                0
            ]) {
                case_base();
            }
        }
    }
}


module top(size)
{
    for(x = [0:size - 1]) {
        for(y = [0:size - 1]) {
            translate([
                x*field_size,
                y*field_size,
                0
            ]) {
                    top_base();
                
            }
        }
    }
}

module ground_plate()
{

    pcb_z = 6;
    wall_height = 2 * pcb_z + 20;


    cube([field_size, field_size, plate_height ]);

}

module ground_border_bottom(size)
{
    translate([0, -5, 0]){
        cube([field_size, 5, 32 + plate_height + rc522_height + plate_height]);
    }
    difference(){
        cube([field_size, 5, 32]);
        
        pin_spareout_x_length = 8 * 2.5 + 4;

        translate([(field_size - pin_spareout_x_length) / 2, 0, 0]) {
            cube([pin_spareout_x_length, 10, 32]);
        }
    }
}
module ground_border_top(size)
{
    cube([field_size, 5, 32 + plate_height + rc522_height + plate_height]);
    translate([0, -5, 0]){
        cube([field_size, 5, 32]);

    }
    translate([0, -1 * field_size * size, 0]){
        //cube([field_size, 2, 32]);
    }
}
module ground_border_left(size)
{
    translate([-5, 0, 0]){
        cube([5, field_size, 32 + plate_height + rc522_height + plate_height]);
    }
    //cube([5, field_size, 32]);

}
module ground_border_right(size)
{
    cube([5, field_size, 32 + plate_height + rc522_height + plate_height]);
    translate([-5, 0, 0]){
        cube([5, field_size, 32]);    
    }

    translate([-1 * field_size * size, 0, 0]){
        //cube([2, field_size, 32]);
    }
}

 
module ground(size)
{
    size = 4;
    module pcb()
    {
        translate([(field_size * size - expander_length) / 2 ,0, 0 ]) {
            cube([expander_length, expander_width / 2, plate_height + 6 + pcb_thickness + 2.4]);
        }
    }

    translate([0, field_size * size / 2 - 2, 0])
        cube([field_size * size, 4, 32]);
    //cube([2, field_size * size, 32]);
    //cube([5, field_size, 32]);
    
    for(x = [0:size - 1]) {
        //translate([x * field_size, 0, 0])                 ground_border_bottom(size);
        translate([x * field_size, field_size * size, 0]) ground_border_top(size);
        //translate([0, x*field_size, 0])                   ground_border_left(size);
        translate([field_size * size, x * field_size, 0]) ground_border_right(size);
        
        for(y = [0:size - 1]) {
            translate([x * field_size, y * field_size, 0 ]) ground_plate();
        }        
    }

    pcb();


}





board_size = 2;
field_size=60;
rc522_width=39.2;
rc522_height=5.5;
plate_height=1.2;

expander_width = 70;
expander_length = 90.5;
expander_srew_holes_d = 3.5;

pcb_thickness = 1.2;

translate([0, 0, 0]) {
    //translate([0, -1 * (board_size * field_size + 10), 0]){
    ground(board_size);
}


translate([0, 0, 50]) {
    case(board_size);
}

translate([0, 0, 100]) {
//    top(board_size);
}

