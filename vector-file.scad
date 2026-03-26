use<openscad-utilities/tools.scad>;

/*
Class VectorFile
    string name
    float rotation
    vector axis
    float clearance
    string file
    float scale
    float convexity
*/
    

module make_vector_image(arguments) {
    echo(arguments);
    vector_image = arguments;
    module make_vector_image_(vector_image) {
        center = dict_lookup("center", vector_image);
        scale(dict_lookup("scale", vector_image))
            rotate(dict_lookup("rotation", vector_image), dict_lookup("axis", vector_image))
                translate([-center.x, -center.y])
                    import(dict_lookup("file", vector_image), convexity=dict_lookup("convexity", vector_image));
    };
    make_vector_image_(vector_image);
};
