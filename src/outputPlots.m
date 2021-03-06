% Copyright (C) 2020, Jorge M. Perez Zerpa, J. Bruno Bazzano, Joaquin Viera, 
%   Mauricio Vanzulli, Marcelo Forets, Jean-Marc Battini, Sebastian Toro  
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


%Script for generation of the plots of the deformed structure.

function outputPlots( matUts, coordsElemsMat, plotParamsVector, ...
  Conec, Nodes, constantFext, variableFext, ...
  controlDisps, linearDeformedScaleFactor, ...
  printflag, outputdir, problemName, loadFactors, sectPar, ...
  timeIncr, cellStress, plotsViewAxis, booleanScreenOutput )

	if size(matUts,2) == 1 && size(matNts,2) == 1 
		matUts = [zeros(size(matUts,1),1) matUts] ;
		matNts = [zeros(size(matNts,1),1) matNts] ;
	end
  
  strucsize = strucSize(Nodes) ; 
  
  nTimesTotal = size( matUts, 2 ) ;

  timeVals = (0:(nTimesTotal-1))*timeIncr;
  
	
  
  if plotParamsVector(1) > 0
    if length(loadFactors) > 1
        %~ outputLoadVSDisplacementsPlot
    end
  end
      
  if plotParamsVector(1) == 2
    outputOctavePlots
		tVtkWriter = 0 ; tVtkConecNodes = 0 ;
  elseif plotParamsVector(1) == 3
    outputVtk
		tDefShape = 0 ; tLoadFac = 0 ; tNormalForce = 0 ; tLoadDisps = 0 ;
  end  

end
