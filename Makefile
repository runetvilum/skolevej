#http://www.gnu.org/prep/standards/html_node/Standard-Targets.html#Standard-Targets
TOOL_ROOT?=$(shell pwd)/node_modules/osrm/lib/binding
PROFILES?=$(shell pwd)/node_modules/osrm/profiles
OSRM_EXTRACT:=$(TOOL_ROOT)/osrm-extract
OSRM_CONTRACT:=$(TOOL_ROOT)/osrm-contract
OSRM_PARTITION:=$(TOOL_ROOT)/osrm-partition
OSRM_CUSTOMIZE:=$(TOOL_ROOT)/osrm-customize
OGR2OSM:=./ogr2osm/

clean:
	rm -rf bicycle
	rm -rf car
	rm -rf foot
	rm -rf osm

osm: clean
	mkdir -p osm
	$(OGR2OSM)ogr2osm.py -f -t ./translations/translation_vej.py -o ./osm/Skolevej_0-3.osm ./data/Skolevej_1-3_20170502.geojson --id 100000
	$(OGR2OSM)ogr2osm.py -f -t ./translations/translation_vej.py -o ./osm/Skolevej_4-6.osm ./data/Skolevej_4-6_20170502.geojson --id 100000
	$(OGR2OSM)ogr2osm.py -f -t ./translations/translation_vej.py -o ./osm/Skolevej_7-10.osm ./data/Skolevej_7-10_20170502.geojson --id 100000
	$(OGR2OSM)ogr2osm.py -f -t ./translations/translation_vej.py -o ./osm/Vejmidte.osm ./data/Skolevej_alle_Cykel_20170502.geojson --id 100000
    
copy: osm
	mkdir -p bicycle
	mkdir -p foot
	mkdir -p car
	cp ./osm/Skolevej_0-3.osm bicycle/.
	cp ./osm/Skolevej_0-3.osm foot/.
	cp ./osm/Skolevej_0-3.osm car/.
	cp ./osm/Skolevej_4-6.osm bicycle/.
	cp ./osm/Skolevej_4-6.osm foot/.
	cp ./osm/Skolevej_4-6.osm car/.
	cp ./osm/Skolevej_7-10.osm bicycle/.
	cp ./osm/Skolevej_7-10.osm foot/.
	cp ./osm/Skolevej_7-10.osm car/.
	cp ./osm/Vejmidte.osm bicycle/.
	cp ./osm/Vejmidte.osm foot/.
	cp ./osm/Vejmidte.osm car/.
    
extract: copy
	@echo "Running osrm-extract..."
	$(OSRM_EXTRACT) bicycle/Skolevej_0-3.osm -p $(PROFILES)/bicycle.lua
	$(OSRM_EXTRACT) bicycle/Skolevej_4-6.osm -p $(PROFILES)/bicycle.lua    
	$(OSRM_EXTRACT) bicycle/Skolevej_7-10.osm -p $(PROFILES)/bicycle.lua
	$(OSRM_EXTRACT) bicycle/Vejmidte.osm -p $(PROFILES)/bicycle.lua
	$(OSRM_EXTRACT) car/Skolevej_0-3.osm -p $(PROFILES)/car.lua
	$(OSRM_EXTRACT) car/Skolevej_4-6.osm -p $(PROFILES)/car.lua    
	$(OSRM_EXTRACT) car/Skolevej_7-10.osm -p $(PROFILES)/car.lua
	$(OSRM_EXTRACT) car/Vejmidte.osm -p $(PROFILES)/car.lua
	$(OSRM_EXTRACT) foot/Skolevej_0-3.osm -p $(PROFILES)/foot.lua
	$(OSRM_EXTRACT) foot/Skolevej_4-6.osm -p $(PROFILES)/foot.lua    
	$(OSRM_EXTRACT) foot/Skolevej_7-10.osm -p $(PROFILES)/foot.lua
	$(OSRM_EXTRACT) foot/Vejmidte.osm -p $(PROFILES)/foot.lua
    
