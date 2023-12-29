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
module fluted_circle(n, width, d) {
    module circular_rectangles(n, width) {
        union() {
            for (i=[0:(n-1)]) {
                rotate((360/n)*i)translate([0, -width/2])square([infinity_,width], center=false);
            };
            circle(d=width);
        };
    };
    
    intersection() {
        union() {
            circular_rectangles(n, width);
        };
        circle(d=d);
    };
};

module fluted_circle_inverse(n, width, d) {
    difference() {
        circle(d=d);
        fluted_circle(n=n, width=width, d=d);
    };
}


/*
rectangles start from inner circle and head out
*/
/*
module fluted_circle_exterior(n, width, d, d2, angle) {
    module circular_rectangles(n, width, d, d2, angle) {
        union() {
            for (i=[0:(n-1)]) {
                translate([0, -width/2])  //  Centered rectangle about 1x axis
                {
                //rotate((360/n)*i)  //  Each rectange going out from center w/ even spacing
                //rotate(angle)  //  Angle of rectangle
                translate([sin(angle)*(d2/2), cos(angle)*(d2/2)])  //  offset
                square([infinity_,width], center=false);
                };
            };
            circle(d=width);
        };
    };
    
    intersection() {
        union() {
            circular_rectangles(n, width, angle);
        };
        circle(d=d);
    };
};

module fluted_circle_exterior_inverse(n, width, d, angle=0) {
    difference() {
        circle(d=d);
        fluted_circle_exterior(n=n, width=width, d=d, d2=0, angle=angle);
    };
}

$fn=100;
difference() {
    fluted_circle_exterior(n=1, width=1.25, d=40, d2=10, angle=45);
    circle(d=3);
};

*/
