// fully parametric 90° fan mount 
// by zeus (zeus@ctdo.de)
//
// important: due to the fact that openscad calculates variables at compile time and not at runtime, you should take care to set "fan_size" AND "hole_dist" according to the table; otherwise your holes may be placed out of the model.
// some notes on fan-dimensions:
// 1) all values in mm!
// 2) i don't own specimen of all existing fan-sizes. if you are missing a special size for a fan you have let me know, then i will list it here too. -> email me at zeus@ctdo.de
// 3) fan screw holes are usually 4.5mm in diameter (60mm, 80mm, 120mm, 140mm,...). 40mm fans have 3.5mm holes.
// 4) the center-to-center-distance of the mounting holes is as following:
//		 25mm fan: ?    mm
//		 30mm fan: ?    mm
//		 40mm fan: 32   mm
//		 60mm fan: 50   mm
//		 80mm fan: 71.5 mm
//		 92mm fan: 82.5 mm
//		120mm fan: 105  mm
//		135mm fan: 120  mm
//		140mm fan: 125  mm
//		200mm fan: ?    mm (attention, various versions! some don't have a squared outside-frame. don't use the adapter on these ones.)
//		note that these distances are normaly given with a tolerance of up to +- 0.5mm.
// 5) some fans are very thick. better use countersink screws for surface mount then.
//
//
//
//
//
//
//
//
//---------------------------------------
//---------------------------------------
//
//some basic variables to adjust:
fan_size		= 80;		// fan side-length in mm
hole_dist	= 71.5;	// fan's center-to-center hole distance. see table above
material_t	= 5;		// thickness of the "walls" of the mount
f_mnt_holes_dia = 4.75;	// diameter for fan holes, better add 0.3 or something to the fan-holes
s_mnt_holes_dia = 4.5;	// hole diameter of surface mount holes
extra_height = 3;		// extra height above surface
extra_depth = 0;		// extra depth of the surface flange
extra_width	= 3;		// extra width of the mount over the fan; improves stability of the fan mounting holes. set to '0' if needed
countersunk_surface = 1;		// set to 1 if you want to use countersunk screws for the surface mount holes. will generate sunks on the screw holes
countersunk_fan = 0;		// same as above, only for the fan mount holes
//
//
//
//---------------------------------------
//---------------------------------------
// better not adjust these ones ;-)  :
mount_width = fan_size+extra_width;
wheel_d = fan_size*0.98;
l_base = mount_width;
w_base = fan_size/4+extra_depth;
t_base = material_t;
l_wall = mount_width;
w_wall = material_t;
t_wall = fan_size/4+material_t+extra_height;


module mountscrewhole(){
if (countersunk_surface == 1) {
difference() {
cylinder(h = material_t+0.2, r1 = 0, r2 = s_mnt_holes_dia*0.75, $fn=30);
}
cylinder(r = s_mnt_holes_dia/2,material_t+0.2, $fn=30); }
else {
cylinder(r = s_mnt_holes_dia/2,material_t+0.2, $fn=30); }
}

module fanscrewhole() {
if (countersunk_fan == 1) {
difference() {
cylinder(h = material_t+0.2, r1 = 0, r2 = f_mnt_holes_dia*0.75, $fn=30);
}
cylinder(r = f_mnt_holes_dia/2,w_wall+0.2, $fn=30);}
else {
cylinder(r = f_mnt_holes_dia/2,w_wall+0.2, $fn=30);}
}

module base() {
	difference() {
		translate ([-l_base/2, -w_base/2, 0]) {
			cube([l_base, w_base, t_base]); }
		translate ([-l_base/3,0,-0.1]){
			mountscrewhole(); } //surface mounting hole
		translate ([l_base/3,0,-0.1]) {
			mountscrewhole(); } //surface mounting hole	
	}
}

module wall(){
	translate ([-l_wall/2, w_base/2, -0]){
	difference(){
		cube([l_wall, w_wall, t_wall+material_t]);
			rotate (a =90, v = [1,0,0]){
				translate([mount_width/2-hole_dist/2,f_mnt_holes_dia/2+material_t+extra_height,-material_t-0.1]){
					fanscrewhole(); //fan mounting hole
							}
				translate([mount_width/2+hole_dist/2,f_mnt_holes_dia/2+material_t+extra_height,-material_t-0.1]){
					fanscrewhole(); //fan mounting hole
				}
			}
		}
	}
}

module carving()	{
		translate ([0,w_base/2+material_t+0.1,wheel_d/2+material_t+extra_height]){
 		rotate (a =90, v = [1,0,0])	{
			cylinder (r = wheel_d/2, h = material_t+0.2, $fn=50);
			translate ([-mount_width,-wheel_d/2*0.5,0])		{
				cube ([mount_width*2,wheel_d/2,material_t+0.2]);}
															}
											}
						}


module fan_mount()	{
base();
difference()	{
	wall();
	carving();	}
							}

fan_mount();










































