use<fasteners.scad>
/* tools */
module through_hole(hole, through_all_height=1000){
    diameter = hole[0];
    position = hole[1];
    translate([position[0], position[1], 0])cylinder(h=through_all_height, d=diameter, center=true);
}

function make_four_corners(x, y) = [for(pt=[[1,1], [-1, 1], [1, -1], [-1, -1]]) [x*pt[0], y*pt[1]]];
    

function make_even_mounting_holes(fastener_name, size) = let(fastener=get_fastener(fastener_name))[for(pt = [[1,1], [-1,1], [1,-1],[-1,-1]]) [fastener,[(size.x/2 - get_fastener_field(fastener, "minimal edge clearance"))*pt[0], (size.y/2 - get_fastener_field(fastener, "minimal edge clearance"))*pt[1]]]];
    

function make_odd_mounting_holes(fastener_name, size) = let(fastener=get_fastener(fastener_name))[for(pt = [[1,0], [-1,0], [0,1],[0,-1]]) [fastener,[(size.x/2 - get_fastener_field(fastener, "minimal edge clearance"))*pt[0], (size.y/2 - get_fastener_field(fastener, "minimal edge clearance"))*pt[1]]]];

// Odd spaced line of holes at x=0
function make_linear_odd_mounting_holes(fastener_name, length, spacing, x=0) = let(fastener=get_fastener(fastener_name), n=floor(length/spacing))[for(i = [-floor(n/2):floor(n/2)]) [fastener,[x,i*(spacing)]]];

module make_mounting_hole(mounting_hole, through_all_height=1000) {
    through_hole(mounting_hole, through_all_height=through_all_height);
};

