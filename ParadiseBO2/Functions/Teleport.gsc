tpToSpot(coords)
{
    self setorigin(coords);
}

spawn_set()
{
    self.spawn_origin = self.origin + (0, 0, 1);
    self.spawn_angles = self.angles;
    self iprintln( "Spawn: ^2Set" );
}
unsetSpawn()
{
    self.spawn_origin = undefined;
    self.spawn_angles = undefined;
    self iprintln( "Spawn: ^1Reset" );
}
saveandload()
{
    if( self.snl == 0 )
    {
        self iprintln( "To Save: Prone + [{+Attack}]");
        self iprintln( "To Load: Crouch + [{+Actionslot 4}]" );
        self thread dosaveandload();
        self.snl = 1;
    }
    else
    {
        self iprintln( "Save and Load [^1OFF^7]" );
        self.snl = 0;
        self notify( "SaveandLoad" );
    }
}

dosaveandload()
{
    self endon( "disconnect" );
    self endon( "SaveandLoad" );
    load = 0;
    while(self.pers["SavingandLoading"] == true)
    {
        if( self.snl == 1 && self attackbuttonpressed()  && self GetStance() == "prone" )
        {
            self.o = self.origin;
            self.a = self.angles;
            self.pers["location"] = self.origin;
            self.pers["savedLocation"] = self.origin;
            load = 1;
            self iprintln( "Position ^2Saved" );
            wait 2;
        }
        if( self.snl == 1 && self.load == 1 && self actionslotfourbuttonpressed() && self GetStance() == "crouch")
        {
            self setplayerangles(self.a);
            self setOrigin(self.pers["savedLocation"]);
            wait 2;
        }
        wait 0.05;
    }
}
waitframe()
{
    wait 0.05;
}
//Aftermath
aft1()
{
    self setorigin((-670.031, -1063.55, 111.657));
}
aft2()
{
    self setorigin((1112.69, 76.0562, 115.125));
}
aft3()
{
    self setorigin((1496.2, 3863.82, 133.125));
}
aft4()
{
    self setorigin((-634.048, 7441.26, -463.887));
}
aft5()
{
    self setorigin((-1778.4, 5631.22, 51.3185));
}

//Carrier
car1()
{
    self setorigin((-4941.43, -1153.81, -163.875));
}
car2()
{
    self setorigin((2040.76, 836.045, 70.5574));
}
car3()
{
    self setorigin((-177.286, -1350.64, -267.875));
}
car4()
{
    self setorigin((-3661.62, 1314.41, -302.875));
}

//Express
exp1()
{
    self setorigin((-10.5211, 2375.24, 150.793));
}
exp2()
{
    self setorigin((-24.6459, -2331.52, 155.49));
}
exp3()
{
    self setorigin((-3948.26, 4425.08, 1220.14));
}
exp4()
{
    self setorigin((4073.33, -2969.08, 92.2084));
}
exp5()
{
    self setorigin((3637.17, 2872.82, 170.579));
}
exp6()
{
    self setorigin((-6756.28, -2024.63, 1392.56));
}
exp7()
{
    self setorigin((-7042.23, -7373.21, 1392.85));
}
exp8()
{
        self setorigin(( 4675.43, 5027.02, 678.605));
}
exp9()
{
        self setorigin(( 5612.52, 3459.54, -793.319));
}
 exp10()
{
        self setorigin(( 5551.98, -3458.61, -777.233));
}

//Raid
rai1()
{
    self setorigin((2852.81, 4544.64, 265.129));
}
rai2()
{
    self setorigin((-104.969, 3769.45, 240.125)); 
}
rai3()
{
    self setorigin((1814.13, 957.054, 432.095));
}
rai4()
{
    self setorigin((2721.5, 4763.77, 137.625));
}

//Slums
slu1()
{
    self setorigin((-2499.07, 4351.68, 1297.82)); 
}
slu2()
{
    self setorigin((1732.51, -1828.43, 896.125));
}
slu3()
{
    self setorigin((145.815, -6037.59, 991.738));
}
slu4()
{
    self setorigin((-2850.07,-3227.78, 1175.54));
}
slu5()
{
    self setorigin((-7128.08, -548.743, 1192.19));
}

//Standoff
sta1()
{
    self setorigin((-1411.22, 16745.9, 4101.9));
}
sta2()
{
    self setorigin((-10215.6, 15513.1, 3895.12));
}
sta3()
{
    self setorigin((-1356.28, 3736.36, 288.111));
}
sta4()
{
    self setorigin((2075.27, -1293.44, 913.854));
}
sta5()
{
    self setorigin((26799.9, 8815.1,2471.32));
}
sta6()
{
    self setorigin((856.266, 1548.07, 222.173));
}

//Turbine
tur1()
{
    self setorigin((-864.64, 1384.38, 832.125));
}
tur2()
{
    self setorigin((-1234.51, -3150.97, 440.166));
}
tur3()
{
    self setorigin((-200.276, 3195.93, 607.911));
}
tur4()
{
    self setorigin((-207.78, -633.604, -562.192));
}

