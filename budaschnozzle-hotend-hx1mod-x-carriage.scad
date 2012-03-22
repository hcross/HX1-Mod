// basic measures
plate_width_original = 63.5; // original
plate_width_original_depth = 4;
plate_width = 75;
plate_length = 88.9;
plate_height = 12;

// hot end
hotend_diameter = 43;
hotend_height = 52;
hotend_holder_height = 6.5;
hotend_holder_width = 28;
hotend_holder_length = 71;
hotend_holder_holes_distance_to_center = 27.81;
hotend_holder_holes_diameter = 4;
hotend_holder_holes_precision = 64;
hotend_screw_head_height = 3;
hotend_z_distance = plate_height/2 - hotend_holder_height - hotend_screw_head_height;
hotend_retraction_gap = 1;

// H1 bearing
h1_bearing_open_axis_distance = 1.1;
h1_bearing_width = 13.35;
h1_bearing_length = 89.5;
h1_bearing_height = 39;
h1_bearing_holes_diameter = 3.8;
h1_bearing_holes_back_distance = 6;
h1_bearing_holes_front_distance = 6;
h1_bearing_holes_open_axis_distance = 9.5;
h1_bearing_holes_precision = 16;
h1_bearing_holes_headscrew_diameter = 6;
h1_bearing_holes_headscrew_depth = 2.4;

// extruder constants
extruder_hold_screw_distance_to_front = 6.4;
extruder_hold_screw_diameter = 5.1;
extruder_back_retraction_back_distance = 5.1;
extruder_back_retraction_open_axis_distance = 16.4;
extruder_back_retraction_holding_height = 5;
extruder_back_retraction_holding_depth = 3;

// top hollows
top_hollow_open_axis_distance = 4.9;
top_hollow_front_distance = 16.4;
//top_hollow_width = 15.5;
top_hollow_width = 16;
top_hollow_length = 15.5;
top_hollow_depth = 3;

// belt screw holes
belt_screw_holes_bearing_screw_distance = 7;
belt_screw_holes_diameter = 3.3;
belt_screw_holes_depth = 10;
belt_screw_holes_inner_distance = 6;
belt_screw_holes_precision = 16;

// screw_holes scale ratio
screw_holes_scale_ratio = 1.1;


%h1_bearings();
%hot_end();


difference() {
	difference() {
		cube(size=[plate_width, plate_length, plate_height], center=true);
		original_width();
		extruder_back_retraction();
		hot_end_retraction();
		top_hollows();
		belt_screw_holes();
		fan_duct_screw_holes();
	}
	passthrough_holes();
}

module passthrough_holes() {
	hot_end_passthrough();
	h1_bearing_holes();
	extruder_hold_screw_hole();
	hot_end_holder_holes();
}

module hot_end_passthrough() {
	cylinder(r = hotend_diameter/2, h=plate_height, center=true, $fn = 256);
}

module h1_bearings() {
	color("Blue", 0.5) {
		translate([-plate_width/2 + h1_bearing_width/2 + h1_bearing_open_axis_distance, 0, -h1_bearing_height/2 - plate_height/2]) cube(size=[h1_bearing_width, h1_bearing_length, h1_bearing_height], center=true);
		translate([plate_width/2 - h1_bearing_width/2 - h1_bearing_open_axis_distance, 0, -h1_bearing_height/2 - plate_height/2]) cube(size=[h1_bearing_width, h1_bearing_length, h1_bearing_height], center=true);
	}
}

module h1_bearing_holes() {
	translate([-plate_width/2 + h1_bearing_holes_open_axis_distance, -plate_length/2 + h1_bearing_holes_front_distance, 0]) h1_bearing_hole();
	translate([plate_width/2 - h1_bearing_holes_open_axis_distance, -plate_length/2 + h1_bearing_holes_front_distance, 0]) h1_bearing_hole();
	translate([-plate_width/2 + h1_bearing_holes_open_axis_distance, plate_length/2 - h1_bearing_holes_back_distance, 0]) h1_bearing_hole();
	translate([plate_width/2 - h1_bearing_holes_open_axis_distance, plate_length/2 - h1_bearing_holes_back_distance, 0]) h1_bearing_hole();
}

module h1_bearing_hole() {
	union() {
		cylinder(r = screw_holes_scale_ratio*h1_bearing_holes_diameter/2, h = plate_height, center = true, $fn = h1_bearing_holes_precision);
		translate([0,0,(plate_height - h1_bearing_holes_headscrew_depth)/2]) cylinder(r = screw_holes_scale_ratio*h1_bearing_holes_headscrew_diameter/2, h = h1_bearing_holes_headscrew_depth, center = true, $fn = h1_bearing_holes_precision);
	}
}

module extruder_hold_screw_hole() {
	translate([0, -plate_length/2 + extruder_hold_screw_distance_to_front, 0]) cylinder(r = screw_holes_scale_ratio*extruder_hold_screw_diameter/2, h = plate_height, center = true, $fn = 64);
}

