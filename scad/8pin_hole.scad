module pin_holes(pins = 8){

    height=1;
    
    module hole(){
        difference() {
            cube([2.5,2.5,height]);
            
            translate([2.5/2, 2.5/2])
            cylinder(
                h=height,
                d=1.1,
                $fn=8
            );
        }
    }
    
    for(x=[0:pins-1]){
        translate([2.5*x,0,0])
        hole();
    }
    
}


pin_holes();