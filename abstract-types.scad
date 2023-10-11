/*
  Collection of commonly used abstractions, modules for creating objects in a standard way.

*/


module square_with_holes(size=[100,100], holes=[[3, [20,30]], [3, [20,-30]]], center=true) {
    difference() {
        square([size[0], size[1]], center=center);
        for(hole=holes)translate([hole[1][0], hole[1][1]])circle(d=hole[0]);
    };
};


module rectangular_plate_with_holes(size=[100,100,1], holes=[[3, [20,30]], [3, [20,-30]]]) {
    linear_extrude(height=size[2], center=true)square_with_holes([size[0], size[1]], holes);
};

