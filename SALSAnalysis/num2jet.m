function RGB_values = num2jet(data)
%RGB_values = num2jet(data)
%
%Given a vector or array "data", num2jet returns RGB_values similar to those
%that would be used to construct the figure output of "image(data)" given
%that the default jet colormap was selected.
%
%author david.c.godlove@vanderbilt.edu

%load RGB values for jet(256)
R_table = uint8([0;0;0;1;0;0;0;0;0;1;1;1;2;0;0;0;0;0;1;0;0;0;1;0;0;1;0;0;0;0;0;1;0;0;0;1;0;0;1;2;0;1;0;0;1;0;0;1;0;0;2;0;0;1;0;1;0;0;0;0;0;0;0;0;0;0;1;0;0;0;0;1;0;0;0;0;0;0;0;0;0;1;2;0;1;0;0;1;0;0;1;0;0;2;0;0;0;2;8;11;14;19;23;27;31;35;39;44;47;51;57;60;62;68;73;75;79;83;88;90;95;99;104;107;111;114;120;122;126;131;135;138;143;147;151;155;159;163;168;171;175;181;183;186;192;197;198;203;207;212;215;219;223;228;231;235;240;244;246;250;255;255;255;255;255;255;255;254;255;255;254;255;255;255;255;255;255;255;255;255;255;255;255;255;255;255;255;255;255;255;255;255;255;255;255;255;255;255;255;255;255;255;255;255;255;255;255;255;255;255;255;255;255;254;255;255;255;255;255;255;255;255;255;255;254;250;246;244;238;234;230;226;223;218;214;210;208;203;199;194;190;186;183;179;174;172;166;163;159;154;150;146;143;139;135;130]);
G_table = uint8([0;0;0;0;0;0;0;1;0;0;0;0;0;0;0;0;1;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;3;7;11;15;19;23;26;31;35;39;43;47;51;55;59;63;67;70;74;79;83;87;90;96;99;104;107;111;116;119;122;127;131;134;140;143;146;151;154;158;163;167;170;175;179;182;187;191;195;198;203;207;211;215;219;223;227;231;235;239;242;247;251;255;255;255;255;255;255;255;255;254;255;255;255;255;255;254;255;255;255;254;255;254;255;255;255;255;255;255;254;255;255;255;255;255;255;255;254;255;255;255;254;255;255;255;255;255;254;255;255;255;255;255;254;255;255;254;254;255;255;255;255;255;255;255;255;255;251;247;243;239;235;230;227;223;219;215;211;207;202;199;195;190;186;183;178;175;171;166;163;159;154;151;148;142;139;135;130;127;122;119;115;111;107;103;99;95;92;87;83;79;75;71;68;63;58;56;51;47;43;39;35;30;27;23;18;14;11;6;3;0;0;1;0;0;0;0;0;1;0;0;0;0;1;1;0;0;0;1;1;0;0;0;1;1;0;0;0;1;0;0;0]);
B_table = uint8([130;130;135;138;142;146;150;154;158;163;166;171;174;178;182;186;190;194;198;202;208;210;215;218;222;226;230;234;238;244;246;251;254;255;255;255;255;255;255;255;254;255;255;254;255;255;254;255;255;254;255;255;254;255;255;254;255;255;255;255;255;255;255;255;255;255;255;255;255;255;254;255;255;255;255;255;255;254;255;255;254;255;255;254;255;255;254;255;255;254;255;255;254;255;255;254;255;252;247;243;238;235;231;227;225;219;214;212;206;202;200;195;190;187;185;179;175;171;167;163;159;154;152;147;144;140;135;130;128;123;119;117;111;107;104;99;95;92;88;82;78;77;70;66;63;59;54;51;47;43;39;36;30;28;23;18;16;11;6;3;0;1;0;0;3;0;0;0;0;0;0;2;0;0;0;0;0;0;1;0;0;0;0;0;0;0;0;0;1;0;0;2;0;0;1;0;0;1;2;0;1;1;0;0;1;1;0;1;0;0;1;0;1;0;0;0;0;0;0;0;0;0;0;0;0;1;0;2;0;0;0;1;0;0;0;0;0;1;0;0;2;1;0;1;0;0;0;0;0;0;1;0;0;3;1;0]);

%scale data to 0-255 and change to uint8
data = data - min(min(data));
data = data ./ max(max(data));
data = 256-(data * 255);
data = uint8(round(data));

%get red green and blue info from lookup tables
red = intlut(data,R_table);
green = intlut(data,G_table);
blue = intlut(data,B_table);

%combine into RGB data
RGB_values(:,:,1) = red;
RGB_values(:,:,2) = green;
RGB_values(:,:,3) = blue;