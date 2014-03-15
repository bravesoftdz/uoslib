unit uos_flat;

   // This is the "Flat Layer" of uos => for universal procedures.

{*******************************************************************************
*                  United Openlibraries of Sound ( uos )                       *
*                  --------------------------------------                      *
*                                                                              *
*          United procedures to access Open Sound (IN/OUT) libraries           *
*                                                                              *
*              With Big contributions of (in alphabetic order)                 *
*      BigChimp, Blaazen, Sandro Cumerlato, Dibo, KpjComp, Leledumbo.          *
*                                                                              *
*                 Fred van Stappen /  fiens@hotmail.com                        *
*                                                                              *
*                                                                              *
********************************************************************************
}
{
    Copyright (C) 2014  Fred van Stappen

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

}

interface

uses
  
  Classes, ctypes, Math, SysUtils, uos;

  type
  TProc = procedure of object ;
  type
  TDArFloat = array of cfloat;
  type
  TuosF_Data = Tuos_Data;
  TuosF_FFT = Tuos_FFT ;
  type
  {$if not defined(fs32bit)}
     Tsf_count_t    = cint64;          { used for file sizes          }
  {$else}
     Tsf_count_t    = cint;
  {$endif}


//////////// General public procedure/function (accessible for library uos too)

procedure uos_GetInfoDevice();

function uos_GetInfoDeviceStr() : Pchar ;

function uos_loadlib(PortAudioFileName, SndFileFileName, Mpg123FileName, SoundTouchFileName: PChar) : LongInt;
        ////// load libraries... if libraryfilename = '' =>  do not load it...  You may load what and when you want...

procedure uos_unloadlib();
        ////// Unload all libraries... Do not forget to call it before close application...

procedure uos_unloadlibCust(PortAudio, SndFile, Mpg123, SoundTouch: boolean);
           ////// Custom Unload libraries... if true, then delete the library. You may unload what and when you want...

{$IF (FPC_FULLVERSION >= 20701) or  DEFINED(LCL) or DEFINED(ConsoleApp) or DEFINED(Windows) or DEFINED(Library)}
procedure uos_CreatePlayer(PlayerIndex: LongInt);
{$else}
procedure uos_CreatePlayer(PlayerIndex: LongInt; AParent: TObject);
{$endif}
        //// PlayerIndex : from 0 to what your computer can do ! (depends of ram, cpu, soundcard, ...)
        //// If PlayerIndex already exists, it will be overwriten...


function uos_AddIntoDevOut(PlayerIndex: LongInt; Device: LongInt; Latency: CDouble;
            SampleRate: LongInt; Channels: LongInt; SampleFormat: LongInt ; FramesCount: LongInt ): LongInt;
          ////// Add a Output into Device Output with custom parameters
function uos_AddIntoDevOut(PlayerIndex: LongInt): LongInt;
          ////// Add a Output into Device Output with default parameters
          //////////// PlayerIndex : Index of a existing Player
          //////////// Device ( -1 is default device )
          //////////// Latency  ( -1 is latency suggested ) )
          //////////// SampleRate : delault : -1 (44100)
          //////////// Channels : delault : -1 (2:stereo) (0: no channels, 1:mono, 2:stereo, ...)
          //////////// SampleFormat : default : -1 (1:Int16) (0: Float32, 1:Int32, 2:Int16)
          //////////// FramesCount : default : -1 (= 65536)
          //  result : Output Index in array  , -1 = error
          /// example : OutputIndex1 := uos_AddIntoDevOut(0,-1,-1,-1,-1,0);

function uos_AddFromFile(PlayerIndex: LongInt; Filename: PChar; OutputIndex: LongInt;
              SampleFormat: LongInt ; FramesCount: LongInt): LongInt;
            /////// Add a input from audio file with custom parameters

function uos_AddFromFile(PlayerIndex: LongInt; Filename: PChar): LongInt;
            /////// Add a input from audio file with default parameters
            //////////// PlayerIndex : Index of a existing Player
            ////////// FileName : filename of audio file
            ////////// OutputIndex : Output index of used output// -1: all output, -2: no output, other LongInt refer to a existing OutputIndex  (if multi-output then OutName = name of each output separeted by ';')
            //////////// SampleFormat : default : -1 (1:Int16) (0: Float32, 1:Int32, 2:Int16)
            //////////// FramesCount : default : -1 (65536)
            //  result : Input Index in array  -1 = error
            //////////// example : InputIndex1 := uos_AddFromFile(0, edit5.Text,-1,0);

function uos_AddIntoFile(PlayerIndex: LongInt; Filename: PChar; SampleRate: LongInt;
                 Channels: LongInt; SampleFormat: LongInt ; FramesCount: LongInt): LongInt;
               /////// Add a Output into audio wav file with custom parameters
               //////////// PlayerIndex : Index of a existing Player
               ////////// FileName : filename of saved audio wav file
               //////////// SampleRate : delault : -1 (44100)
               //////////// Channels : delault : -1 (2:stereo) (0: no channels, 1:mono, 2:stereo, ...)
               //////////// SampleFormat : default : -1 (1:Int16) (0: Float32, 1:Int32, 2:Int16)
               //////////// FramesCount : default : -1 (= 65536)
               //  result :Output Index in array  -1 = error
               //////////// example : OutputIndex1 := uos_AddIntoFile(0,edit5.Text,-1,-1, 0, -1);
function uos_AddIntoFile(PlayerIndex: LongInt; Filename: PChar): LongInt;
               /////// Add a Output into audio wav file with Default parameters
              //////////// PlayerIndex : Index of a existing Player
              ////////// FileName : filename of saved audio wav file

function uos_AddFromDevIn(PlayerIndex: LongInt; Device: LongInt; Latency: CDouble;
             SampleRate: LongInt; Channels: LongInt; OutputIndex: LongInt;
             SampleFormat: LongInt; FramesCount : LongInt): LongInt;
              ////// Add a Input from Device Input with custom parameters
              //////////// PlayerIndex : Index of a existing Player
               //////////// Device ( -1 is default Input device )
               //////////// Latency  ( -1 is latency suggested ) )
               //////////// SampleRate : delault : -1 (44100)
               //////////// Channels : delault : -1 (2:stereo) (0: no channels, 1:mono, 2:stereo, ...)
               //////////// OutputIndex : Output index of used output// -1: all output, -2: no output, other LongInt refer to a existing OutputIndex  (if multi-output then OutName = name of each output separeted by ';')
               //////////// SampleFormat : default : -1 (1:Int16) (0: Float32, 1:Int32, 2:Int16)
               //////////// FramesCount : default : -1 (65536)
               //  result :  Output Index in array
               /// example : OutputIndex1 := uos_AddFromDevIn(-1,-1,-1,-1,-1,-1);
