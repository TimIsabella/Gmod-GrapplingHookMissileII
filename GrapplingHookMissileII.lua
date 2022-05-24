@name Grappling Hook Missile II

@inputs Fire Target:entity R1 R2 R3 R4

@outputs Nail

@persist GPS:vector Dist
@persist Tvel Gvel LV:vector GV:vector LM IM
@persist Nailer N
@persist Difference:vector EP:vector EU:vector
@persist Launch LS Thr

interval(10)

if(Fire) {Launch = 1}

if(Launch & Target)
  {
   GPS = entity():massCenter()
   Dist = Target:massCenter():distance(GPS)
   if(Dist < 350) 
      {
       if(((R1>0)+(R2>0)+(R3>0)+(R4>0)) > 2) 
         {
          Nailer = 1
          timer("Remove", 10000)
          if ($Dist > 3) {Thr = 0} else {Thr = 8}
         }else {Nailer = 0}
       
       if(clk("Remove")) {selfDestruct()}
      } 
    
   if(Nailer)
     {
      N+=1
      if ((N == 1) | (N == 100) | (N == 200)) {Nail = 1} else {Nail = 0}
      if ($Dist > 3) {Nailer = 0, N = 0}
      if (N == 250) {selfDestruct()}
     }
   
   if(LS < 25) {applyForce(-(GPS - (GPS:setZ(GPS:z()+1000)))), LS+=1}
   if(LS > 24)
     {
      if (LS < 30) {applyForce(vec(0, 0, -entity():vel():z()*10))}
      EP = entity():massCenter()
      EU = -entity():forward()
      Difference = (EP - Target:pos()):normalized() - EU
      applyOffsetForce((5*(Difference*3125)+($Difference*50000)),(EP + EU))
      applyOffsetForce(-(5*(Difference*3125)+($Difference*50000)),(EP - EU))
      LS+=1
     }
   
   if(LS < 50) {entity():setTrails(6, 32, 1.5, "trails/smoke.vmt", vec(0,255,0), 255)}
   if((LS > 51) & (!Nailer)) 
     {
      if (Thr < 8) {Thr += 0.25}
      soundPitch("Alert", 255)
      Tvel = Target:vel():length() * LM
      Gvel = entity():vel():length() * IM
      LV = (Target:vel() * Tvel) * Dist
      GV = entity():vel() * Gvel
      applyForce(-(GPS - ((Target:massCenter() + LV) - GV))*Thr)
     }
  }
