module pin_holes(pins = 8){
    module hole(){
        difference() {
            cube([2.5,3.5,2]);
            
            translate([2.5/2, 3.5/2])
            cylinder(
                h=2,
                d=1.5,
                $fn=16
            );
        }
    }
    module case(){
            difference(){
            cube([2.5,3.5,11]);    
            
                
            translate([0.25,0.75,0])
            cube([2,2,11]);    
            }
    }
    
    cube([0.5,3.5,13]);

    for(x=[0:pins-1]){
        translate([2.5*x+0.5,0,0])
        hole();
        
        translate([2.5*x+0.5,0,2])
        case();
        
    }
    
    translate([2.5*pins+0.5, 0, 0])
    cube([0.5,3.5,13]);
}

module plate_holder(){
    cylinder(h=13, d=5, $fn=32);
    translate([0,0,13]) cylinder(h=2, d=3, $fn=32);
}

// base dimensions
width=39.2;
height=60;
thickness=2;

pins_width=21;
pins_height=3;

translate([0,0.5,0])
difference() {
    cube([width,height,thickness]);
    translate([(width-pins_width)/2,0,0]) cube([pins_width,pins_height,thickness]);
    translate([(width-pins_width)/2,60-0.5,0]) cube([pins_width,0.5,thickness]);

    translate([5,5,0]) cylinder(h=thickness, d=3, $fn=32);
    translate([width-5,5,0]) cylinder(h=thickness, d=3, $fn=32);
    translate([5,height-5,0]) cylinder(h=thickness, d=3, $fn=32);
    translate([width-5,height-5,0]) cylinder(h=thickness, d=3, $fn=32);
}

translate([width/2-21/2,0,0])
pin_holes();

translate([10,15.5,0]) plate_holder();
translate([width-10,15.5,0]) plate_holder();

translate([10,45.5,0]) plate_holder();
translate([width-10,45.5,0]) plate_holder();