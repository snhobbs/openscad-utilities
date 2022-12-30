function get_fastener_fields() = [
    "type",
    "diameter",
    "minimal edge clearance",
    "tap diameter",
    "close clearance",
    "standard clearance",
    "wide clearance"];

function get_metric_fasteners() = [
    ["M3", "metric", 3, 4, 2.5, 3.2, 3.4, 3.4],
    ["M4", "metric", 4, 5, 3.5, 4.3, 4.5, 4.5],
    ["M10", "metric", 10, 14, 8.5, 10.67, 11, 12],
]; 

function find_fastener(name) = search([name], get_metric_fasteners())[0];
function get_fastener(name) = get_metric_fasteners()[find_fastener(name)];
function get_fastener_field_index(field) = search([field], get_fastener_fields())[0];
//function get_fastener_field(fastener, field) = fastener[get_fastener_field_index(field)];
function get_fastener_field(fastener, field) = fastener[get_fastener_field_index(field)];
function get_fastener_field_by_name(name, field) = let(fastener=get_fastener(name))get_fastener_field(fastener, field);



module hex(d=3, hd=7, hl=4, l=65) {
    translate([0,0,-(l+hl)/2+hl])cylinder(h=l, d=d, center=true);
    translate([0,0,+hl/2])cylinder(h=hl, d=hd, center=true);
};

/* takes [[fastener, postition]], hole type, returns [[hole diameter, position]]*/
function fastener_positions_to_holes(fastener_holes, hole_type) = [for(hole=fastener_holes) [get_fastener_field(hole[0], hole_type), hole[1]]];
