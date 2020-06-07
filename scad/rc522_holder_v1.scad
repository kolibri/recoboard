
module rc522_holder(){

// base dimensions
width=39.2;
height=60;
thickness=2;

// pin_spareout
pins_width=21;
pins_height=3;

// holders
holder_diameter = 3;
holder_height = 5;
holder_top_offset_x = 7;
holder_top_offset_y = height-7.5;    
holder_bottom_offset_x = 2.5;
holder_bottom_offset_y = 15;    
holder_fn = 16;

difference() {
cube([width,height,thickness]);

translate([(width-pins_width)/2,0,0])
    cube([pins_width,pins_height,thickness]);
}

// top left
translate([holder_top_offset_x,holder_top_offset_y,0])
    cylinder(h=holder_height, d=holder_diameter, $fn=holder_fn);
// top right
translate([width-holder_top_offset_x,holder_top_offset_y,0])
    cylinder(h=holder_height, d=holder_diameter, $fn=holder_fn);
    

translate([holder_bottom_offset_x,holder_bottom_offset_y,0])
    cylinder(h=holder_height, d=holder_diameter, $fn=holder_fn);

translate([width-holder_bottom_offset_x,holder_bottom_offset_y,0])
//translate([39.2-3.5,14.5,0])
    cylinder(h=holder_height, d=holder_diameter, $fn=holder_fn);
}


rc522_holder();