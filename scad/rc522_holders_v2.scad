module rc522_holder(with_background = false){
    // base dimensions
    width=39.2;
    module half(width){
        //width=39.2;
        height=46.5;
        thickness=2;

        // pin_spareout
        spareout_width=25;
        spareout_height=16.5;

        // holders
        holder_diameter = 3;
        holder_height = 5;

        holder_bottom_offset_x = 7;
        holder_bottom_offset_y = 7;    
        holder_top_offset_x = 2.5;
        holder_top_offset_y = holder_bottom_offset_y + 37.5;

        holder_fn = 16;
            difference() {
            cube([width/2,height,thickness]);

            translate([
                (width - spareout_width) / 2,
                height - spareout_height,
                0
            ])
            cube([
                spareout_width / 2,
                spareout_height,
                thickness
            ]);
        }
        
        // bottom holder pin
        translate([
            holder_bottom_offset_x,
            holder_bottom_offset_y,
            0
        ])
        cylinder(
            h=holder_height, 
            d=holder_diameter, 
            $fn=holder_fn
        );
        
        // top holder pin
        translate([
            holder_top_offset_x,
            holder_top_offset_y,
            0
        ])
        cylinder(
            h=holder_height, 
            d=holder_diameter, 
            $fn=holder_fn
        );
    }
    half(width);
    mirror([1,0,0]) translate([-width,0,0]) half(width);
    
    if(with_background == true) {
        square([width, 60]);
    }
    
}


rc522_holder(true);

for(x=[0:3]){
    for(y=[0:3 ]){
        translate([x*60,y*60                       ,0])rc522_holder(true);
    }
}