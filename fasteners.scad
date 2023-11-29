use<openscad-utilities/tools.scad>;


/*
Class Fastner:
string name: Class name
string size: Size of screw
string standard: Standard metric/english
float tap diameter: Diameter of tapped screw size
float close diameter: Diameter of close clearance hole
float standard diameter: Diameter of standard clearance hole
float wide diameter: Diameter of wide clearance hole
*/
function get_fastener_fields() = [
    "name",
    "size",
    "standard",
    "diameter",
    "tap diameter",
    "close clearance",
    "standard clearance",
    "wide clearance"];

function get_metric_fasteners_() = [
    ["Fastner", "M3", "metric", 3, 2.5, 3.2, 3.4, 3.4],
    ["Fastner", "M4", "metric", 4, 3.5, 4.3, 4.5, 4.5],
    ["Fastner", "M10", "metric", 10, 8.5, 10.67, 11, 12],
]; 

function get_metric_fasteners() = concat([
    for(fastener=get_metric_fasteners_())
        [fastener[1], ["Arguments", [ for(i=[0:len(get_fastener_fields())-1]) [get_fastener_fields()[i], fastener[i]] ]]
]]);
        
echo(get_metric_fasteners());

module hex(d=3, hd=7, hl=4, l=65) {
    translate([0,0,-(l+hl)/2+hl])cylinder(h=l, d=d, center=true);
    translate([0,0,+hl/2])cylinder(h=hl, d=hd, center=true);
};


/* 
Class Hole:
string name: Class name
list [float x, float y, float z] position: Position of hole
float rotation: Rotation of hole
list [float x, float y, float z] axis: Axis of rotation
float depth: Depth of hole
*/
