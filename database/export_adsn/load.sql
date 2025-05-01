COPY ducks FROM 'export_adsn/ducks.csv' (FORMAT 'csv', quote '"', delimiter ',', header 1);
COPY Personnel FROM 'export_adsn/personnel.csv' (FORMAT 'csv', force_not_null ('Name', 'Abbreviation'), quote '"', delimiter ',', header 1);
COPY Site FROM 'export_adsn/site.csv' (FORMAT 'csv', force_not_null ('Site_name', 'Location', 'Latitude', 'Longitude', 'Area', 'Code'), quote '"', delimiter ',', header 1);
COPY Species FROM 'export_adsn/species.csv' (FORMAT 'csv', force_not_null ('Common_name', 'Code'), quote '"', delimiter ',', header 1);
COPY Bird_nests FROM 'export_adsn/bird_nests.csv' (FORMAT 'csv', force_not_null ('Year', 'Site', 'Species', 'Date_found', 'Nest_ID'), quote '"', delimiter ',', header 1);
COPY Camp_assignment FROM 'export_adsn/camp_assignment.csv' (FORMAT 'csv', force_not_null ('Year', 'Site', 'Observer'), quote '"', delimiter ',', header 1);
COPY Snow_cover FROM 'export_adsn/snow_cover.csv' (FORMAT 'csv', force_not_null ('Site', 'Year', 'Date', 'Plot', 'Location'), quote '"', delimiter ',', header 1);
COPY Bird_eggs FROM 'export_adsn/bird_eggs.csv' (FORMAT 'csv', force_not_null ('Year', 'Site', 'Nest_ID', 'Egg_num', 'Length', 'Width'), quote '"', delimiter ',', header 1);