//Yemen
yem1()
{
    self setorigin((818.847, 2835.1, 1165.13)); 
}
yem2()
{
    self setorigin((2466.79, 1417.62, 1132.13));
}
yem3()
{
    self setorigin((1448.92, 2711.74, 481.618));
}
yem4()
{
    self setorigin((-2136.67,-458.23, 623.151));
}
yem5()
{
    self setorigin((-2806.68, 4511.62, 124.697));
}

//Nuketown
nuk1()
{
    self setorigin((-1544.37, -1190.4, 66.425));
}
nuk2()
{
    self setorigin((2313.04, 1383.95, 123.136));
}
nuk3()
{
    self setorigin((65.946, 2442.77, 332.652));
}
nuk4()
{
    self setorigin((51.3779, -1670.54, 186.523));
}
nuk5()
{
    self setorigin((-1786.16, 1227.62, 91.9677));
}

//Cargo
carg1()
{
    self setorigin((-624.898, 5597.46, 231.779));
}
carg2()
{
    self setorigin((-10606.7, 2978.56, -54.2118));
}

//Plaza
Plaza1()
{
    self setorigin((-19462.7,-2026.44, -1809.66));
}

//Overflow
ovrf1()
{
    self setorigin((28568, 7357.5, 1873.19));
}

//Drone
dro1()
{
    self setorigin((-19462.7, -2026.44, -1809.66));
}
dro2()
{
    self setorigin((-347.772, 8793.04, 316.212));
}
dro3()
{
    self setorigin((15425.4, -3109.07, 4333.52));
}

//Hijacked
Hijk1()
{
    self setorigin((6336.61, -45.2595, 16137.9));
}
Hijk2()
{
    self setorigin((-6175.68, 808.258, 16131.3));
}

//Cove
Cov1()
{
    self setorigin((707.339,5926.26, 1604.02));
}
Cov2()
{
    self setorigin((2099.6, -4079.84, 1604.26));
}

//Dig
dig1()
{
    self setorigin((-1230.85, 2097.92, 514.771));
}
dig2()
{
    self setorigin((-2150.26, -373.214, -229.744));
}
dig3()
{
    self setorigin((-2150.26, -373.214, -229.744));
}

//Downhill
dow1()
{
    self setorigin((-445.155, -6253.96, 1875.99));
}
dow2()
{
    self setorigin((618.708, -6218.16, 1882.27)); 
}
dow3()
{
    self setorigin((3109.17, 656.519, 1536.13)); 
}
dow4()
{
    self setorigin((-1430.35, 9408.64, 2597.38)); 
}
dow5()
{
    self setorigin((-8987.19, 327.561, 2942.54)); 
}

//Hydro
hyd1()
{
    self setorigin((3379.91, 3255.91, 216.125));
}
hyd2()
{
    self setorigin((7962.86, 22554.8, 8040.13));
}
hyd3()
{
    self setorigin((-3333.74, 4064.11, 216.125));
}
hyd4()
{
    self setorigin((-11819.2, 22546.4, 8040.13));
}

//Grind
gri1()
{
    self setorigin((3317.06, -58.111, -19.875));
}

//Encore
enc1()
{ 
    self setorigin((63.2687, 3551.01, 448.125));
}
enc2()
{
    self setorigin((-2913.65, 1931.51, 448.125)); 
}
enc3()
{
    self setorigin((-1849.62, 527.147, -419.875));
}

//Magma
mag1()
{
    self setorigin((112.567, -1921.86, -305.969));
}
mag2()
{
    self setorigin((3614.09, 1368.04, -831.875));
}
mag3()
{
    self setorigin((-1248.7, -3339.31, 14.125));
}

//Vertigo
ver1()
{
    self setorigin((4223.33, 401.677, 1856.13));
}
ver2()
{
    self setorigin((-2816.21, -75.111, 624.125));
}
ver3()
{
    self setorigin((4227.99, -2380.09, -319.875));
}
ver4()
{
    self setorigin((4052.68, 3363.54, -319.875));
}
ver5()
{
    self setorigin((-14.5213,-2853.14,-2440.15));
}

//Studio
stu1()
{
    self setorigin((538.681, -1569.16, 220.093)); 
}
stu2()
{
    self setorigin((558.137, 846.333, 145.502));
}

//Detour
det1()
{
    self setorigin((-3585.75, -735.356, 223.125));
}
det2()
{
    self setorigin((3951.57, 447.974, -13.8756));
}
//Pod
pod1()
{
    self setorigin((-3585.75, -735.356, 223.125));
}
pod2()
{
    self setorigin((-332.219, 3108.55, 1553.93));
}

//Mirage
mir1()
{
    self setorigin((299.493, 3580.54, -288.084));
}

teleportSelf(coords)
{
    self setorigin(coords);
}
