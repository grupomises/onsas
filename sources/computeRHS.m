% Copyright (C) 2019, Jorge M. Perez Zerpa, J. Bruno Bazzano, Jean-Marc Battini, Joaquin Viera, Mauricio Vanzulli  
%
% This file is part of ONSAS.
%
% ONSAS is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% ONSAS is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with ONSAS.  If not, see <https://www.gnu.org/licenses/>.

% ======================================================================

function [systemDeltauRHS, FextG] = computeRHS( Conec, secGeomProps, coordsElemsMat, hyperElasParamsMat, KS, Uk, dispIter, constantFext, variableFext, userLoadsFilename, currLoadFactor, nextLoadFactor, numericalMethodParams, neumdofs, FintGk, massMat, dampingMat, Ut, Udott, Udotdott, FintGt ) 

  [ solutionMethod, stopTolDeltau,   stopTolForces, ...
  stopTolIts,     targetLoadFactr, nLoadSteps,    ...
  incremArcLen, deltaT, deltaNW, AlphaNW, alphaHHT, finalTime ] ...
      = extractMethodParams( numericalMethodParams ) ;

  if solutionMethod == 1

    FextG  = computeFext( constantFext, variableFext, nextLoadFactor, userLoadsFilename ) ;
    systemDeltauRHS = - ( FintGk(neumdofs) - FextG(neumdofs) ) ;

  elseif solutionMethod == 2
    
    if norm(constantFext)>0 || ~(strcmp( userLoadsFilename , '')),
      error('load case not implemented yet for Arc-Length method');
    end
    
    FextG  = computeFext( constantFext, variableFext, nextLoadFactor, userLoadsFilename ) ;
    
    % incremental displacement
    systemDeltauRHS = [ -(FintGk(neumdofs)-FextG(neumdofs))  variableFext(neumdofs) ] ;

  elseif solutionMethod == 3

    [a0NM, a1NM, a2NM, a3NM, a4NM, a5NM, a6NM, a7NM ] = coefsNM( AlphaNW, deltaNW, deltaT ) ;

    FextG = computeFext( constantFext, variableFext, nextLoadFactor, userLoadsFilename ) ;
    
    Fhat      = FextG(neumdofs) ...
                - massMat( neumdofs, neumdofs ) * ...
                  (   a0NM * ( Uk(neumdofs)  - Ut(neumdofs) ) ...
                    - a2NM * Udott(neumdofs) - a3NM * Udotdott(neumdofs) ) ...
                + dampingMat( neumdofs, neumdofs) * ...
                  (   a1NM * ( Ut(neumdofs) - Uk(neumdofs) ) ...
                    + a4NM * Udott(neumdofs) + a5NM * Udotdott(neumdofs))    ...
                - FintGk(neumdofs)                                             ;
                
    systemDeltauRHS = Fhat ;

  elseif solutionMethod == 4
  
    deltaNW = (1-2*alphaHHT)/2 ;
    AlphaNW = (1-alphaHHT^2)/4 ;
        
    [a0NM, a1NM, a2NM, a3NM, a4NM, a5NM, a6NM, a7NM ] = coefsNM( AlphaNW, deltaNW, deltaT ) ;

    if ~(strcmp( userLoadsFilename , ''))
      FextUsert = feval( userLoadsFilename, currLoadFactor ) ;
    else
      FextUsert = zeros( size(FextUser)) ;
    end

    FextG  = computeFext( constantFext, variableFext, nextLoadFactor, userLoadsFilename ) ;

    FextGt = computeFext( constantFext, variableFext, currLoadFactor, userLoadsFilename ) ;
      
termalpha = alphaHHT * ( ...
                FextGt( neumdofs ) ...
                %~ - dampingMat( neumdofs, neumdofs ) * Udott(neumdofs) ...
                - FintGt(neumdofs) ...
                ) ; 
              %~ ...
termmass =        - massMat( neumdofs, neumdofs ) * ...
              (   a0NM * ( Uk(neumdofs)  - Ut(neumdofs) ) ...
                - a2NM * Udott(neumdofs) - a3NM * Udotdott(neumdofs) );
                                
                  termalphap1 = ( 1 + alphaHHT ) * ( ...
                FextG( neumdofs ) ...
                + dampingMat( neumdofs, neumdofs) * ...
                (   a1NM * ( Ut(neumdofs) - Uk(neumdofs) ) ...
                + a4NM * Udott(neumdofs) + a5NM * Udotdott(neumdofs) )    ...
                - FintGk(neumdofs) ...
                ) ;              
            
                
    Fhat   =  ( 1 + alphaHHT ) * ( ...
                FextG( neumdofs ) ...
                + dampingMat( neumdofs, neumdofs) * ...
                (   a1NM * ( Ut(neumdofs) - Uk(neumdofs) ) ...
                + a4NM * Udott(neumdofs) + a5NM * Udotdott(neumdofs) )    ...
                - FintGk(neumdofs) ...
                )  ...
                ...
              - alphaHHT * ( ...
                FextGt( neumdofs ) ...
                - dampingMat( neumdofs, neumdofs ) * Udott(neumdofs) ...
                - FintGt(neumdofs) ...
                ) ...
              ...
              - massMat( neumdofs, neumdofs ) * ...
              (   a0NM * ( Uk(neumdofs)  - Ut(neumdofs) ) ...
                - a2NM * Udott(neumdofs) - a3NM * Udotdott(neumdofs) ) ;

    %~ [  termalphap1 termalpha termmass  FintGk(neumdofs) FintGt(neumdofs)   Fhat ], %pause(0.5)
                
    systemDeltauRHS = Fhat ;
    
  end
    
