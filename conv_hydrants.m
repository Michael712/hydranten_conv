% ref, y, x
csvData = dlmread('../HYDRANTENLISTE.csv', ';', 1, 0);
addpath('utm2deg')

x = csvData(:,3);
y = csvData(:,2);
for i = 1:size(x, 1)
    zone(i,:) = '32 U';
end
ref = csvData(:,1);

[lat, lon] = utm2deg(x, y, zone);


docNode = com.mathworks.xml.XMLUtils.createDocument('osm');
osm = docNode.getDocumentElement;
osm.setAttribute('version','0.6');

bounds = docNode.createElement('bounds');
bounds.setAttribute('minlat', num2str(min(lat)));
bounds.setAttribute('minlon', num2str(min(lon)));
bounds.setAttribute('maxlat', num2str(max(lat)));
bounds.setAttribute('maxlon', num2str(max(lon)));
osm.appendChild(bounds);

for i = 1:size(x, 1)
    tmpNode = docNode.createElement('node');
    tmpNode.setAttribute('id', num2str(-i));
    tmpNode.setAttribute('lat', num2str(lat(i), 10));
    tmpNode.setAttribute('lon', num2str(lon(i), 9));
    tmpNode.setAttribute('visible', 'true');
    
    tmpTag = docNode.createElement('tag');
    tmpTag.setAttribute('k', 'emergency');
    tmpTag.setAttribute('v', 'fire_hydrant');
    tmpNode.appendChild(tmpTag);
    
    tmpTag = docNode.createElement('tag');
    tmpTag.setAttribute('k', 'fire_hydrant:type');
    tmpTag.setAttribute('v', 'underground');
    tmpNode.appendChild(tmpTag);
    
    tmpTag = docNode.createElement('tag');
    tmpTag.setAttribute('k', 'fire_hydrant:pressure');
    tmpTag.setAttribute('v', 'yes');
    tmpNode.appendChild(tmpTag);
    
    tmpTag = docNode.createElement('tag');
    tmpTag.setAttribute('k', 'ref');
    tmpTag.setAttribute('v', num2str(ref(i)));
    tmpNode.appendChild(tmpTag);
    
    osm.appendChild(tmpNode);
end

xmlwrite('hydranten.osm', docNode);