function uos_AddFromDevIn(PlayerIndex: LongInt): LongInt;
              ////// Add a Input from Device Input with custom parameters
              ///////// PlayerIndex : Index of a existing Player

procedure uos_BeginProc(PlayerIndex: LongInt; Proc: TProc);
            ///// Assign the procedure of object to execute  at begining, before loop
            //////////// PlayerIndex : Index of a existing Player
            //////////// InIndex : Index of a existing Input

procedure uos_EndProc(PlayerIndex: LongInt; Proc: TProc);
            ///// Assign the procedure of object to execute  at end, after loop
            //////////// PlayerIndex : Index of a existing Player
            //////////// InIndex : Index of a existing Input


procedure uos_LoopProcIn(PlayerIndex: LongInt; InIndex: LongInt; Proc: TProc);
            ///// Assign the procedure of object to execute inside the loop
            //////////// PlayerIndex : Index of a existing Player
            //////////// InIndex : Index of a existing Input

procedure uos_LoopProcOut(PlayerIndex: LongInt; OutIndex: LongInt; Proc: TProc);
              ///// Assign the procedure of object to execute inside the loop
            //////////// PlayerIndex : Index of a existing Player
            //////////// OutIndex : Index of a existing Output

procedure uos_AddDSPVolumeIn(PlayerIndex: LongInt; InputIndex: LongInt; VolLeft: double;
                 VolRight: double) ;
               ///// DSP Volume changer
               //////////// PlayerIndex : Index of a existing Player
               ////////// InputIndex : InputIndex of a existing Input
               ////////// VolLeft : Left volume
               ////////// VolRight : Right volume
               ////////// example  uos_AddDSPVolumeIn(0,InputIndex1,1,1);

procedure uos_AddDSPVolumeOut(PlayerIndex: LongInt; OutputIndex: LongInt; VolLeft: double;
                 VolRight: double) ;
               ///// DSP Volume changer
               //////////// PlayerIndex : Index of a existing Player
               ////////// OutputIndex : OutputIndex of a existing Output
               ////////// VolLeft : Left volume
               ////////// VolRight : Right volume
               //  result : -1 nothing created, otherwise index of DSPIn in array
               ////////// example  DSPIndex1 := uos_AddDSPVolumeOut(o,oututIndex1,1,1);

procedure uos_SetDSPVolumeIn(PlayerIndex: LongInt; InputIndex: LongInt;
                 VolLeft: double; VolRight: double; Enable: boolean);
               ////////// InputIndex : InputIndex of a existing Input
               //////////// PlayerIndex : Index of a existing Player
               ////////// VolLeft : Left volume
               ////////// VolRight : Right volume
               ////////// Enable : Enabled
               ////////// example  uos_SetDSPVolumeIn(0,InputIndex1,DSPIndex1,1,0.8,True);

procedure uos_SetDSPVolumeOut(PlayerIndex: LongInt; OutputIndex: LongInt;
                 VolLeft: double; VolRight: double; Enable: boolean);
               ////////// OutputIndex : OutputIndex of a existing Output
               //////////// PlayerIndex : Index of a existing Player
               ////////// VolLeft : Left volume
               ////////// VolRight : Right volume
               ////////// Enable : Enabled
               ////////// example  uos_SetDSPVolumeOut(0,outputIndex1,DSPIndex1,1,0.8,True);

function uos_AddDSPin(PlayerIndex: LongInt; InputIndex: LongInt; BeforeProc: TFunc;
                    AfterProc: TFunc; LoopProc: TProc): LongInt;
                  ///// add a DSP procedure for input
                  //////////// PlayerIndex : Index of a existing Player
                  ////////// InputIndex : Input Index of a existing input
                  ////////// BeforeProc : procedure to do before the buffer is filled
                  ////////// AfterProc : procedure to do after the buffer is filled
                  ////////// LoopProc : external procedure to do after the buffer is filled
                  //  result : -1 nothing created, otherwise index of DSPin in array  (DSPinIndex)
                  ////////// example : DSPinIndex1 := uos_AddDSPin(0,InputIndex1,@beforereverse,@afterreverse,nil);

procedure uos_SetDSPin(PlayerIndex: LongInt; InputIndex: LongInt; DSPinIndex: LongInt; Enable: boolean);
                  //////////// PlayerIndex : Index of a existing Player
                  ////////// InputIndex : Input Index of a existing input
                  ////////// DSPIndexIn : DSP Index of a existing DSP In
                  ////////// Enable :  DSP enabled
                  ////////// example : uos_SetDSPin(0,InputIndex1,DSPinIndex1,True);

function uos_AddDSPout(PlayerIndex: LongInt; OutputIndex: LongInt; BeforeProc: TFunc;
                    AfterProc: TFunc; LoopProc: TProc): LongInt;    //// usefull if multi output
                  //////////// PlayerIndex : Index of a existing Player
                  ////////// OutputIndex : OutputIndex of a existing Output
                  ////////// BeforeProc : procedure to do before the buffer is filled
                  ////////// AfterProc : procedure to do after the buffer is filled just before to give to output
                  ////////// LoopProc : external procedure to do after the buffer is filled
                  //  result : index of DSPout in array
                  ////////// example :DSPoutIndex1 := uos_AddDSPout(0,OutputIndex1,@volumeproc,nil,nil);

procedure uos_SetDSPout(PlayerIndex: LongInt; OutputIndex: LongInt; DSPoutIndex: LongInt; Enable: boolean);
                  //////////// PlayerIndex : Index of a existing Player
                  ////////// OutputIndex : OutputIndex of a existing Output
                  ////////// DSPoutIndex : DSPoutIndex of existing DSPout
                  ////////// Enable :  DSP enabled
                  ////////// example : uos_SetDSPout(0,OutputIndex1,DSPoutIndex1,True);

function uos_AddFilterIn(PlayerIndex: LongInt; InputIndex: LongInt; LowFrequency: LongInt;
                    HighFrequency: LongInt; Gain: cfloat; TypeFilter: LongInt;
                    AlsoBuf: boolean; LoopProc: TProc): LongInt ;
                  //////////// PlayerIndex : Index of a existing Player
                  ////////// InputIndex : InputIndex of a existing Input
                  ////////// LowFrequency : Lowest frequency of filter
                  ////////// HighFrequency : Highest frequency of filter
                  ////////// Gain : gain to apply to filter
                  ////////// TypeFilter: Type of filter : default = -1 = fBandSelect (fBandAll = 0, fBandSelect = 1, fBandReject = 2
                  /////////////////////////// fBandPass = 3, fHighPass = 4, fLowPass = 5)
                  ////////// AlsoBuf : The filter alter buffer aswell ( otherwise, only result is filled in fft.data )
                  ////////// LoopProc : External procedure to execute after DSP done
                  //  result : index of DSPIn in array   -1 = error
                  ////////// example :FilterInIndex1 := uos_AddFilterIn(0,InputIndex1,6000,16000,1,2,true,nil);

