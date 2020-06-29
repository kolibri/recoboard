module pins_holes()
{
    holes = 8;
    offset_x = (field_size - holes*2.5) / 2;


    for(x = [0:holes - 1]) {
        translate([2.5 * x + offset_x, 1.25, 0]) {
            cylinder(
                h = 100,
                d = 1.5,
                $fn = 16);

        }
        translate([2.5 * x + offset_x - 1, 0.25, plate_height])
            cube([2,2,11], center=false);

    }
}

module field(){
    module plate()
    {
        difference() {
            cube([field_size, field_size, plate_height]);
            translate([4,4,0]){
                cube([field_size - 8, field_size - 8, plate_height]);
            }
        }
    }

    module wall()
    {
        width = 5;
        height = 11 + plate_height;
        cube([field_size, width, height]);

        translate([0, field_size-width, 0]){
            cube([field_size, width, height]);
        }
    }

    module main() {
        plate();
        wall();
    }

    difference(){
        main();
        pins_holes();
    }
}

module pin_layer(size)
{
    for(x = [0:size - 1]) {
        for(y = [0:size - 1]) {
            translate([
                x*field_size,
                y*field_size,
                0
                ]) {
                field();
            }
        }
    }
}






module rc522_holder()
{

}


board_size = 4;
field_size=60;
rc522_width=39.2;
plate_height=1.2;

pin_layer(board_size);

rc522_layer(board_size);
