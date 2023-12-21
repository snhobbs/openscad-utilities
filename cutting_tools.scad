/*
cutting_tools.scad

Series of parametric tools intended for cutting shapes
*/

infinity_=10000;

/*
Outer cylinder and inner cylinder with flutes
Use n number of rectangles arranged in a circle
The outer shape is a circle and the center meeting point
is also a circle.
*/
module fluted_circle(n, width, d, fn=32) {
    module circular_rectangles(n, width) {
        union() {
            for (i=[0:(n-1)]) {
                rotate((360/n)*i)translate([0, -width/2])square([infinity_,width], center=false, $fn=fn);
            };
            circle(d=width, $fn=fn);
        };
    };
    
    intersection() {
        union() {
            circular_rectangles(n, width);
        };
        circle(d=d);
    };
};


module fluted_circle_inverse(n, width, d, fn=32) {
    difference() {
        circle(d=d);
        fluted_circle(n=n, width=width, d=d, fn=fn);
    };
}

$fn=100;
union() {
    fluted_circle_inverse(n=6, width=0.75, d=6, fn=$fn);
    circle(d=2);
};