$fn=120;
sphere_facets=30; // 360;
da8 = 1 / cos(180 / 8) / 2;

thickness=3;
outer_dia=100;
inner_dia=outer_dia-(thickness*2);
PCB_mount=83.25;
PCB_offset=5;

arm_l=39;
lead_l=6.4;
lead_w=19.5;
lead_h=12.75;

/*
lead_l=12.75;
lead_w=19.5;
lead_h=6.4;
*/

*translate([0,-inner_dia/2,0]) mirror([0,0,1]) 
difference() {
	hemi(side=1,flip=0);
	rotate(40) translate([-(outer_dia/2)-1,0,0]) 
	cube([outer_dia+2,outer_dia+2,outer_dia+2],center=true);
	rotate(170) translate([-(outer_dia/2)-1,0,0]) 
	cube([outer_dia+2,outer_dia+2,outer_dia+2],center=true);
	rotate(10) rotate([208.5,0,0]) translate([-20,0,0]) cube([40,40,100]);
}



translate([0,0,0]) color("White",0.90)
hemi(side=0,flip=0);
translate([0,0,0]) color("White",0.90)
hemi(side=1,flip=0);

//rotate(15) 
translate([0,0,9]) mirror ([0,0,1])
color("White",0.90) arm();

PCB();

module PCB() union() {
	color("DarkGreen",0.75) 
	translate([PCB_offset,0,0]) rotate([90,0,90]) intersection() {
		cylinder(r=(3.5*25.4)/2,h=1.6);
		translate([-(3.5*25.4)/2,-1.5*25.4,-1]) 
		cube([3.5*25.4,1.5*25.4,1.6+2]);
	}
	color("Black",0.75)
	rotate([-39,0,0]) translate([-6.15,((3.5*25.4)/2)-12,-9/2])
	cube([11,15,9]);
}

module arm() difference() {
	union() {
		cylinder(r=6,h=8,$fn=32);
		translate([arm_l-lead_l-1.5,-(lead_w)/2,-(lead_h+3-6)]) 
		cube([lead_l+1.5,lead_w,lead_h+3]);
		translate([0,-2,0]) cube([arm_l,4,6]);

		*translate([arm_l-lead_l-6,-2,-(lead_h+3-6)])
		cube([6,4,lead_h+3]);
	}
	// motor shaft
	translate([0,0,-0.5]) rotate(22.5) cylinder(r=3*da8,h=9,$fn=8);

	// M2 set screw
	translate([0,0,4]) rotate([-90,0,0]) rotate(22.5) 
	cylinder(r=2*da8,h=8,$fn=8);

	// M2 captive nut
	translate([-4.25/2,2.5,1.25]) cube([4.25,1.75,8]);

	// lead weight
	translate([arm_l-lead_l,-(lead_w/2)-0.1,-(lead_h+1.5-6)]) 
	cube([lead_l+0.1,lead_w+0.2,lead_h]);
}

// hemi side 0=upper 1=lower
module hemi(side,flip) mirror ([0,0,flip]) difference() { 
	union() {
		intersection() { union() {
		if(side) translate([0,0,-thickness/2]) difference() {
			cylinder(r=outer_dia/2+1,h=thickness,center=true);
			cylinder(r=inner_dia/2+1,h=thickness*2,center=true);
		}
		else translate([0,0,thickness/2]) difference() {
			cylinder(r=outer_dia/2+1,h=thickness,center=true);
			cylinder(r=inner_dia/2+1,h=thickness*2,center=true);
		}
		rotate([2,0,0]) for (i=[0:4]) rotate([i*(180/5),0,0]) difference() {
			cylinder(r=outer_dia/2+1,h=thickness,center=true);
			cylinder(r=inner_dia/2+1,h=thickness*2,center=true);
		}
		rotate(55) for (i=[0:7]) rotate([0,i*(180/8),0]) difference() {
			cylinder(r=outer_dia/2+1,h=thickness,center=true);
			cylinder(r=inner_dia/2+1,h=thickness*2,center=true);
		}
		rotate(146) for (i=[0:5]) rotate([0,i*30,0]) difference() {
			cylinder(r=outer_dia/2+1,h=thickness,center=true);
			cylinder(r=inner_dia/2+1,h=thickness*2,center=true);
		}
		rotate([64,20,0]) for (i=[0:2]) rotate([i*(180/3),0,0]) difference() {
			cylinder(r=outer_dia/2+1,h=thickness,center=true);
			cylinder(r=inner_dia/2+1,h=thickness*2,center=true);
		}
		rotate([290,108,0]) for (i=[0:6]) rotate([i*(180/7),0,0]) difference() {
			cylinder(r=outer_dia/2+1,h=thickness,center=true);
			cylinder(r=inner_dia/2+1,h=thickness*2,center=true);
		}
		}
		sphere(r=outer_dia/2,$fn=sphere_facets);
		}
		if (side) for (i=[0:3]) rotate(i*120) {
			translate([(inner_dia/2)-(thickness/2),0,-10]) 
			cylinder(r=3.5,h=10,$fn=36);
		} else for (i=[0:3]) rotate(i*120) {
			translate([(inner_dia/2)-(thickness/2),0,0]) 
			cylinder(r=3.5,h=10,$fn=36);
		}
		if (side) intersection() {
			translate([PCB_offset-thickness,0,0]) rotate([0,90,0])
			cylinder(r=(outer_dia/2)-0.25,h=thickness);

			for (i=[0,1]) mirror([0,i,0]) union() {
				translate([PCB_offset-thickness,-outer_dia/2,-6]) 
				cube([thickness,(outer_dia-PCB_mount)/2,6]);
				translate([PCB_offset-thickness,-PCB_mount/2,-3])
				rotate([0,90,0]) cylinder(r=3,h=thickness,$fn=32);
			}
		}
	}
	if (side) {
		// take off the top
		translate([0,0,(outer_dia/2)+1])
		cube([outer_dia+2,outer_dia+2,outer_dia+2],center=true);

		// plug height 11mm, width 9mm
		rotate([-39,0,0]) translate([-6.1,0,-9.6/2])
		cube([11.1,(inner_dia/2)+1.25,9.65]);

		// center pin 6.5mm from pcb
		rotate([-39,0,0]) translate([-(6.5-PCB_offset),-thickness*0.75,0]) 
		rotate([-90,0,0]) cylinder(h=(inner_dia/2)+(thickness*2),r=4);

		// PCB mounting holes
		for (i=[0,1]) mirror([0,i,0]) 
		translate([-2,-PCB_mount/2,-0.1125*25.4]) rotate([0,90,0]) 
		cylinder(r=1.625,h=thickness*4,$fn=24);

		// lower magnets
		for (i=[0:3]) rotate(i*120)translate([(inner_dia/2)-(thickness/2),0,-11.1]) 
			cylinder(r=2.1,h=11.2,$fn=16);
	} else { 
		// take off the bottom
		translate([0,0,(-outer_dia/2)-1]) 
		cube([outer_dia+2,outer_dia+2,outer_dia+2],center=true);

		// upper magnets
		for (i=[0:3]) rotate(i*120)translate([(inner_dia/2)-(thickness/2),0,-0.1]) 
			cylinder(r=2.1,h=11.2,$fn=16);
	}
}
