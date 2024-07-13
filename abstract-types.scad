/*
  file: abstract-types.scad
  description: Expressive functions for 2D shapes and alterations to them.
*/

use<openscad-utilities/shapes.scad>
module square_with_holes(size=[100,100], holes=[[3, [20,30]], [3, [20,-30]]], center=true) {
    difference() {
        square([size[0], size[1]], center=center);
        for(hole=holes)translate([hole[1][0], hole[1][1]])circle(d=hole[0]);
    };
};

module rounded_rectangle_with_holes(size=[100,100], holes=[[3, [20,30]], [3, [20,-30]]], diameter=6, center=true) {
    assert(center==true);
    difference() {
        rounded_rectangle([size, diameter]);
        for(hole=holes)translate([hole[1][0], hole[1][1]])circle(d=hole[0]);
    };
};


module rectangular_plate_with_holes(size=[100,100,1], holes=[[3, [20,30]], [3, [20,-30]]]) {
    linear_extrude(height=size[2], center=true)square_with_holes([size[0], size[1]], holes);
};