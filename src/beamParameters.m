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

% --------------------------------------------------------------------------------------------------

function [ElemLengths, Local2GlobalMats] = beamParameters(elemCoords)
	

  %ElemLengths = sqrt ( sum( ( Nodes(2,:) - Nodes(1,:) ).^2, 2 ) ) ;
	
	ElemLengths = sqrt ( sum( ( elemCoords(7:2:end) - elemCoords(1:2:6) ).^2 ) )
	
  % ----- local coordinate system setting -------------
%  dxLdls       = ( Nodes(2,1) - Nodes(1,1) ) ...
%                 ./ ElemLengths ; 

%  dyLdls       = ( Nodes(2,2) - Nodes(1,2) ) ...
 %                ./ ElemLengths ; 
  %dzLdls       = ( Nodes(2,3) - Nodes(1,3) ) ...
   %              ./ ElemLengths ;
                 
  dxLdls       = ( elemCoords(7) - elemCoords(1) ) ...
                 ./ ElemLengths ; 
  dyLdls       = ( elemCoords(9) - elemCoords(3) ) ...
                 ./ ElemLengths ; 
  dzLdls       = ( elemCoords(11) - elemCoords(5) ) ...
                 ./ ElemLengths ;
 
  exL = [  dxLdls  dyLdls dzLdls ]' ;
  if ( norm( [ dyLdls dxLdls ] ) > (1e-5*ElemLengths) )
    eyL = [ -dyLdls  dxLdls         0 ]' / sqrt( dyLdls^2 + dxLdls^2 ) ;
  else
  % The convention adopted for the local y in this case is: yL = yG
    eyL = [ 0          1         0        ]' ;
  end
  ezL = cross( exL, eyL ) ;
  Local2GlobalMats = [ exL  eyL  ezL ] ;

end