procedure uos_SetFilterIn(PlayerIndex: LongInt; InputIndex: LongInt; FilterIndex: LongInt;
                    LowFrequency: LongInt; HighFrequency: LongInt; Gain: cfloat;
                    TypeFilter: LongInt; AlsoBuf: boolean; Enable: boolean; LoopProc: TProc);
                  //////////// PlayerIndex : Index of a existing Player
                  ////////// InputIndex : InputIndex of a existing Input
                  ////////// DSPInIndex : DSPInIndex of existing DSPIn
                  ////////// LowFrequency : Lowest frequency of filter ( -1 : current LowFrequency )
                  ////////// HighFrequency : Highest frequency of filter ( -1 : current HighFrequency )
                  ////////// Gain : gain to apply to filter
                  ////////// TypeFilter: Type of filter : ( -1 = current filter ) (fBandAll = 0, fBandSelect = 1, fBandReject = 2
                  /////////////////////////// fBandPass = 3, fHighPass = 4, fLowPass = 5)
                  ////////// AlsoBuf : The filter alter buffer aswell ( otherwise, only result is filled in fft.data )
                  ////////// LoopProc : External procedure to execute after DSP done
                  ////////// Enable :  Filter enabled
                  ////////// example : uos_SetFilterIn(0,InputIndex1,FilterInIndex1,-1,-1,-1,False,True,nil);

function uos_AddFilterOut(PlayerIndex: LongInt; OutputIndex: LongInt; LowFrequency: LongInt;
                    HighFrequency: LongInt; Gain: cfloat; TypeFilter: LongInt;
                    AlsoBuf: boolean; LoopProc: TProc): LongInt;
                  //////////// PlayerIndex : Index of a existing Player
                  ////////// OutputIndex : OutputIndex of a existing Output
                  ////////// LowFrequency : Lowest frequency of filter
                  ////////// HighFrequency : Highest frequency of filter
                  ////////// Gain : gain to apply to filter
                  ////////// TypeFilter: Type of filter : default = -1 = fBandSelect (fBandAll = 0, fBandSelect = 1, fBandReject = 2
                  /////////////////////////// fBandPass = 3, fHighPass = 4, fLowPass = 5)
                  ////////// AlsoBuf : The filter alter buffer aswell ( otherwise, only result is filled in fft.data )
                  ////////// LoopProc : External procedure to execute after DSP done
                  //  result : index of DSPOut in array  -1 = error
                  ////////// example :FilterOutIndex1 := uos_AddFilterOut(0,OutputIndex1,6000,16000,1,true,nil);

procedure uos_SetFilterOut(PlayerIndex: LongInt; OutputIndex: LongInt; FilterIndex: LongInt;
                    LowFrequency: LongInt; HighFrequency: LongInt; Gain: cfloat;
                    TypeFilter: LongInt; AlsoBuf: boolean; Enable: boolean; LoopProc: TProc);
                  //////////// PlayerIndex : Index of a existing Player
                  ////////// OutputIndex : OutputIndex of a existing Output
                  ////////// FilterIndex : DSPOutIndex of existing DSPOut
                  ////////// LowFrequency : Lowest frequency of filter ( -1 : current LowFrequency )
                  ////////// HighFrequency : Highest frequency of filter ( -1 : current HighFrequency )
                  ////////// Gain : gain to apply to filter
                  ////////// TypeFilter: Type of filter : ( -1 = current filter ) (fBandAll = 0, fBandSelect = 1, fBandReject = 2
                  /// fBandPass = 3, fHighPass = 4, fLowPass = 5)
                  ////////// AlsoBuf : The filter alter buffer aswell ( otherwise, only result is filled in fft.data )
                  ////////// Enable :  Filter enabled
                  ////////// LoopProc : External procedure to execute after DSP done
                  ////////// example : uos_SetFilterOut(0,OutputIndex1,FilterOutIndex1,1000,1500,-1,True,True,nil);

function uos_AddPlugin(PlayerIndex: LongInt; PlugName: PChar; SampleRate: LongInt;
                       Channels: LongInt): LongInt ;
                     /////// Add a plugin , result is PluginIndex
                     //////////// PlayerIndex : Index of a existing Player
                     //////////// SampleRate : delault : -1 (44100)
                     //////////// Channels : delault : -1 (2:stereo) (1:mono, 2:stereo, ...)
                     ////// Till now, only 'soundtouch' PlugName is registred.

procedure uos_SetPluginSoundTouch(PlayerIndex: LongInt; PluginIndex: LongInt; Tempo: cfloat;
                       Pitch: cfloat; Enable: boolean);
                     ////////// PluginIndex : PluginIndex Index of a existing Plugin.
                     //////////// PlayerIndex : Index of a existing Player

function uos_GetStatus(PlayerIndex: LongInt) : LongInt ;
             /////// Get the status of the player : -1 => error,  0 => has stopped, 1 => is running, 2 => is paused.

procedure uos_Seek(PlayerIndex: LongInt; InputIndex: LongInt; pos: Tsf_count_t);
                     //// change position in sample

procedure uos_SeekSeconds(PlayerIndex: LongInt; InputIndex: LongInt; pos: cfloat);
                     //// change position in seconds

procedure uos_SeekTime(PlayerIndex: LongInt; InputIndex: LongInt; pos: TTime);
                     //// change position in time format

function uos_InputLength(PlayerIndex: LongInt; InputIndex: LongInt): longint;
                     ////////// InputIndex : InputIndex of existing input
                     ///////  result : Length of Input in samples

function uos_InputLengthSeconds(PlayerIndex: LongInt; InputIndex: LongInt): cfloat;
                     ////////// InputIndex : InputIndex of existing input
                     ///////  result : Length of Input in seconds

function uos_InputLengthTime(PlayerIndex: LongInt; InputIndex: LongInt): TTime;
                     ////////// InputIndex : InputIndex of existing input
                     ///////  result : Length of Input in time format

function uos_InputPosition(PlayerIndex: LongInt; InputIndex: LongInt): longint;
                     ////////// InputIndex : InputIndex of existing input
                     ////// result : current postion in sample

procedure uos_InputSetLevelEnable(PlayerIndex: LongInt; InputIndex: LongInt ; enable : boolean);
                   ///////// enable/disable level(volume) calculation (default is false/disable)

function uos_InputGetLevelLeft(PlayerIndex: LongInt; InputIndex: LongInt): double;
                     ////////// InputIndex : InputIndex of existing input
                     ////// result : left level(volume) from 0 to 1

function uos_InputGetLevelRight(PlayerIndex: LongInt; InputIndex: LongInt): double;
                     ////////// InputIndex : InputIndex of existing input
                     ////// result : right level(volume) from 0 to 1

