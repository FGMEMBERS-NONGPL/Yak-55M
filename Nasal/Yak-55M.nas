aircraft.livery.init("Aircraft/Yak-55M/Models/Liveries");

#Check VNE
var checkGandVNE = func {
  if (getprop("sim/freeze/replay-state"))
    return;
  var airspeed = getprop("velocities/airspeed-kt");
  var vne = getprop("limits/vne");
  if ((airspeed != nil) and (vne != nil) and (airspeed > vne))
  {
    setprop("control/canopy-not-crash", 0);
    setprop("controls/canopy/canopy-pos-norm", 1);
  }
  else
  {
    settimer(checkGandVNE, 2);
  }
}
checkGandVNE();

#Engine stop 
var StopEng = func {
var tempoil = getprop("engines/engine/oil-temperature-degf");
var rpm = getprop("engines/engine[0]/rpm");
if((tempoil != nil) and (rpm != nil) and (tempoil<104) and (rpm>2850))
{
setprop("controls/engines/engine/magnetos", 0);
setprop("control/engstop", 1);
settimer(StopEng, 15);
}
else
{
settimer(StopEng, 25);
}
}
StopEng();

#Engine stop2 
var StopEng2 = func {
var minmaxg = getprop("fdm/jsbsim/accelerations/n-pilot-z-norm[0]");
var minmaxg2 = getprop("fdm/jsbsim/accelerations/n-pilot-x-norm[0]");
var minmaxg3 = getprop("fdm/jsbsim/accelerations/n-pilot-y-norm[0]");
if( ((minmaxg != nil) and ((minmaxg<-10) or (minmaxg>7))) 
or ((minmaxg2 != nil) and ((minmaxg2<-4) or (minmaxg2>4))) 
or ((minmaxg3 != nil) and ((minmaxg3<-4) or (minmaxg3>4))) )
{
setprop("controls/engines/engine/magnetos", 0);
setprop("control/engstop2", 1);
}
else
{
settimer(StopEng2, 0.1);
}
}
StopEng2();

#Engine Gear crash
var enggear = func {
  var pitch = getprop("orientation/pitch-deg");  
  var wow1 = getprop("gear/gear[1]/wow");
  var wow2 = getprop("gear/gear[0]/wow");  
  if ( pitch != nil and pitch<-35 and (wow1==1 or wow2==1))
  {
    setprop("controls/engines/engine/magnetos", 0);
    setprop("control/engstop2", 1);
  }
  else
  {
    settimer(enggear, 0.2);
  }
}
enggear();



#Engine stop5 5min
var StopEng5 = func {
var rpm = getprop("engines/engine[0]/rpm");
var eng5 = getprop("control/engstop5");
if(eng5>300)
{
setprop("controls/engines/engine/magnetos", 0);
setprop("control/engstop", 1);
}
else
{
if(rpm!=nil and rpm>2900)
{
setprop("control/engstop5", getprop("control/engstop5")+1);
}
else
{
setprop("control/engstop5", 0);
}
settimer(StopEng5, 1);
}
}
StopEng5();






#Canopy routines
toggle_canopy = func {
  if(getprop("controls/canopy/canopy-pos-norm") > 0) {
    interpolate("controls/canopy/canopy-pos-norm", 0, 1.25);
  } else {
    interpolate("controls/canopy/canopy-pos-norm", 1, 1.25);
  }
}


#g-meter min/max needles
var gmeterUpd = func {
var gcurrent = getprop("fdm/jsbsim/accelerations/n-pilot-z-norm[0]");  
var GMin1 = getprop("control/gmin");
var GMax1 = getprop("control/gmax");
if (gcurrent != nil and gcurrent < 1 and gcurrent < GMin1)
{
setprop("control/gmin", gcurrent);
settimer(gmeterUpd, 0.125);
}
else
{
if(gcurrent != nil and gcurrent > GMax1){setprop("control/gmax", gcurrent);}
settimer(gmeterUpd, 0.125);
}
}
gmeterUpd();

 
setprop("engines/engine/fuel-flow-gph-ind", 0);
    
FP_set = func {
if(getprop("controls/engines/engine/pump")==0)
{setprop("engines/engine/fuel-flow-gph-ind",getprop("engines/engine/fuel-flow-gph-ind")+ 20);}
else{ }
};


Magneto_set = func {
if(getprop("systems/electrical/outputs/ign")>21)
{setprop("controls/engines/engine/magnetos",getprop("control/magneto"));}
else{setprop("controls/engines/engine/magnetos", 0)}
};


Starter_set = func {
if(getprop("systems/electrical/outputs/ign")>21)
{setprop("controls/engines/engine/starter",getprop("control/starter1"));}
else{ }
};


  
#radio com1 / chatter
   setprop("instrumentation/comm/frequencies/select100", 9);  
   setprop("instrumentation/comm/frequencies/select1", 20);
   setprop("instrumentation/comm/frequencies/select2", 0);
   setprop("instrumentation/comm/frequencies/selected-mhz", 127.500);
freq_set = func {setprop("instrumentation/comm/frequencies/selected-mhz", 
                 getprop("instrumentation/comm/frequencies/select100")+118+
                 0.025*getprop("instrumentation/comm/frequencies/select1"))}; 
   setprop("systems/electrical/outputs/nav-com-1",0.1);   
   setprop("instrumentation/comm/volume-set", 0.4);    
   setprop("instrumentation/comm/volume", 0);    
   setprop("sim/sound/chatter/volume", 0);    

vol_set = func {
if(getprop("systems/electrical/outputs/bus")>21)
{setprop("instrumentation/comm/volume", getprop("instrumentation/comm/volume-set"));}
else{ }
};

chvol_set = func {
if(getprop("systems/electrical/outputs/bus")>21)
{setprop("sim/sound/chatter/volume", getprop("instrumentation/comm/volume-set"));}
else{ }
};

vol_Mset = func {
if(getprop("systems/electrical/outputs/nav-com-1")>21)
{setprop("instrumentation/comm/volume", getprop("instrumentation/comm/volume-set"));}
else{ }
};

chvol_Mset = func {
if(getprop("systems/electrical/outputs/nav-com-1")>21)
{setprop("sim/sound/chatter/volume", getprop("instrumentation/comm/volume-set"));}
else{ }
};

                 
#chronometr start
    setprop("sim/time/chronom-sec0", 0);

chron_start0 = func {setprop("sim/time/chronom-sec0", getprop("sim/time/elapsed-sec"))}; 

                 