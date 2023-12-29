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
function check_vector_image_object(obj) = 
    assert(is_list(obj), str("Arguement isn't a list ", obj))
    is_string(dict_lookup("name", obj))     &&
    is_num(dict_lookup("rotation", obj))    &&
    is_list(dict_lookup("axis", obj))    &&
    is_string(dict_lookup("file", obj))     &&
    is_list(dict_lookup("scale", obj))    &&
    is_num(dict_lookup("convexity", obj))    &&
    is_list(dict_lookup("center", obj));
    

module make_vector_image(arguments) {
    vector_image = arguments[0];
    echo(vector_image);
    assert(check_vector_image_object(vector_image));
    module make_vector_image_(vector_image) {
        center = dict_lookup("center", vector_image);
        scale(dict_lookup("scale", vector_image))
            rotate(dict_lookup("rotation", vector_image), dict_lookup("axis", vector_image))
                translate([-center.x, -center.y])
                    import(dict_lookup("file", vector_image), convexity=dict_lookup("convexity", vector_image));
    };
    make_vector_image_(vector_image);
};
