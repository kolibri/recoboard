module pin_holes(pins = 8){
    module hole(){
            
            translate([2.5/2, 3.5/2])
            cylinder(
                h=2,
                d=1.5,
                $fn=16
            );
        
    }
    for(x=[0:pins-1]){
        translate([2.5*x+0.5,0,0])
        hole();
    }
}



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
holder_height = 6.5;
holder_top_offset_x = 7;
holder_top_offset_y = height-7.5;    
holder_bottom_offset_x = 2.5;
holder_bottom_offset_y = 15;    
holder_fn = 16;

difference() {
cube([width,height,thickness]);

translate([(width-pins_width)/2,0,0])
    pin_holes();


translate([10,15,0]) cylinder(h=2,d=3,$fn=32);

translate([width-10,15,0]) cylinder(h=2,d=3,$fn=32);

translate([10,45,0]) cylinder(h=2,d=3,$fn=32);
translate([width-10,45,0]) cylinder(h=2,d=3,$fn=32);

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

translate([8.5, 17.5, 2.5])
cube([3,25,2.5]);
translate([39.2-11.5, 17.5, 2.5])
cube([3,25,2.5]);

translate([(39.2-20)/2, 7, 2.5])
cube([20,3,2.5]);
translate([(39.2-20)/2, 53, 2.5])
cube([20,3,2.5]);


rc522_holder();