function uos_InputPositionSeconds(PlayerIndex: LongInt; InputIndex: LongInt): cfloat;
                     ////////// InputIndex : InputIndex of existing input
                     ///////  result : current postion of Input in seconds

function uos_InputPositionTime(PlayerIndex: LongInt; InputIndex: LongInt): TTime;
                     ////////// InputIndex : InputIndex of existing input
                     ///////  result : current postion of Input in time format

function uos_InputGetSampleRate(PlayerIndex: LongInt; InputIndex: LongInt): LongInt;
                   ////////// InputIndex : InputIndex of existing input
                  ////// result : default sample rate

function uos_InputGetChannels(PlayerIndex: LongInt; InputIndex: LongInt): LongInt;
                  ///////// InputIndex : InputIndex of existing input
                  ////// result : default channels

procedure uos_Play(PlayerIndex: LongInt) ;        ///// Start playing

procedure uos_RePlay(PlayerIndex: LongInt);                ///// Resume playing after pause

procedure uos_Stop(PlayerIndex: LongInt);                  ///// Stop playing and free thread

procedure uos_Pause(PlayerIndex: LongInt);                 ///// Pause playing

function uos_GetVersion() : LongInt ;             //// version of uos

var
  uosDeviceInfos: array of Tuos_DeviceInfos;
  uosLoadResult: Tuos_LoadResult;
  uosDeviceCount: LongInt;
  uosDefaultDeviceIn: LongInt;
  uosDefaultDeviceOut: LongInt;

implementation

procedure uos_AddDSPVolumeIn(PlayerIndex: LongInt; InputIndex: LongInt; VolLeft: double;
                 VolRight: double);
begin
    if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
    if  uosPlayersStat[PlayerIndex] = 1 then
  uosPlayers[PlayerIndex].StreamIn[InputIndex].Data.DSPVolumeInIndex := uosPlayers[PlayerIndex].AddDSPVolumeIn(InputIndex, VolLeft, VolRight);
end;
               ///// DSP Volume changer
               //////////// PlayerIndex : Index of a existing Player
               ////////// InputIndex : InputIndex of a existing Input
               ////////// VolLeft : Left volume
               ////////// VolRight : Right volume
               //  result : -1 nothing created, otherwise index of DSPIn in array
               ////////// example  DSPIndex1 := AddDSPVolumeIn(0,InputIndex1,1,1);

procedure uos_AddDSPVolumeOut(PlayerIndex: LongInt; OutputIndex: LongInt; VolLeft: double;
                 VolRight: double);
begin
    if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
    if  uosPlayersStat[PlayerIndex] = 1 then
uosPlayers[PlayerIndex].StreamOut[OutputIndex].Data.DSPVolumeOutIndex := uosPlayers[PlayerIndex].AddDSPVolumeOut(OutputIndex, VolLeft, VolRight);
end;
               ///// DSP Volume changer
               //////////// PlayerIndex : Index of a existing Player
               ////////// OutputIndex : OutputIndex of a existing Output
               ////////// VolLeft : Left volume
               ////////// VolRight : Right volume
               //  result : -1 nothing created, otherwise index of DSPIn in array
               ////////// example  DSPIndex1 := AddDSPVolumeOut(0,InputIndex1,1,1);

procedure uos_SetDSPVolumeIn(PlayerIndex: LongInt; InputIndex: LongInt;
                 VolLeft: double; VolRight: double; Enable: boolean);
begin
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
    if  uosPlayersStat[PlayerIndex] = 1 then
uosPlayers[PlayerIndex].SetDSPVolumeIn(InputIndex,  uosPlayers[PlayerIndex].StreamIn[InputIndex].Data.DSPVolumeInIndex, VolLeft, VolRight, Enable);
end;
               ////////// InputIndex : InputIndex of a existing Input
               //////////// PlayerIndex : Index of a existing Player
               ////////// VolLeft : Left volume
               ////////// VolRight : Right volume
               ////////// Enable : Enabled
               ////////// example  SetDSPVolumeIn(0,InputIndex1,1,0.8,True);

procedure uos_SetDSPVolumeOut(PlayerIndex: LongInt; OutputIndex: LongInt;
                 VolLeft: double; VolRight: double; Enable: boolean);
begin
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
    if  uosPlayersStat[PlayerIndex] = 1 then
uosPlayers[PlayerIndex].SetDSPVolumeOut(OutputIndex, uosPlayers[PlayerIndex].StreamOut[OutputIndex].Data.DSPVolumeOutIndex, VolLeft, VolRight, Enable);
end;
               ////////// OutputIndex : OutputIndex of a existing Output
               //////////// PlayerIndex : Index of a existing Player
               ////////// VolLeft : Left volume
               ////////// VolRight : Right volume
               ////////// Enable : Enabled
               ////////// example  SetDSPVolumeOut(0,InputIndex1,1,0.8,True);



function uos_AddDSPin(PlayerIndex: LongInt; InputIndex: LongInt; BeforeProc: TFunc;
                    AfterProc: TFunc; LoopProc: TProc): LongInt;
                  ///// add a DSP procedure for input
                  //////////// PlayerIndex : Index of a existing Player
                  ////////// InputIndex : Input Index of a existing input
                  ////////// BeforeProc : procedure to do before the buffer is filled
                  ////////// AfterProc : procedure to do after the buffer is filled
                  ////////// LoopProc : external procedure to do after the buffer is filled
                  //  result : index of DSPin in array  (DSPinIndex)
                 ////////// example : DSPinIndex1 := AddDSPIn(0,InputIndex1,@beforereverse,@afterreverse,nil);
begin
 result := -1 ;
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
    if  uosPlayersStat[PlayerIndex] = 1 then
result := uosPlayers[PlayerIndex].AddDSPin(InputIndex, BeforeProc, AfterProc, LoopProc) ;
end;

procedure uos_SetDSPin(PlayerIndex: LongInt; InputIndex: LongInt; DSPinIndex: LongInt; Enable: boolean);
                  //////////// PlayerIndex : Index of a existing Player
                  ////////// InputIndex : Input Index of a existing input
                  ////////// DSPIndexIn : DSP Index of a existing DSP In
                  ////////// Enable :  DSP enabled
                  ////////// example : SetDSPIn(0,InputIndex1,DSPinIndex1,True);
begin
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
    if  uosPlayersStat[PlayerIndex] = 1 then
uosPlayers[PlayerIndex].SetDSPin(InputIndex, DSPinIndex, Enable) ;
end;

