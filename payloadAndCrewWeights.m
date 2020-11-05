function [W_Payload,W_Crew] = payloadAndCrewWeights(N_Pilots, N_Crew, N_Pax, Mass_Person, Mass_Luggage)
% Function to calculate weights of payload and crew
% The number of pilots, crew and pax are defined in the brief, but aren't
% hard coded just to keep list of "givens" complete and separate.
% Example:
% [W_Payload, W_Crew] = payloadAndCrewWeights(N_Pilots, N_Crew, N_Pax,
% Mass_Person, Mass_Luggage)

W_Payload = N_Pax * (Mass_Person + Mass_Luggage) * 9.81;
W_Crew = (N_Pilots + N_Crew) * (Mass_Person + Mass_Luggage) * 9.81;

end

