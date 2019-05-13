% Written by Phani Karamched, University of Oxford to add a pattern to .h5
% file to solve the one pattern problem
%The script copies the penultimate pattern to the last pattern
%position and make x,y position changes accordingly


InputUser.hdf5file='T:\Phani\AL\indent_25.h5';
%InputUser.hdf5file='T:\Phani\AL\1_2ebsp.h5';
OutputUser.hdf5file=[InputUser.hdf5file(1:end-3) '_corrected.h5'];
 

if  h5read(InputUser.hdf5file,'/Manufacturer')~='Bruker Nano'
    error('Dont think it is the right file !')
else
    disp('Starting to read initial values')
end
 
 
%Write basics 
%Manufacturer & Version
fid = H5F.create(OutputUser.hdf5file);
type_id = H5T.copy('H5T_C_S1');
space_id = H5S.create_simple(1,1,1);
space_id = H5S.create('H5S_SCALAR');
dcpl = 'H5P_DEFAULT';

H5T.set_size(type_id, length(h5read(InputUser.hdf5file,'/Version')));
dset_id = H5D.create(fid,'Version',type_id,space_id,dcpl);
H5D.write(dset_id,'H5ML_DEFAULT','H5S_ALL','H5S_ALL',dcpl,h5read(InputUser.hdf5file,'/Version'));

H5T.set_size(type_id, length(h5read(InputUser.hdf5file,'/Manufacturer')));
dset_id = H5D.create(fid,'Manufacturer',type_id,space_id,dcpl);
H5D.write(dset_id,'H5ML_DEFAULT','H5S_ALL','H5S_ALL',dcpl,h5read(InputUser.hdf5file,'/Manufacturer'));

H5S.close(space_id)
H5T.close(type_id)
H5D.close(dset_id)

%Read Root Group 
[~,rootname,~]=fileparts(InputUser.hdf5file);
%Create and Write groups of SEM and EBSD DATA

%Create groups for SEM and EBSD data and string type data
gid1= H5G.create(fid,rootname,dcpl,dcpl,dcpl);
    gid1_1=H5G.create(gid1,'SEM',dcpl,dcpl,dcpl);
    H5G.close(gid1_1);
    gid1_2=H5G.create(gid1,'EBSD',dcpl,dcpl,dcpl);
    gid1_2_1=H5G.create(gid1_2,'Header',dcpl,dcpl,dcpl);
        type_id = H5T.copy('H5T_C_S1');
        gridtype= h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/Grid Type']);
        H5T.set_size(type_id, length(gridtype));
        space_id = H5S.create_simple(1,1,1);
        dset_id = H5D.create(gid1_2_1,'GridType',type_id,space_id,dcpl);
        H5D.write(dset_id,'H5ML_DEFAULT','H5S_ALL','H5S_ALL',dcpl,gridtype);
        
        Originalfile=InputUser.hdf5file;
        H5T.set_size(type_id, length(Originalfile));
        dset_id = H5D.create(gid1_2_1,'OriginalFile',type_id,space_id,dcpl);
        H5D.write(dset_id,'H5ML_DEFAULT','H5S_ALL','H5S_ALL',dcpl,Originalfile);
        H5S.close(space_id)
        H5T.close(type_id)
        H5D.close(dset_id)
        
        
        gid1_2_1_1=H5G.create(gid1_2_1,'Phases',dcpl,dcpl,dcpl);
        t_phases=h5info(InputUser.hdf5file,['/' rootname '/EBSD/Header/Phases']);
        nophases=length(t_phases.Groups);
        for i=1:nophases
           
            formula=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/Phases/' int2str(i) '/Formula']);
            phasename=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/Phases/' int2str(i) '/Name']);
            spacegroup=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/Phases/' int2str(i) '/SpaceGroup']);
            gid1_2_1_1_1=H5G.create(gid1_2_1_1,int2str(i),dcpl,dcpl,dcpl);
            type_id = H5T.copy('H5T_C_S1');
            space_id = H5S.create_simple(1,1,1);
            H5T.set_size(type_id, length(formula));
            dset_id = H5D.create(gid1_2_1_1_1,'Formula',type_id,space_id,dcpl);
            H5D.write(dset_id,'H5ML_DEFAULT','H5S_ALL','H5S_ALL',dcpl,formula);
            H5S.close(space_id)
            H5T.close(type_id)
            H5D.close(dset_id)
            
            type_id = H5T.copy('H5T_C_S1');
            space_id = H5S.create_simple(1,1,1);
            H5T.set_size(type_id, length(phasename));
            dset_id = H5D.create(gid1_2_1_1_1,'Name',type_id,space_id,dcpl);
            H5D.write(dset_id,'H5ML_DEFAULT','H5S_ALL','H5S_ALL',dcpl,phasename);
            H5S.close(space_id)
            H5T.close(type_id)
            H5D.close(dset_id)
            
            type_id = H5T.copy('H5T_C_S1');
            space_id = H5S.create_simple(1,1,1);
            H5T.set_size(type_id, length(spacegroup));
            dset_id = H5D.create(gid1_2_1_1_1,'SpaceGroup',type_id,space_id,dcpl);
            H5D.write(dset_id,'H5ML_DEFAULT','H5S_ALL','H5S_ALL',dcpl,spacegroup);
            H5S.close(space_id)
            H5T.close(type_id)
            H5D.close(dset_id)
            