function uos_AddDSPout(PlayerIndex: LongInt; OutputIndex: LongInt; BeforeProc: TFunc;
                    AfterProc: TFunc; LoopProc: TProc): LongInt;    //// usefull if multi output
                  //////////// PlayerIndex : Index of a existing Player
                  ////////// OutputIndex : OutputIndex of a existing Output
                  ////////// BeforeProc : procedure to do before the buffer is filled
                  ////////// AfterProc : procedure to do after the buffer is filled just before to give to output
                  ////////// LoopProc : external procedure to do after the buffer is filled
                  //  result :index of DSPout in array
                  ////////// example :DSPoutIndex1 := AddDSPout(0,OutputIndex1,@volumeproc,nil,nil);
begin
 result := -1 ;
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
    if  uosPlayersStat[PlayerIndex] = 1 then
result := uosPlayers[PlayerIndex].AddDSPout(OutputIndex, BeforeProc, AfterProc, LoopProc) ;
end;

procedure uos_SetDSPout(PlayerIndex: LongInt; OutputIndex: LongInt; DSPoutIndex: LongInt; Enable: boolean);
                  //////////// PlayerIndex : Index of a existing Player
                  ////////// OutputIndex : OutputIndex of a existing Output
                  ////////// DSPoutIndex : DSPoutIndex of existing DSPout
                  ////////// Enable :  DSP enabled
                  ////////// example : SetDSPIn(0,OutputIndex1,DSPoutIndex1,True);
begin
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
    if  uosPlayersStat[PlayerIndex] = 1 then
uosPlayers[PlayerIndex].SetDSPout(OutputIndex, DSPoutIndex, Enable) ;
end;

function uos_AddFilterIn(PlayerIndex: LongInt; InputIndex: LongInt; LowFrequency: LongInt;
                    HighFrequency: LongInt; Gain: cfloat; TypeFilter: LongInt;
                    AlsoBuf: boolean; LoopProc: TProc): LongInt;
                  //////////// PlayerIndex : Index of a existing Player
                  ////////// InputIndex : InputIndex of a existing Input
                  ////////// LowFrequency : Lowest frequency of filter
                  ////////// HighFrequency : Highest frequency of filter
                  ////////// Gain : gain to apply to filter
                  ////////// TypeFilter: Type of filter : default = -1 = fBandSelect (fBandAll = 0, fBandSelect = 1, fBandReject = 2
                  /////////////////////////// fBandPass = 3, fHighPass = 4, fLowPass = 5)
                  ////////// AlsoBuf : The filter alter buffer aswell ( otherwise, only result is filled in fft.data )
                  ////////// LoopProc : External procedure to execute after DSP done
                  //  result :  index of DSPIn in array    -1 = error
                  ////////// example :FilterInIndex1 := AddFilterIn(0,InputIndex1,6000,16000,1,2,true,nil);
begin
 result := -1 ;
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
    if  uosPlayersStat[PlayerIndex] = 1 then
result := uosPlayers[PlayerIndex].AddFilterIn(InputIndex, LowFrequency, HighFrequency, Gain, TypeFilter,
                    AlsoBuf, LoopProc) ;
end;

procedure uos_SetFilterIn(PlayerIndex: LongInt; InputIndex: LongInt; FilterIndex: LongInt;
                    LowFrequency: LongInt; HighFrequency: LongInt; Gain: cfloat;
                    TypeFilter: LongInt; AlsoBuf: boolean; Enable: boolean; LoopProc: TProc);
                  //////////// PlayerIndex : Index of a existing Player
                  ////////// InputIndex : InputIndex of a existing Input
                  ////////// DSPInIndex : DSPInIndex of existing DSPIn
                  ////////// LowFrequency : Lowest frequency of filter ( -1 : current LowFrequency )
                  ////////// HighFrequency : Highest frequency of filter ( -1 : current HighFrequency )
                  ////////// Gain : gain to apply to filter
                  ////////// TypeFilter: Type of filter : ( -1 = current filter ) (fBandAll = 0, fBandSelect = 1, fBandReject = 2
                  /////////////////////////// fBandPass = 3, fHighPass = 4, fLowPass = 5)
                  ////////// AlsoBuf : The filter alter buffer aswell ( otherwise, only result is filled in fft.data )
                  ////////// LoopProc : External procedure to execute after DSP done
                  ////////// Enable :  Filter enabled
                  ////////// example : SetFilterIn(0,InputIndex1,FilterInIndex1,-1,-1,-1,False,True,nil);
begin
if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
  if  uosPlayersStat[PlayerIndex] = 1 then
  uosPlayers[PlayerIndex].SetFilterIn(InputIndex, FilterIndex, LowFrequency, HighFrequency, Gain,
                    TypeFilter, AlsoBuf, Enable, LoopProc);
end;

function uos_AddFilterOut(PlayerIndex: LongInt; OutputIndex: LongInt; LowFrequency: LongInt;
                    HighFrequency: LongInt; Gain: cfloat; TypeFilter: LongInt;
                    AlsoBuf: boolean; LoopProc: TProc): LongInt;
                  //////////// PlayerIndex : Index of a existing Player
                  ////////// OutputIndex : OutputIndex of a existing Output
                  ////////// LowFrequency : Lowest frequency of filter
                  ////////// HighFrequency : Highest frequency of filter
                  ////////// Gain : gain to apply to filter
                  ////////// TypeFilter: Type of filter : default = -1 = fBandSelect (fBandAll = 0, fBandSelect = 1, fBandReject = 2
                  /////////////////////////// fBandPass = 3, fHighPass = 4, fLowPass = 5)
                  ////////// AlsoBuf : The filter alter buffer aswell ( otherwise, only result is filled in fft.data )
                  ////////// LoopProc : External procedure to execute after DSP done
                  //  result : index of DSPOut in array
                  ////////// example :FilterOutIndex1 := AddFilterOut(0,OutputIndex1,6000,16000,1,true,nil);
begin
 result := -1 ;
if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
  if  uosPlayersStat[PlayerIndex] = 1 then
result := uosPlayers[PlayerIndex].AddFilterout(OutputIndex, LowFrequency, HighFrequency, Gain, TypeFilter,
                    AlsoBuf, LoopProc) ;
end;

procedure uos_SetFilterOut(PlayerIndex: LongInt; OutputIndex: LongInt; FilterIndex: LongInt;
                    LowFrequency: LongInt; HighFrequency: LongInt; Gain: cfloat;
                    TypeFilter: LongInt; AlsoBuf: boolean; Enable: boolean; LoopProc: TProc);
                  //////////// PlayerIndex : Index of a existing Player
                  ////////// OutputIndex : OutputIndex of a existing Output
                  ////////// FilterIndex : DSPOutIndex of existing DSPOut
                  ////////// LowFrequency : Lowest frequency of filter ( -1 : current LowFrequency )
                  ////////// HighFrequency : Highest frequency of filter ( -1 : current HighFrequency )
                  ////////// Gain : gain to apply to filter
                  ////////// TypeFilter: Type of filter : ( -1 = current filter ) (fBandAll = 0, fBandSelect = 1, fBandReject = 2
                  /// fBandPass = 3, fHighPass = 4, fLowPass = 5)
                  ////////// AlsoBuf : The filter alter buffer aswell ( otherwise, only result is filled in fft.data )
                  ////////// Enable :  Filter enabled
                  ////////// LoopProc : External procedure to execute after DSP done
                  ////////// example : SetFilterOut(0,OutputIndex1,FilterOutIndex1,1000,1500,-1,True,True,nil);
