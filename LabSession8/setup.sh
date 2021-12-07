# Setup Samba share container
cd smb-share
docker build -t lab8-smb .
docker run -it -p 445:445 -p 139:139 -d lab8-smb

# Build containter for running experiments
cd ../meas
docker build -t lab8 .

# Create regulare volume
docker volume create lab8-vol

# Create cifs share volume
docker volume create \
        --driver local \
        --opt type=cifs \
        --opt device=//localhost/sambashare \
        --opt o=addr=localhost,username=repro,password=repro,file_mode=0777,dir_mode=0777 \
        --name lab8-smb-vol

# Run measurement container with mounted volumes
docker run -it -v lab8-vol:/home/repro/vol \
	-v lab8-smb-vol:/home/repro/smb-vol lab8
