use<fasteners.scad>
/* tools */
module through_hole(hole, through_all_height=1000){
    diameter = hole[0];
    position = hole[1];
    translate([position[0], position[1], 0])cylinder(h=through_all_height, d=diameter, center=true);
}

function make_four_corners(x, y) = [for(pt=[[1,1], [-1, 1], [1, -1], [-1, -1]]) [x*pt[0], y*pt[1]]];
    
/*
function make_even_mounting_holes(fastener_name, size) = let(fastener=get_fastener(fastener_name))[for(pt = [[1,1], [-1,1], [1,-1],[-1,-1]]) [fastener,[(size.x/2 - get_fastener_field(fastener, "minimal edge clearance"))*pt[0], (size.y/2 - get_fastener_field(fastener, "minimal edge clearance"))*pt[1]]]];
    

function make_odd_mounting_holes(fastener_name, size) = let(fastener=get_fastener(fastener_name))[for(pt = [[1,0], [-1,0], [0,1],[0,-1]]) [fastener,[(size.x/2 - get_fastener_field(fastener, "minimal edge clearance"))*pt[0], (size.y/2 - get_fastener_field(fastener, "minimal edge clearance"))*pt[1]]]];

// Odd spaced line of holes at x=0
function make_linear_odd_mounting_holes(fastener_name, length, spacing, x=0) = let(fastener=get_fastener(fastener_name), n=floor(length/spacing))[for(i = [-floor(n/2):floor(n/2)]) [fastener,[x,i*(spacing)]]];
*/

module make_mounting_hole(mounting_hole, through_all_height=1000) {
    through_hole(mounting_hole, through_all_height=through_all_height);
};



/*
Uses the dot product to sum a list
:param vector lst: vector to be sumed
:return float
*/
function sum(lst) = assert(is_list(lst))len(lst) == 0?
    0 :
    len(lst) == 1?
        lst[0] :
        lst * [for(i=[0:len(lst)-1]) 1];

assert(sum([]) == 0);
assert(sum([100]) == 100);
assert(sum([1,1,1,1]) == 4);


/*
Returns a subsection of a vector. Counts from 0.
:param vector lst
:param int start:
:param int end:
:return vector
*/
function partial(lst, start, end) = min(end, len(lst)) == start+1 ?
    [lst[start]] : //  only access a single entry
    start > min(end, len(lst))-1?
        [] :
        [for (i=[start:min(end, len(lst))-1]) lst[i]];

assert(sum(partial([1,1,1],0,1)) == 1);
assert(sum(partial([1,1,1],0,2)) == 2);
assert(sum(partial([1,1,1],0,3)) == 3);
assert(sum(partial([1,1,1],0,100)) == 3);
assert(partial([1,1,1],1,1) == []);
assert(sum(partial([1,1,1],1,1)) == 0);
assert(sum(partial([1,1,1],1,2)) == 1);
assert(sum(partial([1,1,1],1,3)) == 2);


function dict_lookup(key, dict) = 
        assert(is_string(key))
        assert(is_list(dict))
        assert(is_num(search([key], dict)[0]), str("Key Error: (", key, ") ", dict))
        dict[search([key], dict)[0]][1];

obj_ = [
    ["shape", "svg"],
    ["position", [-50,-50,5]],
    ["args", ["drawing.svg"]],
    ["name", "stars"],
    ["rotation", 0]];

assert(dict_lookup("name", obj_)=="stars");

/*
Some value way larger than our largest geometry
*/
function get_infinity() = 1000;

function all(lst) = sum([for(pt=lst) pt ? 1 : 0]) == len(lst);


function dot(v1,v2) = assert(is_list(v1)&&is_list(v2)&&(len(v1)==len(v2))) sum([for (i=[0:len(v1)-1]) v1[i]*v2[i]]);
function mdot(v,m) = assert(is_list(v)&&is_list(m)&&(len(m)==len(v))) [for (i=[0:len(m)-1]) dot(v,m[i])];

assert(dot([1,1,1], [1,1,1]) == 3);
assert(dot([1,0,0], [1,1,1]) == 1);
assert(mdot([1,1,1], matrix[0]) == [1,1,1]);
assert(mdot([1,2,3], matrix[0]) == [1,2,3]);
assert(mdot([1,2,3], matrix[1]) == [-1,-2,-3]);
assert(mdot([1,2,3], matrix[2]) == [1,3,2]);
assert(mdot([1,2,3], matrix[3]) == [-1,-3,-2]);
assert(mdot([1,2,3], matrix[4]) == [3,1,2]);
assert(mdot([1,2,3], matrix[5]) == [-3,-1,-2]);
assert(cross([1,0,0], [0,1,0]) == [0,0,1]);


    function get_upright_face_matrix() = [
    ["top", 
    [[ 1,0,0], 
     [ 0,1,0], 
     [ 0,0,1]]],  // top
    ["bottom", 
    [[-1,0,0], 
     [0,-1,0], 
     [0,0,1]]],  // bottom
    ["front", 
    [[ -1,0,0], 
     [ 0,0,1], 
     [ 0,1,0]]],  // front
    ["back", 
    [[1,0,0],
     [0,0,-1], 
     [0,1,0]]],  // back
    ["right", 
    [[ 0,0,1], 
     [ 1,0,0], 
     [ 0,1,0]]],  // right
    ["left", 
    [[0,0,-1], 
     [-1,0,0], 
     [0,1,0]]],  // left
];

function get_face_normal_vectors() = [
    ["top", [0,0,1]],
    ["bottom", [0,0,-1]],
    ["front", [0,1,0]],
    ["back", [0,-1,0]],
    ["right", [1,0,0]],
    ["left", [-1,0,0]],
];

function get_face_upright_rotation_vectors() = [
    ["top", [0,0,0]],
    ["bottom", [180,0,0]],
    ["front", [90,0,180]],
    ["back", [90,0,0]],
    ["right", [90,0,90]],
    ["left", [90,0,-90]],
];

module place_on_face(face_center_positions, face, position, rotation) {
    /*
        Make a stamp out of a 2D child. Position on the given face with the transformations
        relative to that plane.
        :param face_center_positions: dict of [{face}, [normal_vector, rotation_vector, plane center, ]]
    */
    assert(is_string(face));
    assert(is_list(face_center_positions));
    assert(is_list(position));
    assert(is_num(rotation));
    m = dict_lookup(face, get_upright_face_matrix());
    plane_position = mdot(position, m);

    face_center_position = dict_lookup(face, face_center_positions);
    setup_rotation = dict_lookup(face, get_face_upright_rotation_vectors());
    normal_vector = dict_lookup(face, get_face_normal_vectors());

    translate(plane_position)translate(face_center_position)
        rotate(rotation, normal_vector)rotate(a=setup_rotation)
        linear_extrude(get_infinity(), center=false)children();
};


function get_fonts() = ["C059",
    "Century Schoolbook L",
    "D050000L",
    "DejaVu Sans",
    "DejaVu Sans Monostyles",
    "DejaVu Serif",
    "Dingbats",
    "Droid Sans Fallback L",
    "Nimbus Mono L",
    "Nimbus Mono PS",
    "Nimbus Roman",
    "Nimbus Roman No9 L",
    "Nimbus Sans",
    "Nimbus Sans L",
    "Nimbus Sans Narrow",
    "Noto Mono",
    "P052",
    "Standard Symbols L",
    "Standard Symbols PS",
    "URW Bookman",
    "URW Bookman L",
    "URW Chancery L",
    "URW Gothic",
    "URW Gothic L",
    "URW Palladio L",
    "Z003"];