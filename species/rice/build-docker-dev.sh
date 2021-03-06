#!/bin/bash

#image name
IMAGE_NAME="knetminer-rice-dev"

# current $SPECIES_DIR.
SPECIES_DIR=`pwd | rev | cut -d '/' -f1 | rev`

#copy .dockerignore-template and .gitignore settings.
cd ../..
cp .dockerignore-template .dockerignore
cat .gitignore >> .dockerignore

# add all species/ sub-folders to .dockerignore except KnetMiner/pom.xml, common/ and species/$SPECIES_DIR.
cd species/
ls -1 | grep -v $SPECIES_DIR | sed 's/^/species\//' | grep -v pom.xml | grep -v common >> .dockerignore
cd ..

#pass docker image build parameters
docker image build \
    	--build-arg tax_id=39947  \
    	--build-arg species_name="Oryza sativa Japonica" \
    	--build-arg species_link_name=rice \
    	--build-arg keywords="rice, o.sativa, knetminer, quickstart, demo" \
    	--build-arg description="Rice Knetminer" \
    	--build-arg reference_genome=true \
  --build-arg species_dir="species/$SPECIES_DIR" \
  --build-arg oxl_file="RiceKNET.oxl" \
  --build-arg knetminer_port=8081 \
  --squash -t $IMAGE_NAME \
  -f common/quickstart/Dockerfile-dev .

#when done, remove .dockerignore and notify with instructions.
if [ $? -eq 0 ]; then
	rm .dockerignore
	cd species/$SPECIES_DIR
	echo "You can run this Docker using: docker run -p8080:8080 -it --rm $IMAGE_NAME"
	echo "Then access it at http://localhost:8080/client/"
	echo "Note: port 8080 is the Tomcat default; replace with the knetminer_port defined in this file"
fi
