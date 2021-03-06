
function [Area, J, Iyy, Izz, Jrho ] = crossSectionProps ( elemCrossSecParams, rho )

% --- cross section ---
if elemCrossSecParams(1) == 1 %general section
    Area = elemCrossSecParams( 2 ) ;
    J    = elemCrossSecParams( 3 ) ;
    Iyy  = elemCrossSecParams( 4 ) ;
    Izz  = elemCrossSecParams( 5 ) ;
    %
    if length( elemCrossSecParams ) > 5
        Jrho =  diag( elemCrossSecParams( 6:8 ) ) ;
    else
        Jrho = rho * diag( [ J Iyy Izz ] ) ;
    end

elseif elemCrossSecParams(1) == 2
    Area = elemCrossSecParams(2)*elemCrossSecParams(3)      ;
    Iyy  = elemCrossSecParams(2)*elemCrossSecParams(3)^3/12 ;
    Izz  = elemCrossSecParams(3)*elemCrossSecParams(2)^3/12 ;

    if elemCrossSecParams(2)==elemCrossSecParams(3)
        J    = 1/3*0.40147*elemCrossSecParams(2)^4 ;
    else
        h = max(elemCrossSecParams(2:3)) ;
        b = min(elemCrossSecParams(2:3)) ;
        r = h/b ;
        beta = -1e-5*r^6 + 4e-4*r^5 - 5.8e-3*r^4 + 4.1e-2*r^3 - 0.1625*r^2 + 0.3628*r - 0.0949 ;
        J = beta * b^3*h ;
    end
    Jrho = rho * diag( [ J Iyy Izz ] ) ;

elseif elemCrossSecParams(1) == 3
    diameter = elemCrossSecParams(2) ;
    Area = pi*diameter^2/4           ;
    Iyy  = pi*diameter^4/64          ;
    Izz  = Iyy                       ;
    J    = Iyy + Izz ;
    Jrho = rho * diag( [ J Iyy Izz ] ) ;
else
  error(' section type not implemented yet, please create an issue')
end
