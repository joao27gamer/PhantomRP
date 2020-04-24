#define RECORDING "onibus1_LS-LS" //Este é o nome do seu arquivo de gravação, sem a extenção(.rec).
#define RECORDING_TYPE 1 //1 para gravações em veículo e 2 para gravações apé.

#include "a_npc.inc"
 main ( )  { } 
public OnNPCEnterVehicle(vehicleid, seatid) StartRecordingPlayback(RECORDING_TYPE, RECORDING); 
public OnNPCExitVehicle() StopRecordingPlayback(); 
public OnRecordingPlaybackEnd() StartRecordingPlayback(RECORDING_TYPE, RECORDING);