module extruder_back_retraction() {
	union() {
		translate([0, plate_length/2 - extruder_back_retraction_back_distance/2, 0]) cube(size = [plate_width - 2*extruder_back_retraction_open_axis_distance, extruder_back_retraction_back_distance, plate_height], center = true);
		translate([0, plate_length/2 - (extruder_back_retraction_back_distance + extruder_back_retraction_holding_depth)/2, -extruder_back_retraction_holding_height/2]) cube(size = [plate_width - 2*extruder_back_retraction_open_axis_distance, extruder_back_retraction_back_distance + extruder_back_retraction_holding_depth, plate_height - extruder_back_retraction_holding_height], center = true);
	}
}

module hot_end() {
	color("Red", 0.5) translate([0,0,hotend_z_distance + hotend_holder_height/2]) {
		cube(size = [hotend_holder_width, hotend_holder_length, hotend_holder_height], center = true);
		translate([0,0,-hotend_height/2 - hotend_holder_height/2]) cylinder(r = hotend_diameter/2, h = hotend_height, center = true);
	}
}

module hot_end_retraction() {
	translate([0,0,hotend_z_distance + plate_height/2]) cube(size = [hotend_holder_width + hotend_retraction_gap, hotend_holder_length + hotend_retraction_gap, hotend_holder_height + hotend_screw_head_height + hotend_retraction_gap], center = true);
}

module hot_end_holder_holes() {
	translate([0, -hotend_holder_holes_distance_to_center, 0]) cylinder(r = screw_holes_scale_ratio*hotend_holder_holes_diameter/2, h = plate_height, center = true, $fn = hotend_holder_holes_precision);
	translate([0, hotend_holder_holes_distance_to_center, 0]) cylinder(r = screw_holes_scale_ratio*hotend_holder_holes_diameter/2, h = plate_height, center = true, $fn = hotend_holder_holes_precision);
}

module top_hollows() {
	translate([-plate_width_original/2 + top_hollow_width/2 + top_hollow_open_axis_distance, -plate_length/2 + top_hollow_length/2 + top_hollow_front_distance, plate_height/2 - top_hollow_depth/2]) cube(size = [top_hollow_width, top_hollow_length, top_hollow_depth], center = true);
	translate([plate_width_original/2 - top_hollow_width/2 - top_hollow_open_axis_distance, -plate_length/2 + top_hollow_length/2 + top_hollow_front_distance, plate_height/2 - top_hollow_depth/2]) cube(size = [top_hollow_width, top_hollow_length, top_hollow_depth], center = true);
}

module belt_screw_holes() {
	translate([-plate_width/2 + h1_bearing_holes_open_axis_distance + belt_screw_holes_bearing_screw_distance, -plate_length/2 + belt_screw_holes_depth/2, 0]) belt_screw_holes_pair();
	translate([plate_width/2 - h1_bearing_holes_open_axis_distance - belt_screw_holes_bearing_screw_distance, -plate_length/2 + belt_screw_holes_depth/2, 0]) belt_screw_holes_pair();
}

module belt_screw_holes_pair() {
	rotate(a=90, v=[1,0,0]) {
		union() {
			translate([0,-belt_screw_holes_inner_distance/2,0]) cylinder(r = screw_holes_scale_ratio*belt_screw_holes_diameter/2, h = belt_screw_holes_depth, center = true, $fn = belt_screw_holes_precision);
			translate([0,belt_screw_holes_inner_distance/2,0]) cylinder(r = screw_holes_scale_ratio*belt_screw_holes_diameter/2, h = belt_screw_holes_depth, center = true, $fn = belt_screw_holes_precision);
		}
	}
}

module fan_duct_screw_holes() {
	translate([-plate_width/2 + h1_bearing_holes_open_axis_distance/2, plate_length/2 - belt_screw_holes_depth/2, -plate_width_original_depth/2]) rotate(a=90, v=[1,0,0]) cylinder(r = screw_holes_scale_ratio*belt_screw_holes_diameter/2, h = belt_screw_holes_depth, center = true, $fn = belt_screw_holes_precision);
	translate([plate_width/2 - h1_bearing_holes_open_axis_distance/2, plate_length/2 - belt_screw_holes_depth/2, -plate_width_original_depth/2]) rotate(a=90, v=[1,0,0]) cylinder(r = screw_holes_scale_ratio*belt_screw_holes_diameter/2, h = belt_screw_holes_depth, center = true, $fn = belt_screw_holes_precision);
}

module original_width() {
	//plate_width_original_depth
	fit_to_original = (plate_width - plate_width_original) / 2;
	translate([(fit_to_original - plate_width)/2,0,(plate_height - plate_width_original_depth)/2]) cube(size=[fit_to_original, plate_length, plate_width_original_depth], center=true);
	translate([(-fit_to_original + plate_width)/2,0,(plate_height - plate_width_original_depth)/2]) cube(size=[fit_to_original, plate_length, plate_width_original_depth], center=true);
}
