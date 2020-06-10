// base dimensions
width=39.2;
height=60;
thickness=2;

module plate_holder(){
    cylinder(h=3, d=5, $fn=32);
    translate([0,0,3]) cylinder(h=2, d=3, $fn=32);
}


cube([width,height,thickness]);

translate([5,5,thickness]) plate_holder();
translate([width-5,5,thickness]) plate_holder();
translate([5,height-5,thickness]) plate_holder();
translate([width-5,height-5,thickness]) plate_holder();
