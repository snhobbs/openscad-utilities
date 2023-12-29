/*
file: shapes.scad
description: abstract solid 2D shapes intended to allow passing of a part description as an argument.
*/
use <openscad-utilities/vector-file.scad>;
use <openscad-utilities/rounded_rectangle.scad>;
use <openscad-utilities/tools.scad>;

/*
class Shape:
  string name = "Shape";  //  part type
  string type;  //  subclass
  list args;  //  argument to pass to subtype
*/

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
    size = dict_lookup("size", args);
    rounded_rectangle(width=size.x, height=size.y, rounding=dict_lookup("corner_diameter", args));
};

function check_shape(shape) = is_list(shape) && is_string(dict_lookup("name", shape)) && is_list(shape[1]);

/*
Makes a 2D shape object
:param string shape: ID of shape
:param vector args: vector of arguments to the matching shape module.
*/
module make_shape(shape) {
    assert(is_list(shape));
    name = dict_lookup("name", shape);
    args = shape[1];
    assert(is_list(args));
    assert(is_string(name));
    if (name == "square") {
        make_shape_square(args);
    } else if (name == "square_with_corner_reliefs") {
        make_shape_square_with_corner_reliefs(args);
    } else if (name == "rounded_rectangle") {
        make_shape_rounded_rectangle(args);
    } else if (name == "circle") {
        make_shape_circle(args);
    } else if(name == "none") {
    } else if(name == "vector") {
        make_shape_vector(args);
    } else if(name == "svg-supports") {
      assert(0, "Not implemented");
    } else {
        echo(shape);
        assert(0, "Unknown shape");
    }
};


module make_shape_with_holes(shape, holes) {
    difference() {
        make_shape(shape);
        for(hole=holes)translate([hole[1].x, hole[1].y])      circle(d=hole[0]);
    };
};

module make_transformed_shape(shape, rotated=0, mirrored=false, position=[0,0]) {
    mirror(mirrored ? [0,1,0]:[0,0,0])
    rotate([0,0,rotated])
    translate([position.x, position.y])
    make_shape(shape);
};