begin
if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
  if  uosPlayersStat[PlayerIndex] = 1 then
  uosPlayers[PlayerIndex].SetFilterOut(OutputIndex, FilterIndex, LowFrequency, HighFrequency, Gain,
                    TypeFilter, AlsoBuf, Enable, LoopProc);
end;



function uos_AddFromDevIn(PlayerIndex: LongInt; Device: LongInt; Latency: CDouble;
             SampleRate: LongInt; Channels: LongInt; OutputIndex: LongInt;
             SampleFormat: LongInt; FramesCount : LongInt): LongInt;
              ////// Add a Input from Device Input with custom parameters
              //////////// PlayerIndex : Index of a existing Player
               //////////// Device ( -1 is default Input device )
               //////////// Latency  ( -1 is latency suggested ) )
               //////////// SampleRate : delault : -1 (44100)
               //////////// Channels : delault : -1 (2:stereo) (0: no channels, 1:mono, 2:stereo, ...)
               //////////// OutputIndex : Output index of used output// -1: all output, -2: no output, other LongInt refer to a existing OutputIndex  (if multi-output then OutName = name of each output separeted by ';')
               //////////// SampleFormat : default : -1 (1:Int16) (0: Float32, 1:Int32, 2:Int16)
               //////////// FramesCount : default : -1 (65536)
               //  result : Output Index in array , -1 is error
               /// example : OutputIndex1 := AddFromDevice(-1,-1,-1,-1,-1,-1);
begin
  result := -1 ;
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
    if  uosPlayersStat[PlayerIndex] = 1 then
  Result :=  uosPlayers[PlayerIndex].AddFromDevIn(Device, Latency, SampleRate, Channels, OutputIndex,
             SampleFormat, FramesCount) ;
end;

function uos_AddFromDevIn(PlayerIndex: LongInt): LongInt;
              ////// Add a Input from Device Input with custom parameters
              ///////// PlayerIndex : Index of a existing Player
begin
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
    if  uosPlayersStat[PlayerIndex] = 1 then
  Result :=  uosPlayers[PlayerIndex].AddFromDevIn(-1, -1, -1, -1, -1, -1, -1) ;
end;


function uos_AddIntoFile(PlayerIndex: LongInt; Filename: PChar; SampleRate: LongInt;
                 Channels: LongInt; SampleFormat: LongInt ; FramesCount: LongInt): LongInt;
               /////// Add a Output into audio wav file with custom parameters
               //////////// PlayerIndex : Index of a existing Player
               ////////// FileName : filename of saved audio wav file
               //////////// SampleRate : delault : -1 (44100)
               //////////// Channels : delault : -1 (2:stereo) (0: no channels, 1:mono, 2:stereo, ...)
               //////////// SampleFormat : default : -1 (1:Int16) (0: Float32, 1:Int32, 2:Int16)
               //////////// FramesCount : default : -1 (= 65536)
               //  result :  Output Index in array     -1 = error;
               //////////// example : OutputIndex1 := AddIntoFile(0,edit5.Text,-1,-1, 0, -1);
begin
   result := -1 ;
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
    if  uosPlayersStat[PlayerIndex] = 1 then
 Result :=  uosPlayers[PlayerIndex].AddIntoFile(Filename, SampleRate, Channels, SampleFormat, FramesCount);
end;

function uos_AddIntoFile(PlayerIndex: LongInt;  Filename: PChar): LongInt;
               /////// Add a Output into audio wav file with Default parameters
              //////////// PlayerIndex : Index of a existing Player
              ////////// FileName : filename of saved audio wav file
 begin
      if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
     if  uosPlayersStat[PlayerIndex] = 1 then
 Result :=  uosPlayers[PlayerIndex].AddIntoFile(Filename, -1, -1, -1, -1);
end;



function uos_AddIntoDevOut(PlayerIndex: LongInt; Device: LongInt; Latency: CDouble;
            SampleRate: LongInt; Channels: LongInt; SampleFormat: LongInt ; FramesCount: LongInt ): LongInt;
          ////// Add a Output into Device Output with custom parameters
begin
  result := -1 ;
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
    if  uosPlayersStat[PlayerIndex] = 1 then
  Result :=  uosPlayers[PlayerIndex].AddIntoDevOut(Device, Latency, SampleRate, Channels, SampleFormat , FramesCount);
end;
          //////////// PlayerIndex : Index of a existing Player
          //////////// Device ( -1 is default device )
          //////////// Latency  ( -1 is latency suggested ) )
          //////////// SampleRate : delault : -1 (44100)
          //////////// Channels : delault : -1 (2:stereo) (0: no channels, 1:mono, 2:stereo, ...)
          //////////// SampleFormat : default : -1 (1:Int16) (0: Float32, 1:Int32, 2:Int16)
          //////////// FramesCount : default : -1 (= 65536)
          //  result : -1 nothing created, otherwise Output Index in array
          /// example : OutputIndex1 := uos_AddIntoDevOut(0,-1,-1,-1,-1,0,-1);

function uos_AddIntoDevOut(PlayerIndex: LongInt): LongInt;
          ////// Add a Output into Device Output with default parameters
begin
  Result := -1 ;
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
    if  uosPlayersStat[PlayerIndex] = 1 then
  Result :=  uosPlayers[PlayerIndex].AddIntoDevOut(-1, -1, -1, -1, -1 ,-1);
end;


function uos_AddFromFile(PlayerIndex: LongInt; Filename: PChar; OutputIndex: LongInt;
              SampleFormat: LongInt ; FramesCount: LongInt): LongInt;
    /////// Add a input from audio file with custom parameters
    //////////// PlayerIndex : Index of a existing Player
    ////////// FileName : filename of audio file
    ////////// OutputIndex : Output index of used output// -1: all output, -2: no output, other LongInt refer to a existing OutputIndex  (if multi-output then OutName = name of each output separeted by ';')
    //////////// SampleFormat : default : -1 (1:Int16) (0: Float32, 1:Int32, 2:Int16)
    //////////// FramesCount : default : -1 (65536)
    //  result : Input Index in array    -1 = error
    //////////// example : InputIndex1 := AddFromFile(0, edit5.Text,-1,-1);
begin
  result := -1 ;
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
     if  uosPlayersStat[PlayerIndex] = 1 then
  Result := uosPlayers[PlayerIndex].AddFromFile(Filename, OutputIndex, SampleFormat, FramesCount);
