enable_eco = true;
show_rc522_plate = true;
show_pins_plate = true;
show_plate_connector = true;


module pin_case()
{
    module case()
    {
        difference()
        {
            cube([
                pins_distance, 
                pins_area_y_length, 
                pin_case_height
            ]);   
            translate([0.25, 0.75, 0]) {
                cube([2, 2, pin_case_height]);    
            }
        }
    }

    wall_addition_strength = 0.5;

    translate([pins_area_x_offset, 0, 0])
    {
        cube([
            wall_addition_strength, 
            pins_area_y_length, 
            pin_case_height
        ]);
    }

    for(x = [0:pin_count - 1]) {
        translate([
            pins_distance * x + wall_addition_strength + pins_area_x_offset, 
            0, 
            0
        ]) {
            case();
        }
    }

    translate([
        pins_distance * pin_count + wall_addition_strength + pins_area_x_offset, 
        0, 
        0
    ]) {
        cube([
            wall_addition_strength, 
            pins_area_y_length, 
            pin_case_height
        ]);
    }
}

module pin_holes()
{
    module hole()
    {
        difference() 
        {
            cube([
                pins_distance,
                pins_area_y_length,
                plate_thickness
            ]);

            translate([
                pins_distance/2,
                pins_area_y_length/2,
                0
            ]) {
                cylinder(
                    h = plate_thickness,
                    d = 1.5,
                    $fn = 16);
            }
        }
    }

    for(x = [0:pin_count - 1]) {
        translate([
            2.5 * x + pins_area_x_offset,
            0,
            0
        ]){
            hole();
        }
    }
}

module pin_holes_with_case()
{
    pin_holes();
    translate([
        -0.5, 
        0, 
        plate_thickness
    ]) {
        pin_case();
    }
}

module distancer(distance, pin_height){
    cylinder(
        h = distance, 
        d = 5, 
        $fn = 16
    );
    translate([0, 0, distance]) {
        cylinder(
            h=pin_height, 
            d=connector_pin_diameter, 
            $fn=16
        );
    }
}

module rc522_distancer()
{
    top_x_offset = 7;
    top_y_offset = 53;    
    bottom_x_offset = 2.5;
    bottom_y_offset = 15.5;    
    distance = 2.5 - rc522_lowering;
    pin_height = 2;

    translate([
        top_x_offset,
        top_y_offset,
        plate_thickness
    ]) {
        distancer(distance, pin_height);
    }
    translate([
        plate_width - top_x_offset,
        top_y_offset,
        plate_thickness
    ]) {
        distancer(distance, pin_height);
    }
    translate([
        bottom_x_offset,
        bottom_y_offset,
        plate_thickness
    ]) {
        distancer(distance, pin_height);
    }
    translate([
        plate_width - bottom_x_offset,
        bottom_y_offset,
        plate_thickness
    ]) {
        distancer(distance, pin_height);
    }
}

module base_plate()
{
    difference()
    {
        cube([
            plate_width, 
            plate_length, 
            plate_thickness
        ]);
        
        translate([pins_area_x_offset, 0, 0])
        {
            cube([
                pins_area_x_width, 
                pins_area_y_length, 
                plate_thickness
            ]);
        }
    }
}

module plate_connector_cylinder(x_offset, y_offset)
{
    translate([x_offset, y_offset,0]) {
        cylinder(
            h=plate_thickness, 
            d=connector_pin_diameter, 
            $fn=16
        );
    }
}

module plate_connector_cylinders(x_offset, y_offset)
{
    plate_connector_cylinder(
        x_offset, 
        y_offset
    );
    plate_connector_cylinder(
        plate_width - x_offset, 
        y_offset
    );
    plate_connector_cylinder(
        plate_width - x_offset, 
        plate_length - y_offset
    );
    plate_connector_cylinder(
        x_offset, 
        plate_length - y_offset
    );
}


module rc522_plate()
{
    difference(){
        base_plate();

        plate_connector_cylinders(4,4);
    }

    rc522_distancer();

    // lower pins area
    difference(){
        pin_holes();

        translate([
            pins_area_x_offset,
            0,
            plate_thickness - 0.8
        ]) {
            cube([
                pins_area_x_width,
                pins_area_y_length,
                0.8
            ]);
        }

    }
}

module pins_plate()
{

    difference(){
        base_plate();

        plate_connector_cylinders(
            pins_plate_connector_offset,
            pins_plate_connector_offset
        );
    }

