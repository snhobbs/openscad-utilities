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