%             type_id = H5T.copy('H5T_NATIVE_DOUBLE');
%             %H5T.set_size(type_id, length(gridtype));
%             space_id = H5S.create_simple([1 6],[1 6],[1 6]);
%             dset_id = H5D.create(gid1_2_1,'LatticeConstants',type_id,space_id,dcpl);
%             H5S.close(space_id)
%             H5T.close(type_id)
%             H5D.close(dset_id)
            
            
            H5G.close(gid1_2_1_1_1);
        end
        
        H5G.close(gid1_2_1_1)
        gid1_2_1_2=H5G.create(gid1_2_1,'Coordinate Systems',dcpl,dcpl,dcpl);
        type_id = H5T.copy('H5T_C_S1');
        space_id = H5S.create_simple(1,1,1);
        H5T.set_size(type_id, 45);
        dset_id = H5D.create(gid1_2_1_2,'Tutorial paper on EBSD',type_id,space_id,dcpl);
        H5D.write(dset_id,'H5ML_DEFAULT','H5S_ALL','H5S_ALL',dcpl,'https://doi.org/10.1016/j.matchar.2016.04.008');
        H5S.close(space_id)
        H5T.close(type_id)
        H5D.close(dset_id)
        H5G.close(gid1_2_1_2);
        
        
        
    H5G.close(gid1_2_1);
    gid1_2_2=H5G.create(gid1_2,'Data',dcpl,dcpl,dcpl);
    H5G.close(gid1_2_2);
    H5G.close(gid1_2);
H5G.close(gid1);
H5F.close(fid);



