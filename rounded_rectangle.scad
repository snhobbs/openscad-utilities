module rounded_rectangle(width = 1, height = 1, rounding = 0) {
	if (rounding > 0) {
		non_rounded_width = width - 2*rounding;
		non_rounded_height = height - 2*rounding;

		// correct for funky minkowski displacement
		translate([-non_rounded_width/2, -non_rounded_height/2])
			minkowski() {
				square([non_rounded_width, non_rounded_height], center = true);
				translate([non_rounded_width/2, non_rounded_height/2, 0])
					circle(rounding);
			}
	} else {
		// minkowski doesn't work properly on circle with diameter 0
		square([width, height], center = true);
	}
}

rounded_rectangle(10, 10, 3);