    pin_holes_with_case();


    translate([
        rc522_plate_connector_offset,
        rc522_plate_connector_offset,
        plate_thickness
    ]) {
        distancer(pin_case_height, plate_thickness);
    }
    translate([
        plate_width - rc522_plate_connector_offset,
        rc522_plate_connector_offset, 
        plate_thickness
    ]) {
        distancer(pin_case_height, plate_thickness);
    }
    translate([
        rc522_plate_connector_offset,
        plate_length - rc522_plate_connector_offset, 
        plate_thickness
    ]) {
        distancer(pin_case_height, plate_thickness);
    }
    translate([
        plate_width - rc522_plate_connector_offset,
        plate_length - rc522_plate_connector_offset, 
        plate_thickness
    ]) {
        distancer(pin_case_height, plate_thickness);
    }
}

module plate_connector(){
    pin_offset = connector_pin_diameter/2; 

    module pin()
    {
        cylinder(
            h=plate_thickness * 2, 
            d = connector_pin_diameter, 
            $fn=16);

    }
    
    translate([
        pin_offset,
        0,
        0
    ]) {
        cube([
            pc_length, 
            pc_width + connector_pin_diameter, 
            plate_thickness
        ]);
    }
    translate([0,pin_offset,0]) {
        cube([
            pc_length + connector_pin_diameter, 
            pc_width, 
            plate_thickness
        ]);
    }
    
    translate([
        pin_offset,
        pin_offset,
        0
    ]) pin();

    translate([
        pc_length + pin_offset,
        pin_offset,
        0
    ]) pin();

    translate([
        pc_length + pin_offset,
        pc_width + pin_offset,
        0
    ]) pin();

    translate([
        pin_offset,
        pc_width + pin_offset,
        0
    ]) pin();
}


module rc522_plate_eco()
{
    spare_x_width = 24;
    spare_x_offset = (plate_width - spare_x_width) / 2;
    spare_y_length = 36;
    spare_y_offset = 10;


    difference(){
        rc522_plate();

        translate([
            spare_x_offset,
            spare_y_offset,
            0
        ])
        cube([spare_x_width, spare_y_length, plate_thickness]);
    }
}

module pins_plate_eco()
{
    spare_x_width = 26;
    spare_x_offset = (plate_width - spare_x_width) / 2;
    spare_y_length = 36;
    spare_y_offset = (plate_length - spare_y_length) / 2;


    difference(){
        pins_plate();

        translate([
            spare_x_offset,
            spare_y_offset,
            0
        ])
        cube([spare_x_width, spare_y_length, plate_thickness]);
    }
}

module plate_connector_eco()
{
    spare_x_width = pc_width - connector_pin_diameter;
    spare_x_offset = (pc_width - spare_x_width) / 2 + connector_pin_diameter / 2;
    spare_y_length = pc_length - connector_pin_diameter;
    spare_y_offset = (pc_length - spare_y_length) / 2 + connector_pin_diameter / 2;


    difference(){
        plate_connector();

        translate([
            spare_x_offset,
            spare_y_offset,
            0
        ])
        cube([spare_y_length, spare_x_width, plate_thickness]);
    }
}



plate_width = 39.2;
plate_length = 60;
plate_thickness = 2;

pin_count = 8;
pins_distance = 2.5;
pins_area_y_length = 3.5;
pins_area_x_width = pin_count * pins_distance;
pin_case_height = 11;
pins_area_x_offset = (plate_width - pins_area_x_width)/2;

rc522_lowering = 0.8;
rc522_plate_connector_offset = 4;
pins_plate_connector_offset = 8;

connector_pin_diameter = 3;

// plate connector
pc_width = plate_length - plate_width + pins_plate_connector_offset *2;
pc_length = pins_plate_connector_offset * 2;


if(true == show_rc522_plate) 
{
    if(true == enable_eco) {
        rc522_plate_eco();
    } else {
        rc522_plate();
    }
}


if(true == show_pins_plate) 
{
    translate([0, plate_length + 10]){
        if(true == enable_eco) {
            pins_plate_eco();
        } else {
            pins_plate();
        }
    }
    
}

if(true == show_plate_connector)
{
    translate([0, (plate_length + 10) * 2]){
        if(true == enable_eco) {
           plate_connector_eco();
        } else {
           plate_connector();
        }
    }

}

