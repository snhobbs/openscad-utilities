/*
file: shapes.scad
description: abstract solid 2D shapes intended to allow passing of a part description as an argument.
*/
use <openscad-utilities/vector-file.scad>;
//use <openscad-utilities/rounded_rectangle.scad>;
use <openscad-utilities/tools.scad>;

/*
class Shape:
  string name = "Shape";  //  part type
  string type;  //  subclass
  list args;  //  argument to pass to subtype
*/

module rounded_rectangle(args) {
    /*
        Make a rounded rectangle by putting circles at the corner of an inner rectangle
        where the furthest extent of the x and y position are at the limits of the rectangle.
        Merge this with 2 rectangles which meet these circles at this appex.
    */
    assert(is_list(args));
    assert(is_list(args.x));
    assert(is_num(args.y));
    bounding_box = args.x;
    diameter = args.y;

    circle_center_square = [bounding_box.x-diameter, bounding_box.y
    -diameter];
    inner_square = [circle_center_square.x+diameter/sqrt(2), circle_center_square.y+diameter/sqrt(2)];
    union() {
        for(p = [[1,1],[1,-1],[-1,1],[-1,-1]]) {
            translate([circle_center_square.x/2*p.x, circle_center_square.y/2*p.y])circle(d=diameter);
        };
        square([bounding_box.x, circle_center_square.y], true);
        square([circle_center_square.x, bounding_box.y], true);
    };
};


rounded_rectangle([[10,10],3]);
$fn=64;
module square_with_corner_reliefs(args) {
  /*
  :param list[list[float x, float y], float corner_diameter] args
  */
    size = args.x;
    corner_diameter = args.y;
    union() {
        square(size, center=true);
        for(pt = [[-1,-1],[1,-1],[-1,1],[1,1]]) {
            translate([
                pt.x*(size.x/2-corner_diameter/2/sqrt(2)),
                pt.y*(size.y/2-corner_diameter/2/sqrt(2))])
                    circle(d=corner_diameter);
        }
    };
};

module make_shape_square(args) {
    square([args.x, args.y], center=args.z);
};

module make_shape_circle(args) {
    circle(d=args.x, fn=args.y);
};

module make_shape_vector(args) {
    make_vector_image(args);
};

module make_shape_square_with_corner_reliefs(args) {
    square_with_corner_reliefs(args);
};

module make_shape_rounded_rectangle(args) {
    assert(is_list(args));
    size = dict_lookup("size", args);
    d = dict_lookup("corner_diameter", args);
    assert(is_list(size));
    assert(is_num(d));
    //  rounded_rectangle(width=size.x, height=size.y, rounding=dict_lookup("corner_diameter", args));
    args = [size, d];
    rounded_rectangle(args);
};

function check_shape(shape) = is_list(shape) && is_string(dict_lookup("name", shape)) && is_string(dict_lookup("type", shape)) && is_list(dict_lookup("arguments", shape));

/*
Makes a 2D shape object
:param string shape: ID of shape
:param vector args: vector of arguments to the matching shape module.
*/
module make_shape(shape) {
    assert(check_shape(shape));
    type = dict_lookup("type", shape);
    args = dict_lookup("arguments", shape);
    name = dict_lookup("name", shape);
    assert(is_string(name));
    assert(name=="Shape");

    if (type == "square") {
        make_shape_square(args);
    } else if (type == "square_with_corner_reliefs") {
        make_shape_square_with_corner_reliefs(args);
    } else if (type == "rounded_rectangle") {
        make_shape_rounded_rectangle(args);
    } else if (type == "circle") {
        make_shape_circle(args);
    } else if(type == "none") {
    } else if(type == "vector") {
        make_shape_vector(args);
    } else if(type == "svg-supports") {
      assert(0, "Not implemented");
    } else {
        echo(shape);
        assert(0, "Unknown shape");
    }
};


module make_shape_with_holes(shape, holes) {
    assert(check_shape(shape));
    difference() {
        make_shape(shape);
        for(hole=holes)translate([hole[1].x, hole[1].y])      circle(d=hole[0]);
    };
};

module make_transformed_shape(shape, rotated=0, mirrored=false, position=[0,0]) {
    assert(is_num(rotated));
    assert(is_list(position));
    assert(is_num(position[0]));
    assert(is_num(position[1]));

    mirrored_ = (is_bool(mirrored) || is_num(mirrored)) && mirrored;
    mirror(mirrored_ ? [0,1,0]:[0,0,0])
    rotate([0,0,rotated])
    translate([position.x, position.y])
    make_shape(shape);
};
