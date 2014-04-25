#Script to process ASL data from the scanner to complete 1st level model
#Created by Andrew O'Shea on 2/17/14 at the University of Florida, Center for Pain Research and Behavioral Health
#
#
#*********Logical processing steps*********
#
# 1)copy files from server to local location (DCM2NII does not like the server)
# 2)Unzip DICOM files
# 3)convert DICOM files to one 4d nifti file per scan
# 4)arrange files in logical order locally
# 5)copy t1 .nii structural file locally 
# 6)Call ASLTBX in matlab
#
# ******Dependencies*******
#matlab needs to be set in BASH path; spm8 and ASLTBX need to be set in matlab path (script does this for you with path command)
#
#Body of script below:



echo 'Type the 4 digit subject ID code, followed by [ENTER] : '
read subjID #store subject ID variable
mkdir /Users/aoshea/Desktop/testASL$subjID
echo 'Copying data locally...This may take a while. Be patient'
cd /Volumes/painimaging/Staud/Fatigue_ASL/ASL$subjID/rawData/
cp -r ./*.zip /Users/aoshea/Desktop/testASL$subjID #copy zipped file locally
cd /Users/aoshea/Desktop/testASL$subjID
cp -r /Users/aoshea/Desktop/ASL2645/asl_perf_subtract.m ./ #copy matlab scripts needed locally
cp -r /Users/aoshea/Desktop/ASL2645/asl_process_subj.m ./ #copy matlab scripts needed locally
mkdir ./unzip
echo 'Now unzipping the Dicom files...please wait'
unzip *.zip -d ./unzip
echo 'Unzipping complete'
# run DCM2NII 
/Users/aoshea/Downloads/osx/dcm2nii -n y -f y -g n  /Users/aoshea/Desktop/testASL$subjID/unzip/*dicom/pCASL1_rs1_6min/.
/Users/aoshea/Downloads/osx/dcm2nii -n y -f y -g n  /Users/aoshea/Desktop/testASL$subjID/unzip/*dicom/pCASL2_PASAT1_18min/.
# end DCM2NII
cp */*/pCASL1*/*.nii /Users/aoshea/Desktop/testASL$subjID
cp */*/pCASL2*/*.nii /Users/aoshea/Desktop/testASL$subjID
cp -r /Volumes/painimaging/Staud/Fatigue_ASL/ASL$subjID/rawData/FRS${subjID}_T1W_3D_MPRAGE_SENSE_*_1.nii /Users/aoshea/Desktop/testASL$subjID/.
mv *PASAT*.nii PASAT18min.nii #rename to easier name
mv *rs6min*.nii RS6min.nii #rename to easier name
mv *_T1W_*.nii T1.nii #rename to easier name

# Perform File Checks
cd /Users/aoshea/Desktop/testASL$subjID/.
structScan='T1.nii'
RSscan='RS6min.nii'
pasatScan='PASAT18min.nii'
if [ -e $structScan ]
   then
echo 'Checking for structural scan... : File Exists'
   else
echo 'Checking for structural scan... : WARNING!!! FILE DOES NOT EXIST'
fi 

if [ -e $RSscan ]
   then
echo 'Checking for 6 minute resting state scan... : File Exists'
   else
echo 'Checking for 6 minute resting state scan... : WARNING!!! FILE DOES NOT EXIST'
fi 

if [ -e $pasatScan ]
   then
echo 'Checking for 18 minute PASAT scan... : File Exists'
   else
echo 'Checking for 18 minute PASAT scan... : WARNING!!! FILE DOES NOT EXIST'
fi 
# End File Checks
echo '

******Done!*****

'


# the end
