// Base Number of Faces
$fn = 40;

// Face Diameter
face_diameter = 18; // [8:23]
face_radius = face_diameter/2;

// Face Thickness
face_thickness = 3; // [2:0.1:7]

// Total Key Height
key_height = 10.5; // [6:0.1:15]

// Text on Face
text = "A";

// Text Depth
text_depth = 1; // [0.1:0.1:5]

// Fillet Radius
curve_radius = 3.37; // [0.5:0.1:5]

// Stem Diameter
stem_diameter = 5.65; // [4.2:0.1:6]
stem_radius = stem_diameter/2;

// Cross Thickness (make small changes only)
cross_thickness = 1.26;

// Cross Width (make small changes only)
cross_width = 4.2;
cross_depth = key_height - face_thickness;


// Cutter tool for the cross
module cross_cutter() {
  translate([0, 0, face_thickness + (cross_depth/2)]) {
    cube([cross_thickness, cross_width, cross_depth], center = true);
    rotate([0, 0, 90]) {
      cube([cross_thickness * 1.1, face_diameter, cross_depth], center = true);
    }
  }
}

// Rest of the key construction
translate([0, 0, 0]) {
  difference() {
    hull() {
      face_thickness_quarter = face_thickness/4;
      cylinder(r = face_radius*0.875, h = face_thickness_quarter, $fn = $fn * 2);
      translate([0, 0, face_thickness_quarter * 0.8]) {
        cylinder(r = face_radius*0.95, h = face_thickness_quarter, $fn = $fn * 2);
      }
      translate([0, 0, face_thickness_quarter * 2]) {
        cylinder(r = face_radius, h = face_thickness_quarter, $fn = $fn * 2);
      }
      translate([0, 0, face_thickness_quarter * 3]) {
        cylinder(r = face_radius, h = key_height - face_thickness, $fn = $fn * 2);
      }
    }

    cross_cutter();

    translate([0, 0, face_thickness]) {
      union() {
        translate([0, 0, curve_radius]) {
          difference() {
            cylinder(r = stem_diameter * 2, h = key_height - face_thickness);
            cylinder(r = stem_radius, h = key_height - face_thickness);
          }
        }
        difference() {
          cylinder(r = face_radius * 2, h = key_height - face_thickness);
          cylinder(r = stem_radius + curve_radius, h = key_height - face_thickness);
        }
        rotate_extrude(convexity = 10) {
          translate([stem_radius + curve_radius, curve_radius, 0]) {
            circle(r = curve_radius);
          }
        }
      }
    }
    linear_extrude(text_depth) {
      translate([0, -0.2, 0]) {
        rotate([180, 0, 90]) {
          text(text, font = "Lato:style=Bold", halign = "center", valign = "center", size = (face_diameter * 0.5));
        }
      }
    }
  }
}