partition: extract
	@echo "Running osrm-partition..."
	$(OSRM_PARTITION) bicycle/Skolevej_0-3.osrm
	$(OSRM_PARTITION) bicycle/Skolevej_4-6.osrm
	$(OSRM_PARTITION) bicycle/Skolevej_7-10.osrm
	$(OSRM_PARTITION) bicycle/Vejmidte.osrm
	$(OSRM_PARTITION) car/Skolevej_0-3.osrm
	$(OSRM_PARTITION) car/Skolevej_4-6.osrm
	$(OSRM_PARTITION) car/Skolevej_7-10.osrm
	$(OSRM_PARTITION) car/Vejmidte.osrm
	$(OSRM_PARTITION) foot/Skolevej_0-3.osrm
	$(OSRM_PARTITION) foot/Skolevej_4-6.osrm
	$(OSRM_PARTITION) foot/Skolevej_7-10.osrm
	$(OSRM_PARTITION) foot/Vejmidte.osrm
	
customize: partition
	@echo "Running osrm-customize..."
	$(OSRM_CUSTOMIZE) bicycle/Skolevej_0-3.osrm
	$(OSRM_CUSTOMIZE) bicycle/Skolevej_4-6.osrm
	$(OSRM_CUSTOMIZE) bicycle/Skolevej_7-10.osrm
	$(OSRM_CUSTOMIZE) bicycle/Vejmidte.osrm
	$(OSRM_CUSTOMIZE) car/Skolevej_0-3.osrm
	$(OSRM_CUSTOMIZE) car/Skolevej_4-6.osrm
	$(OSRM_CUSTOMIZE) car/Skolevej_7-10.osrm
	$(OSRM_CUSTOMIZE) car/Vejmidte.osrm
	$(OSRM_CUSTOMIZE) foot/Skolevej_0-3.osrm
	$(OSRM_CUSTOMIZE) foot/Skolevej_4-6.osrm
	$(OSRM_CUSTOMIZE) foot/Skolevej_7-10.osrm
	$(OSRM_CUSTOMIZE) foot/Vejmidte.osrm
	
contract: extract
	@echo "Running osrm-contract..."
	$(OSRM_CONTRACT) bicycle/Skolevej_0-3.osrm
	$(OSRM_CONTRACT) bicycle/Skolevej_4-6.osrm
	$(OSRM_CONTRACT) bicycle/Skolevej_7-10.osrm
	$(OSRM_CONTRACT) bicycle/Vejmidte.osrm
	$(OSRM_CONTRACT) car/Skolevej_0-3.osrm
	$(OSRM_CONTRACT) car/Skolevej_4-6.osrm
	$(OSRM_CONTRACT) car/Skolevej_7-10.osrm
	$(OSRM_CONTRACT) car/Vejmidte.osrm
	$(OSRM_CONTRACT) foot/Skolevej_0-3.osrm
	$(OSRM_CONTRACT) foot/Skolevej_4-6.osrm
	$(OSRM_CONTRACT) foot/Skolevej_7-10.osrm
	$(OSRM_CONTRACT) foot/Vejmidte.osrm

test: 
#	$(OGR2OSM)ogr2osm.py -f -t translation_0-3.py -o Skolevej_0-3.osm Vejmidte.geojson
	cp Skolevej_0-3.osm bicycle/.
	$(OSRM_EXTRACT) bicycle/Skolevej_0-3.osm -p $(PROFILES)/bicycle.lua
	$(OSRM_CONTRACT) bicycle/Skolevej_0-3.osrm

prepare:
	$(OSRM_PARTITION) bicycle/Skolevej_0-3.osrm
	$(OSRM_CUSTOMIZE) bicycle/Skolevej_0-3.osrm

denmark:
	$(OSRM_EXTRACT) data/denmark-latest.osm.pbf --threads 1 -p $(PROFILES)/car.lua
#	$(OSRM_PARTITION) data/denmark-latest.osrm
#	$(OSRM_CUSTOMIZE) data/denmark-latest.osrm