end;

function uos_AddFromFile(PlayerIndex: LongInt; Filename: PChar): LongInt;
            /////// Add a input from audio file with default parameters
begin
  result := -1 ;
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
    if  uosPlayersStat[PlayerIndex] = 1 then
  Result := uosPlayers[PlayerIndex].AddFromFile(Filename, -1, -1, -1);
end;

function uos_AddPlugin(PlayerIndex: LongInt; PlugName: PChar; SampleRate: LongInt;
                       Channels: LongInt): LongInt;
                     /////// Add a plugin , result is PluginIndex
                     //////////// PlayerIndex : Index of a existing Player
                     //////////// SampleRate : delault : -1 (44100)
                     //////////// Channels : delault : -1 (2:stereo) (1:mono, 2:stereo, ...)
                     ////// Till now, only 'soundtouch' PlugName is registred.
begin
  result := -1 ;
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
    if  uosPlayersStat[PlayerIndex] = 1 then
  Result := uosPlayers[PlayerIndex].AddPlugin(PlugName, SampleRate, Channels);
end;

procedure uos_SetPluginSoundTouch(PlayerIndex: LongInt; PluginIndex: LongInt; Tempo: cfloat;
                       Pitch: cfloat; Enable: boolean);
                     ////////// PluginIndex : PluginIndex Index of a existing Plugin.
                     //////////// PlayerIndex : Index of a existing Player
begin
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
    if  uosPlayersStat[PlayerIndex] = 1 then
 uosPlayers[PlayerIndex].SetPluginSoundTouch(PluginIndex, Tempo, Pitch, Enable);
end;

procedure uos_Seek(PlayerIndex: LongInt; InputIndex: LongInt; pos: Tsf_count_t);
                     //// change position in sample
begin
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
    if  uosPlayersStat[PlayerIndex] = 1 then
  uosPlayers[PlayerIndex].Seek(InputIndex, pos);
end;

function uos_GetStatus(PlayerIndex: LongInt) : LongInt ;
                         /////// Get the status of the player : -1 => error, 0 => has stopped, 1 => is running, 2 => is paused.
begin
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
  begin
 if  uosPlayersStat[PlayerIndex] = 1 then
 result :=  uosPlayers[PlayerIndex].Status else result := -1 ;
 end else  result := -1 ;
end;

procedure uos_SeekSeconds(PlayerIndex: LongInt; InputIndex: LongInt; pos: cfloat);
                     //// change position in seconds
begin
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
    if  uosPlayersStat[PlayerIndex] = 1 then
  uosPlayers[PlayerIndex].SeekSeconds(InputIndex, pos);
end;

procedure uos_SeekTime(PlayerIndex: LongInt; InputIndex: LongInt; pos: TTime);
                     //// change position in time format
begin
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
    if  uosPlayersStat[PlayerIndex] = 1 then
  uosPlayers[PlayerIndex].SeekTime(InputIndex, pos);
end;

function uos_InputLength(PlayerIndex: LongInt; InputIndex: LongInt): longint;
                     ////////// InputIndex : InputIndex of existing input
                     ///////  result : Length of Input in samples
begin
  result := 0;
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
    if  uosPlayersStat[PlayerIndex] = 1 then
 result := uosPlayers[PlayerIndex].InputLength(InputIndex) ;
end;

function uos_InputLengthSeconds(PlayerIndex: LongInt; InputIndex: LongInt): cfloat;
                     ////////// InputIndex : InputIndex of existing input
                     ///////  result : Length of Input in seconds
begin
   result := 0;
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
    if  uosPlayersStat[PlayerIndex] = 1 then
 result := uosPlayers[PlayerIndex].InputLengthSeconds(InputIndex) ;
end;

function uos_InputLengthTime(PlayerIndex: LongInt; InputIndex: LongInt): TTime;
                     ////////// InputIndex : InputIndex of existing input
                     ///////  result : Length of Input in time format
begin
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
    if  uosPlayersStat[PlayerIndex] = 1 then
 result := uosPlayers[PlayerIndex].InputLengthTime(InputIndex) ;
end;

function uos_InputPosition(PlayerIndex: LongInt; InputIndex: LongInt): longint;
                     ////////// InputIndex : InputIndex of existing input
                     ////// result : current postion in sample
begin
   result := 0;
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
    if  uosPlayersStat[PlayerIndex] = 1 then
 result := uosPlayers[PlayerIndex].InputPosition(InputIndex) ;
end;

procedure uos_InputSetLevelEnable(PlayerIndex: LongInt; InputIndex: LongInt ; enable : boolean);
                   ///////// enable/disable level calculation (default is false/disable)
begin
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
    if  uosPlayersStat[PlayerIndex] = 1 then
 uosPlayers[PlayerIndex].StreamIn[InputIndex].Data.levelEnable:= enable;
end;

function uos_InputGetLevelLeft(PlayerIndex: LongInt; InputIndex: LongInt): double;
                     ////////// InputIndex : InputIndex of existing input
                     ////// result : left level(volume) from 0 to 1
begin
   result := 0;
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
    if  uosPlayersStat[PlayerIndex] = 1 then
 result := uosPlayers[PlayerIndex].InputGetLevelLeft(InputIndex) ;
end;

function uos_InputGetSampleRate(PlayerIndex: LongInt; InputIndex: LongInt): LongInt;
                     ////////// InputIndex : InputIndex of existing input
                     ////// result : default sample rate
begin
   result := 0;
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) and
  (length(uosPlayers[PlayerIndex].StreamIn) > 0) and (InputIndex +1 <= length(uosPlayers[PlayerIndex].StreamIn))
  then
    if  uosPlayersStat[PlayerIndex] = 1 then
 result := uosPlayers[PlayerIndex].StreamIn[InputIndex].Data.SamplerateRoot;
end;

function uos_InputGetChannels(PlayerIndex: LongInt; InputIndex: LongInt): LongInt;
                     ////////// InputIndex : InputIndex of existing input
                     ////// result : default channels
begin
   result := 0;
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) and
  (length(uosPlayers[PlayerIndex].StreamIn) > 0) and (InputIndex +1 <= length(uosPlayers[PlayerIndex].StreamIn))
  then
    if  uosPlayersStat[PlayerIndex] = 1 then
 result := uosPlayers[PlayerIndex].StreamIn[InputIndex].Data.Channels;
end;

function uos_InputGetLevelRight(PlayerIndex: LongInt; InputIndex: LongInt): double;
                     ////////// InputIndex : InputIndex of existing input
                     ////// result : right level(volume) from 0 to 1
begin
   result := 0;
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
    if  uosPlayersStat[PlayerIndex] = 1 then
 result := uosPlayers[PlayerIndex].InputGetLevelRight(InputIndex) ;
end;