warning('off','all');
%Add numerical data
for i=1:nophases
   
    %h5create(InputUser.HDF5_File,strcat('/',OutputFile,'/EBSD/Header/Phases/',int2str(i),'/LatticeConstants'),[1,6]);
    %h5write(InputUser.HDF5_File,strcat('/',OutputFile,'/EBSD/Header/Phases/',int2str(i),'/LatticeConstants'),t);
    
    LaueGroup=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/Phases/' int2str(i) '/IT']);
    Latticeconstants=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/Phases/' int2str(i) '/LatticeConstants']);
        
    h5create(OutputUser.hdf5file,['/',rootname,'/EBSD/Header/Phases/' int2str(i) '/IT'],1,'Datatype','int32');
    h5write(OutputUser.hdf5file,strcat('/',rootname,'/EBSD/Header/Phases/',int2str(i),'/IT'),LaueGroup);
    
    h5create(OutputUser.hdf5file,strcat('/',rootname,'/EBSD/Header/Phases/',int2str(i),'/LatticeConstants'),[1 6]);
    h5write(OutputUser.hdf5file,strcat('/',rootname,'/EBSD/Header/Phases/',int2str(i),'/LatticeConstants'),Latticeconstants');
end


%Write SEM Parts
disp('Writing SEM Data')
SEM_KV=h5read(InputUser.hdf5file,['/' rootname '/SEM/SEM KV']);
h5create(OutputUser.hdf5file,['/' rootname '/SEM/SEM KV/'],1);
h5write(OutputUser.hdf5file,['/' rootname '/SEM/SEM KV/'],SEM_KV);

SEM_IMAGE_HEIGHT=h5read(InputUser.hdf5file,['/' rootname '/SEM/SEM ImageHeight']);
h5create(OutputUser.hdf5file,['/' rootname '/SEM/SEM ImageHeight/'],1);
h5write(OutputUser.hdf5file,['/' rootname '/SEM/SEM ImageHeight/'],SEM_IMAGE_HEIGHT);

SEM_IMAGE_WIDTH=h5read(InputUser.hdf5file,['/' rootname '/SEM/SEM ImageWidth']);
h5create(OutputUser.hdf5file,['/' rootname '/SEM/SEM ImageWidth/'],1);
h5write(OutputUser.hdf5file,['/' rootname '/SEM/SEM ImageWidth/'],SEM_IMAGE_WIDTH);

SEM_MAG=h5read(InputUser.hdf5file,['/' rootname '/SEM/SEM Magnification']);
h5create(OutputUser.hdf5file,['/' rootname '/SEM/SEM Magnification/'],1);
h5write(OutputUser.hdf5file,['/' rootname '/SEM/SEM Magnification/'],SEM_MAG);



SEM_WD=h5read(InputUser.hdf5file,['/' rootname '/SEM/SEM WD']);
h5create(OutputUser.hdf5file,['/' rootname '/SEM/SEM WD/'],1);
h5write(OutputUser.hdf5file,['/' rootname '/SEM/SEM WD/'],SEM_WD);

SEM_XResolution=h5read(InputUser.hdf5file,['/' rootname '/SEM/SEM XResolution']);
h5create(OutputUser.hdf5file,['/' rootname '/SEM/SEM XResolution/'],1);
h5write(OutputUser.hdf5file,['/' rootname '/SEM/SEM XResolution/'],SEM_XResolution);

SEM_YResolution=h5read(InputUser.hdf5file,['/' rootname '/SEM/SEM YResolution']);
h5create(OutputUser.hdf5file,['/' rootname '/SEM/SEM YResolution/'],1);
h5write(OutputUser.hdf5file,['/' rootname '/SEM/SEM YResolution/'],SEM_YResolution);

SEM_ZOffset=h5read(InputUser.hdf5file,['/' rootname '/SEM/SEM ZOffset']);
h5create(OutputUser.hdf5file,['/' rootname '/SEM/SEM ZOffset/'],1);
h5write(OutputUser.hdf5file,['/' rootname '/SEM/SEM ZOffset/'],SEM_ZOffset);

SEM_IX=h5read(InputUser.hdf5file,['/' rootname '/SEM/SEM IX']);
SEM_IX=[SEM_IX;SEM_IX(end)+1];
h5create(OutputUser.hdf5file,['/' rootname '/SEM/SEM IX/'],[1 length(SEM_IX)]);
h5write(OutputUser.hdf5file,['/' rootname '/SEM/SEM IX/'],SEM_IX');


SEM_IY=h5read(InputUser.hdf5file,['/' rootname '/SEM/SEM IY']);
SEM_IY=[SEM_IY;SEM_IY(end)];
h5create(OutputUser.hdf5file,['/' rootname '/SEM/SEM IY/'],[1 length(SEM_IY)]);
h5write(OutputUser.hdf5file,['/' rootname '/SEM/SEM IY/'],SEM_IY');

SEM_IMAGE=h5read(InputUser.hdf5file,['/' rootname '/SEM/SEM Image']);
h5create(OutputUser.hdf5file,['/' rootname '/SEM/SEM Image/'],[size(SEM_IMAGE,1) size(SEM_IMAGE,2) 1]);
h5write(OutputUser.hdf5file,['/' rootname '/SEM/SEM IY/'],SEM_IY');



%EBSD Headers write
disp('Writing EBSD Headers')

EBSD_Coordsystems=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/Coordinate Systems/ESPRIT Coordinates/']);
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Header/Coordinate Systems/ESPRIT Coordinates/'],[size(EBSD_Coordsystems,1),size(EBSD_Coordsystems,2)]);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Header/Coordinate Systems/ESPRIT Coordinates/'],EBSD_Coordsystems);

%add attributes to the image.... 
att1=h5readatt(InputUser.hdf5file,['/' rootname '/EBSD/Header/Coordinate Systems/ESPRIT Coordinates/'],'CLASS');
att2=h5readatt(InputUser.hdf5file,['/' rootname '/EBSD/Header/Coordinate Systems/ESPRIT Coordinates/'],'IMAGE_SUBCLASS');
att3=h5readatt(InputUser.hdf5file,['/' rootname '/EBSD/Header/Coordinate Systems/ESPRIT Coordinates/'],'IMAGE_VERSION');
att4=h5readatt(InputUser.hdf5file,['/' rootname '/EBSD/Header/Coordinate Systems/ESPRIT Coordinates/'],'IMAGE_WHITE_IS_ZERO');
h5writeatt(OutputUser.hdf5file,['/' rootname '/EBSD/Header/Coordinate Systems/ESPRIT Coordinates/'],'CLASS',att1);
h5writeatt(OutputUser.hdf5file,['/' rootname '/EBSD/Header/Coordinate Systems/ESPRIT Coordinates/'],'IMAGE_SUBCLASS',att2);
h5writeatt(OutputUser.hdf5file,['/' rootname '/EBSD/Header/Coordinate Systems/ESPRIT Coordinates/'],'IMAGE_VERSION',att3);
h5writeatt(OutputUser.hdf5file,['/' rootname '/EBSD/Header/Coordinate Systems/ESPRIT Coordinates/'],'IMAGE_SHITE_IS_ZERO',att4);




EBSD_CoordID=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/Coordinate Systems/ID/']);
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Header/Coordinate Systems/ID/'],1);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Header/Coordinate Systems/ID/'],EBSD_CoordID);



