//
//  myFunction.c
//  fieldTheory1
//
//  Created by alexanderbollbach on 9/13/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#include "myFunction.h"
float interpolate(float originalMin, float originalMax,float newBegin,
                  float newEnd,float inputValue, float curve)
{
     
     float  OriginalRange = 0;
     float NewRange = 0;
     float zeroRefCurVal = 0;
     float normalizedCurVal = 0;
     float rangedValue = 0;
     float invFlag = 0;
     float result = 0;
     
     if (curve > 10) curve = 10;
     if (curve < -10) curve = -10;
     
     curve = (curve * -.1) ;
     curve = pow(10, curve);
     
     if (inputValue < originalMin)
     {
          inputValue = originalMin;
     }
     if (inputValue > originalMax)
     {
          inputValue = originalMax;
     }
     
     OriginalRange = originalMax - originalMin;
     
     if (newEnd > newBegin)
     {
          NewRange = newEnd - newBegin;
     }
     else
     {
          NewRange = newBegin - newEnd;
          invFlag = 1;
     }
     
     zeroRefCurVal = inputValue - originalMin;
     normalizedCurVal  =  zeroRefCurVal / OriginalRange;
     
     if (originalMin > originalMax )
     {
          result = 0;
          return result;
     }
     
     if (invFlag == 0)
     {
          rangedValue =  (pow(normalizedCurVal, curve) * NewRange) + newBegin;
     }else{
          rangedValue =  newBegin - (pow(normalizedCurVal, curve) * NewRange);
     }
     
     result = rangedValue;
     return result;
     
}