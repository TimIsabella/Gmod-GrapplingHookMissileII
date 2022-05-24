@name Missile Targeter Base Station

@inputs Target:entity TarNum

@outputs Targeter:vector Clear G Active
@persist C Dist TType:string T:string

interval(250)

if(duped())
  {
   Clear = 1
   soundPlay("1", 0,"buttons/button10.wav")
   soundVolume("1", 0.5)
   soundPlay("2", 0,"ambient/energy/electric_loop.wav")
   soundVolume("2", 0.5)
   hint("---GRAPPLING HOOK MISSILE II---      ", 10)
   hint("CONTROLS...                                    ", 10)
   hint("Numpad 0: Change Target                ", 10)
   hint("Numpad Delete: Fire Grapple Missile  ", 10)
   hint("Numpad +/-: Extend/Retract Winch    ", 10)
   hint("NOTE...                                            ", 10)
   hint("Extend Winch Before Firing               ", 10)
  }
   
  if (~Target & (TarNum == 0)) {hint("Target: NONE", 7)}
  
  if(Target)
   {
    if(~Target & (TarNum == 1)) 
      {
       TType = Target:type()
	   if (TType:right(8) == "thruster") {T = " - Thruster"}
       if (TType:right(9) == "hoverball") {T = " - Hoverball"}
       if (TType:right(7) == "airboat") {T = " - Airboat"}
       if (TType:right(4) == "jeep") {T = " - Jeep"}
       if (TType:right(3) == "pod") {T = " - Seat"}
       
	   hint("Target: " + Target:owner():name() + T, 7)
       T = ""
      }
   
    Active = 1
    Targeter = Target:massCenter() - entity():pos() / 500
    soundPitch("2", (Target:vel():length()/5)+200)
    Dist = Target:pos():distance(entity():pos())
    
    if (C == 0) {Clear = 0}
    if (C == 1) {Clear = 1, C -= 2}
    C+=1
    if((Dist < 3000) & ((Dist * $Dist) < 350000) & ((Dist * $Dist) > -375000))
      {
       if (C == 0) {G = 1, soundPitch("1", 200)}
       if (C == 1) {G = 0, soundPitch("1", 155)}
      }else {Active = 0, G = 0, soundPitch("1", 0)}
      
   }else {Active = 0, G = 0, soundPitch("2", 0)}