EBSD_CameraTilt=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/CameraTilt']);
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Header/CameraTilt'],1);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Header/CameraTilt/'],EBSD_CameraTilt);


EBSD_DetectorFullHeightMicrons=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/DetectorFullHeightMicrons']);
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Header/DetectorFullHeightMicrons'],1);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Header/DetectorFullHeightMicrons/'],EBSD_DetectorFullHeightMicrons);

EBSD_DetectorFullWidthMicrons=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/DetectorFullWidthMicrons']);
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Header/DetectorFullWidthMicrons'],1);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Header/DetectorFullWidthMicrons/'],EBSD_DetectorFullWidthMicrons);


EBSD_KV=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/KV']);
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Header/KV'],1);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Header/KV/'],EBSD_KV);

EBSD_MADMax=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/MADMax']);
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Header/MADMax'],1);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Header/MADMax/'],EBSD_MADMax);

EBSD_Magnification=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/Magnification']);
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Header/Magnification'],1);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Header/Magnification/'],EBSD_Magnification);


EBSD_MapStepFactor=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/MapStepFactor']);
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Header/MapStepFactor'],1);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Header/MapStepFactor/'],EBSD_MapStepFactor);


EBSD_MaxRadonBandCount=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/MaxRadonBandCount']);
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Header/MaxRadonBandCount'],1);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Header/MaxRadonBandCount/'],EBSD_MaxRadonBandCount);


EBSD_MinIndexedBands=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/MinIndexedBands']);
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Header/MinIndexedBands'],1);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Header/MinIndexedBands/'],EBSD_MinIndexedBands);

EBSD_NCOLS=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/NCOLS']);
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Header/NCOLS'],1);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Header/NCOLS/'],EBSD_NCOLS);

EBSD_NROWS=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/NROWS']);
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Header/NROWS'],1);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Header/NROWS/'],EBSD_NROWS);

EBSD_NPoints=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/NPoints']);
EBSD_NPoints=EBSD_NPoints+1;
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Header/NPoints'],1);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Header/NPoints/'],EBSD_NPoints);

EBSD_PatternHeight=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/PatternHeight']);
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Header/PatternHeight'],1);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Header/PatternHeight/'],EBSD_PatternHeight);

EBSD_PatternWidth=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/PatternWidth']);
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Header/PatternWidth'],1);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Header/PatternWidth/'],EBSD_PatternWidth);

EBSD_PixelByteCount=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/PixelByteCount']);
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Header/PixelByteCount'],1);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Header/PixelByteCount/'],EBSD_PixelByteCount);

