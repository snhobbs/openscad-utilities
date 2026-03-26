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
  ... Each shape then defines additional characteristics
*/

module rounded_rectangle(args) {
    /*
        Make a rounded rectangle by putting circles at the corner of an inner rectangle
        where the furthest extent of the x and y position are at the limits of the rectangle.
        Merge this with 2 rectangles which meet these circles at this appex.
    :param list[[x,y], d]
    */

    size = args.x;
    diameter = args.y;
    circle_center_square = [size.x-diameter, size.y
    -diameter];
    inner_square = [circle_center_square.x+diameter/sqrt(2), circle_center_square.y+diameter/sqrt(2)];
    union() {
        for(p = [[1,1],[1,-1],[-1,1],[-1,-1]]) {
            translate([circle_center_square.x/2*p.x, circle_center_square.y/2*p.y])circle(d=diameter);
        };
        square([size.x, circle_center_square.y], true);
        square([circle_center_square.x, size.y], true);
    };
};


module square_with_corner_reliefs(shape) {
  /*
  :param list[list[float x, float y], float corner_diameter] args
  */
    size = dict_lookup("size", shape);
    corner_radius = dict_lookup("corner_radius", shape);
    
    union() {
        square(size, center=true);
        for(pt = [[-1,-1],[1,-1],[-1,1],[1,1]]) {
            translate([
                pt.x*(size.x/2-corner_radius/sqrt(2)),
                pt.y*(size.y/2-corner_radius/sqrt(2))])
                    circle(d=2*corner_radius);
        }
    };
};

module make_shape_square(shape) {
    square(
        [dict_lookup("width", shape), dict_lookup("length", shape)], 
        center=dict_lookup("center", shape));
};

module make_shape_circle(shape) {
    circle(d=dict_lookup("diameter", shape), 
           fn=dict_lookup("fn", shape));
};

module make_shape_vector(shape) {
    make_vector_image(shape);
};

module make_shape_square_with_corner_reliefs(shape) {
    square_with_corner_reliefs(shape);
};

module make_shape_rounded_rectangle(shape) {
    assert(is_list(shape));
    
    size = dict_lookup("size", shape);
    echo(size);
    d = dict_lookup("corner_radius", shape)*2;

    assert(is_list(size));
    assert(is_num(d));
    //  rounded_rectangle(width=size.x, height=size.y, rounding=dict_lookup("corner_diameter", args));
    args = [size, d];
    rounded_rectangle(args);
};

function check_shape(shape) = is_list(shape) && is_string(dict_lookup("name", shape)) && is_string(dict_lookup("type", shape));

/*
Makes a 2D shape object
:param string shape: ID of shape
:param vector args: vector of arguments to the matching shape module.
*/
module make_shape(shape) {
    assert(check_shape(shape));
    type = get(shape, "type");
    name = get(shape, "name");
    assert(is_string(name));
    assert(name=="Shape");

    if (type == "square") {
        make_shape_square(shape);
    } else if (type == "square_with_corner_reliefs") {
        make_shape_square_with_corner_reliefs(shape);
    } else if (type == "rounded_rectangle") {
        make_shape_rounded_rectangle(shape);
    } else if (type == "circle") {
        make_shape_circle(shape);
    } else if(type == "none") {
    } else if(type == "vector") {
        make_shape_vector(shape);
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
        for(hole=holes) translate([dict_lookup("x", hole), dict_lookup("y", hole)]) circle(d=dict_lookup("diameter", hole));
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

make_shape([["name", "Shape"], ["type", "rounded_rectangle"], ["size", [10.0, 10.0]], ["corner_radius", 1.0]]);
$fn=64;