function uos_InputPositionSeconds(PlayerIndex: LongInt; InputIndex: LongInt): cfloat;
                     ////////// InputIndex : InputIndex of existing input
                     ///////  result : current postion of Input in seconds
begin
   result := 0;
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
    if  uosPlayersStat[PlayerIndex] = 1 then
 result := uosPlayers[PlayerIndex].InputPositionSeconds(InputIndex) ;
end;

function uos_InputPositionTime(PlayerIndex: LongInt; InputIndex: LongInt): TTime;
                     ////////// InputIndex : InputIndex of existing input
                     ///////  result : current postion of Input in time format
begin
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
    if  uosPlayersStat[PlayerIndex] = 1 then
 result := uosPlayers[PlayerIndex].InputPositionTime(InputIndex) ;
end;

Procedure uos_Play(PlayerIndex: LongInt) ;        ///// Start playing
begin
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
  if  uosPlayersStat[PlayerIndex] = 1 then
uosPlayers[PlayerIndex].Play() ;
end;

procedure uos_RePlay(PlayerIndex: LongInt);                ///// Resume playing after pause
begin
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
  if  uosPlayersStat[PlayerIndex] = 1 then
uosPlayers[PlayerIndex].RePlay() ;
end;

procedure uos_Stop(PlayerIndex: LongInt);                  ///// Stop playing and free thread
begin
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
uosPlayers[PlayerIndex].Stop() ;
end;

procedure uos_Pause(PlayerIndex: LongInt);                 ///// Pause playing
begin
  if (length(uosPlayers) > 0) and (PlayerIndex +1 <= length(uosPlayers)) then
    if  uosPlayersStat[PlayerIndex] = 1 then
uosPlayers[PlayerIndex].Pause() ;
end;


procedure uos_BeginProc(PlayerIndex: LongInt; Proc: TProc );
                 ///// Assign the procedure of object to execute at begin, before loop
                 //////////// PlayerIndex : Index of a existing Player
begin
  uosPlayers[PlayerIndex].BeginProc := Proc;
end;

procedure uos_EndProc(PlayerIndex: LongInt; Proc: TProc );
                 ///// Assign the procedure of object to execute at end, after loop
                //////////// PlayerIndex : Index of a existing Player
                   //////////// InIndex : Index of a existing Input
begin
 uosPlayers[PlayerIndex].EndProc := Proc;
end;


procedure uos_LoopProcIn(PlayerIndex: LongInt; InIndex: LongInt; Proc: TProc );
                      ///// Assign the procedure of object to execute inside the loop
                      //////////// PlayerIndex : Index of a existing Player
                      //////////// InIndex : Index of a existing Input
begin
  uosPlayers[PlayerIndex].StreamIn[InIndex].LoopProc := Proc;
end;

procedure uos_LoopProcOut(PlayerIndex: LongInt; OutIndex: LongInt; Proc: TProc);
                       ///// Assign the procedure of object to execute inside the loop
                      //////////// PlayerIndex : Index of a existing Player
                      //////////// OutIndex : Index of a existing Output
begin
 uosPlayers[PlayerIndex].StreamOut[OutIndex].LoopProc := Proc;
end;


function uos_loadlib(PortAudioFileName, SndFileFileName, Mpg123FileName, SoundTouchFileName: PChar) : LongInt;
  begin
   ifflat := true;
result := uos.uos_loadlib(PortAudioFileName, SndFileFileName, Mpg123FileName, SoundTouchFileName)  ;
//uosLoadResult:= uos.uosLoadResult;
  end;

function uos_GetVersion() : LongInt ;
begin
result := uos.uos_GetVersion() ;
end;

procedure uos_unloadlib() ;
  var
   x: LongInt;
  begin
     if (length(uosPlayers) > 0) then
      for x := 0 to high(uosPlayers) do
       if  uosPlayersStat[x] = 1 then
       begin
        if  uosPlayers[x].Status > 0 then
      begin
      uosPlayers[x].Stop();
      sleep(300) ;
      end;
      end;

     setlength(uosPlayers, 0) ;
     setlength(uosPlayersStat, 0) ;

uos.uos_unloadlib() ;
end;

procedure uos_unloadlibCust(PortAudio, SndFile, Mpg123, SoundTouch: boolean);
                    ////// Custom Unload libraries... if true, then delete the library. You may unload what and when you want...
begin
uos.uos_unloadlibcust(PortAudio, SndFile, Mpg123, SoundTouch) ;
uosLoadResult:= uos.uosLoadResult;
end;

procedure uos_GetInfoDevice();
var
x : integer = 0;
begin
uos.uos_GetInfoDevice();
setlength(uosDeviceInfos,length(uos.uosDeviceInfos));

uosDeviceInfos := uos.uosDeviceInfos;

uosDeviceCount:= uos.uosDeviceCount;
uosDefaultDeviceIn:= uos.uosDefaultDeviceIn;
uosDefaultDeviceOut:= uos.uosDefaultDeviceOut;
end;

function uos_GetInfoDeviceStr() : PChar ;
begin
result := uos.uos_GetInfoDeviceStr();
uosDeviceCount:= uos.uosDeviceCount;
uosDefaultDeviceIn:= uos.uosDefaultDeviceIn;
uosDefaultDeviceOut:= uos.uosDefaultDeviceOut;
end;

// Create the player , PlayerIndex1 : from 0 to what your computer can do !
//// If PlayerIndex exists already, it will be overwriten...

{$IF (FPC_FULLVERSION>=20701) or DEFINED(LCL) or DEFINED(ConsoleApp) or DEFINED(Library) or DEFINED(Windows)}
  procedure uos_CreatePlayer(PlayerIndex : LongInt);
     {$else}
  procedure uos_CreatePlayer(PlayerIndex : LongInt ; AParent: TObject);            //// for fpGUI
    {$endif}

 var
x : LongInt;
begin
if PlayerIndex + 1 > length(uosPlayers) then
begin
 setlength(uosPlayers,PlayerIndex + 1) ;
 setlength(uosPlayersStat,PlayerIndex + 1) ;
end;

 {$IF ( FPC_FULLVERSION>=20701)or DEFINED(LCL) or DEFINED(ConsoleApp) or DEFINED(Library) or DEFINED(Windows)}
     uosPlayers[PlayerIndex] := Tuos_Player.Create(true);
     {$else}
    uosPlayers[PlayerIndex] := Tuos_Player.Create(true,AParent);         //// for fpGUI
    {$endif}

   uosPlayers[PlayerIndex].Index := PlayerIndex;
   uosPlayersStat[PlayerIndex] := 1 ;
   for x := 0 to length(uosPlayersStat) -1 do
if uosPlayersStat[x] <> 1 then
begin
uosPlayersStat[x] := -1 ;
uosPlayers[x] := nil ;
end;
end;


end.