EBSD_SEM_Image=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/SEM Image']);
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Header/SEM Image/'],[size(EBSD_SEM_Image,1) size(EBSD_SEM_Image,2) size(EBSD_SEM_Image,3)]); %CMM edit - variable last index depending on how many argus diodes used?
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Header/SEM Image/'],EBSD_SEM_Image);

EBSD_SEPixelSizeX=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/SEPixelSizeX']);
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Header/SEPixelSizeX'],1);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Header/SEPixelSizeX/'],EBSD_SEPixelSizeX);


EBSD_SEPixelSizeY=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/SEPixelSizeY']);
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Header/SEPixelSizeY'],1);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Header/SEPixelSizeY/'],EBSD_SEPixelSizeY);


EBSD_SampleTilt=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/SampleTilt']);
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Header/SampleTilt'],1);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Header/SampleTilt/'],EBSD_SampleTilt);

EBSD_TopClip=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/TopClip']);
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Header/TopClip'],1);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Header/TopClip/'],EBSD_TopClip);

EBSD_UnClippedPatternHeight=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/UnClippedPatternHeight']);
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Header/UnClippedPatternHeight'],1);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Header/UnClippedPatternHeight/'],EBSD_UnClippedPatternHeight);

EBSD_WD=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/WD']);
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Header/WD'],1);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Header/WD/'],EBSD_WD);

EBSD_XSTEP=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/XSTEP']);
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Header/XSTEP'],1);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Header/XSTEP/'],EBSD_XSTEP);


EBSD_YSTEP=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/YSTEP']);
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Header/YSTEP'],1);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Header/YSTEP/'],EBSD_YSTEP);

EBSD_ZOffset=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Header/ZOffset']);
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Header/ZOffset'],1);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Header/ZOffset/'],EBSD_ZOffset);


disp('Writing EBSD Data')
EBSD_DD=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Data/DD']);
EBSD_DD=[EBSD_DD;EBSD_DD(end)];
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Data/DD/'],[length(EBSD_DD) 1]);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Data/DD/'],EBSD_DD);

EBSD_MAD=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Data/MAD']);
EBSD_MAD=[EBSD_MAD;EBSD_MAD(end)];
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Data/MAD/'],[length(EBSD_MAD) 1]);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Data/MAD/'],EBSD_MAD);

EBSD_MADPhase=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Data/MADPhase']);
EBSD_MADPhase=[EBSD_MADPhase;EBSD_MADPhase(end)];
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Data/MADPhase/'],[length(EBSD_MADPhase) 1]);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Data/MADPhase/'],EBSD_MADPhase);


EBSD_NIndexedBands=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Data/NIndexedBands']);
EBSD_NIndexedBands=[EBSD_NIndexedBands;EBSD_NIndexedBands(end)];
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Data/NIndexedBands/'],[length(EBSD_NIndexedBands) 1]);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Data/NIndexedBands/'],EBSD_NIndexedBands);

EBSD_PCX=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Data/PCX']);
EBSD_PCX=[EBSD_PCX;EBSD_PCX(end)];
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Data/PCX/'],[length(EBSD_PCX) 1]);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Data/PCX/'],EBSD_PCX);

EBSD_PCY=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Data/PCY']);
EBSD_PCY=[EBSD_PCY;EBSD_PCY(end)];
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Data/PCY/'],[length(EBSD_PCY) 1]);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Data/PCY/'],EBSD_PCY);

EBSD_PHI=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Data/PHI']);
EBSD_PHI=[EBSD_PHI;EBSD_PHI(end)];
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Data/PHI/'],[length(EBSD_PHI) 1]);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Data/PHI/'],EBSD_PHI);


EBSD_Phase=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Data/Phase']);
EBSD_Phase=[EBSD_Phase;EBSD_Phase(end)];
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Data/Phase/'],[length(EBSD_Phase) 1]);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Data/Phase/'],EBSD_Phase);

EBSD_RadonBandCount=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Data/RadonBandCount']);
EBSD_RadonBandCount=[EBSD_RadonBandCount;EBSD_RadonBandCount(end)];
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Data/RadonBandCount/'],[length(EBSD_RadonBandCount) 1]);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Data/RadonBandCount/'],EBSD_RadonBandCount);

EBSD_RadonQuality=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Data/RadonQuality']);
EBSD_RadonQuality=[EBSD_RadonQuality;EBSD_RadonQuality(end)];
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Data/RadonQuality/'],[length(EBSD_RadonQuality) 1]);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Data/RadonQuality/'],EBSD_RadonQuality);


