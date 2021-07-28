% ref, y, x
utmData = dlmread('HYDRANTENLISTE.csv', ';', 1, 0);

x = utmData(:,3);
y = utmData(:,2);
for i = 1:size(x, 1)
    zone(i,:) = '32 U';
end
ref = utmData(:,1);

[lat, lon] = utm2deg(x, y, zone);


data.type = 'FeatureCollection';
for i = 1:size(x, 1)
    tmp.type = 'Feature';
    tmp.geometry.type = 'Point';
    tmp.geometry.coordinates = [lon(i), lat(i)];
    tmp.properties.name = num2str(ref(i));    
    
    data.features(i) = tmp;
end

txt = jsonencode(data);

fid = fopen('out.geojson','wt');
fprintf(fid, txt);
fclose(fid);
