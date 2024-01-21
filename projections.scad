/*
  Modules for sweeping out shapes and outlines

*/


module swept_stl(start, end, file, n=16) {
    step = [(end.x-start.x)/n, (end.y-start.y)/n, (end.z-start.z)/n];
    union() {
        for(i=[0:n]) {
            translate([step.x*i, step.y*i, step.z*i])import(file);
        };
    };
}

module sweep_vector(file, epsilon, n=32) {
    step = [epsilon*2/n, epsilon*2/n];
    union() {
        for(ix=[0:n]) {
            for(iy=[0:n]) {
                translate([step.x*ix-epsilon, step.y*iy-epsilon])fill()projection()import(file);
            };
        };
    };
};

/*
difference() {
    linear_extrude(10)square(100);
    translate([25,25,0])import( "/home/simon/projects/noiseFilters/test-jig/V0.3.X/sallen-key-noise-filter_0.1.X.stl");
};

translate([25,25,0])import( "/home/simon/projects/noiseFilters/test-jig/V0.3.X/sallen-key-noise-filter_0.1.X.stl");
*/
file_ = "/home/simon/projects/noiseFilters/test-jig/V0.3.X/sallen-key-noise-filter_0.1.X.stl";

//linear_extrude(10)square(100, center=true);

//swept_stl([0,0,100], [0,0,0], file=file_, n=320);
vector_file_ = "/home/simon/Desktop/projections.svg";


sweep_vector(file_, epsilon=15, n=32);

/*
difference() {
    import("/home/simon/Desktop/projections-swept.svg");
    import(vector_file_);
};
*/