EBSD_X_BEAM=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Data/X BEAM']);
EBSD_X_BEAM=[EBSD_X_BEAM;EBSD_X_BEAM(end)+1];
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Data/X BEAM/'],[length(EBSD_X_BEAM) 1]);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Data/X BEAM/'],EBSD_X_BEAM);

EBSD_Y_BEAM=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Data/Y BEAM']);
EBSD_Y_BEAM=[EBSD_Y_BEAM;EBSD_Y_BEAM(end)];
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Data/Y BEAM/'],[length(EBSD_Y_BEAM) 1]);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Data/Y BEAM/'],EBSD_Y_BEAM);

EBSD_X_SAMPLE=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Data/X SAMPLE']);
EBSD_X_SAMPLE=[EBSD_X_SAMPLE;EBSD_X_SAMPLE(end)+EBSD_X_SAMPLE(2)-EBSD_X_SAMPLE(1)];
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Data/X SAMPLE/'],[length(EBSD_X_SAMPLE) 1]);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Data/X SAMPLE/'],EBSD_X_SAMPLE);

EBSD_Y_SAMPLE=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Data/Y SAMPLE']);
EBSD_Y_SAMPLE=[EBSD_Y_SAMPLE;EBSD_Y_SAMPLE(end)];
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Data/Y SAMPLE/'],[length(EBSD_Y_SAMPLE) 1]);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Data/Y SAMPLE/'],EBSD_Y_SAMPLE);



EBSD_phi1=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Data/phi1']);
EBSD_phi1=[EBSD_phi1;EBSD_phi1(end)];
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Data/phi1/'],[length(EBSD_phi1) 1]);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Data/phi1/'],EBSD_phi1);



EBSD_phi2=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Data/phi2']);
EBSD_phi2=[EBSD_phi2;EBSD_phi2(end)];
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Data/phi2/'],[length(EBSD_phi2) 1]);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Data/phi2/'],EBSD_phi2);


EBSD_Z_SAMPLE=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Data/Z SAMPLE']);
EBSD_Z_SAMPLE=[EBSD_Z_SAMPLE;EBSD_Z_SAMPLE(end)];
h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Data/Z SAMPLE/'],[length(EBSD_Z_SAMPLE) 1]);
h5write(OutputUser.hdf5file,['/' rootname '/EBSD/Data/Z SAMPLE/'],EBSD_Z_SAMPLE);





%Writing patterns
disp('Adding Patterns')
t=h5info(InputUser.hdf5file,['/' rootname '/EBSD/Data/RawPatterns']);
t=t.Datatype.Type;
if contains(t,'16')
    h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Data/RawPatterns/'],double([EBSD_PatternWidth EBSD_PatternHeight EBSD_NPoints]),'Datatype','uint16');
elseif contains(t,'8')
    h5create(OutputUser.hdf5file,['/' rootname '/EBSD/Data/RawPatterns/'],double([EBSD_PatternWidth EBSD_PatternHeight EBSD_NPoints]),'Datatype','uint8');
end





ndatatot=double(EBSD_NPoints);
width_pat=double(EBSD_PatternWidth);
height_pat=double(EBSD_PatternHeight);
h=waitbar(0,'Adding raw EBSPs and PCs to file ...');

for i = 1:100:ndatatot-100
    pat=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Data/RawPatterns'],[1 1 i],[width_pat height_pat 100]);
    h5write(OutputUser.hdf5file, ['/' rootname '/EBSD/Data/RawPatterns'],pat,[1 1 i],[width_pat height_pat 100]);
    waitbar(i/ndatatot,h,sprintf('Adding raw EBSPs to file ... %3.2f %%',(i*100/ndatatot)));

end
close(h)
disp('Adding last of the patterns')
i=i+100;
pat=h5read(InputUser.hdf5file,['/' rootname '/EBSD/Data/RawPatterns'],[1 1 i],[width_pat height_pat ndatatot-i]);
pat=cat(3,pat,pat(:,:,end));
h5write(OutputUser.hdf5file, ['/' rootname '/EBSD/Data/RawPatterns'],pat,[1 1 i],[width_pat height_pat size(pat,3)]);


warning('on','all')
