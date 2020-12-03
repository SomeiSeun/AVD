function parameter = doubleCruise(parameter)
%doubling up cruise parameter into [takeoff, cruise, cruise, landing]
parameter(4) = parameter(3);
parameter(3) = parameter(2);


end