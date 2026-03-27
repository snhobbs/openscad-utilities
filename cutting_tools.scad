use<openscad-utilities/tools.scad>;
use<openscad-utilities/shapes.scad>;



// --- Implementations ---

module cut_conic_section(tool) {
    r1     = get(tool, "r1");
    r2     = get(tool, "r2");
    height = get(tool, "height");
    cylinder(h=height, r1=r1, r2=r2, center=false);
}

module cut_shape_stack(tool) {
    current_height = 0;
    for(obj=get(tool, "objects")) {
        height = get(obj, "height");
        translate([0,0,current_height]);
        linear_extrude(height)make_shape(get(obj, "shape"));
        current_height = current_height + height;
    }
    
}

module cut_text(tool) {
    linear_extrude(get_infinity())
    text(get(tool, "text"), size=get(tool, "font_size"), font=get(tool, "font"), halign=get(tool, "halign"), valign=get(tool, "valign")); 
}

/*
Outer cylinder and inner cylinder with flutes
Use n number of rectangles arranged in a circle
The outer shape is a circle and the center meeting point
is also a circle.
*/
module cut_fluted_cylinder(tool) {
    n = get(tool, "n_flutes");
    flute_width_ratio = get(tool, "flute_width_ratio");
    d = get(tool, "diameter");
    width = flute_width_ratio*d/2;
    height = get(tool, "height");
    module circular_rectangles(n, width) {
        union() {
            for (i=[0:(n-1)]) {
                rotate((360/n)*i)
                translate([0, -width/2])
                square([height,width], center=false);
            };
            circle(d=width);
        };
    };

    linear_extrude(height)
    intersection() {
        union() {
            circular_rectangles(n, width);
        };
        circle(d=d);
    };
};

module cut_inverse_fluted_cylinder(tool) {
    d = get(tool, "diameter");
    difference() {
        circle(d=d);
        fluted_circle(n=n, width=width, d=d);
    };
}



module dispatch_cut_tool(tool) {
    type = get(tool, "type");
    origin = get(tool, "origin");
    angle  = get(tool, "angle");  // unused for now but available

    translate(origin)
    rotate(angle)
    union() {
    if (type == "ConicSection") {
        cut_conic_section(tool);
    } else if (type == "ShapeStack") {
        cut_shape_stack(tool);
    } else if (type == "FlutedCylinder") {
        cut_fluted_cylinder(tool);
    } else if (type == "Text") {
        cut_text(tool);
    } else if (type == "Composite") {
        for(obj = get(tool, "objects")) {
            dispatch_cut_tool(obj);
        }
    } else {
        assert(false, str("Unknown cut tool type: ", type));
    }
    }
}
