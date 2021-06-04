CREATE TABLE IF NOT EXISTS staticdata.fips_county_to_cbsa_map_2017
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,cbsa_code VARCHAR(15)   ENCODE zstd
	,cbsa_title VARCHAR(1500)   ENCODE zstd
	,"metropolitan/micropolitan statistical area" VARCHAR(150)   ENCODE zstd
	,fips_state_county VARCHAR(15)   ENCODE zstd
)
<<Error - UNKNOWN DISTSTYLE>>
;

GRANT ALL on staticdata.fips_county_to_cbsa_map_2017 to group dev_redshiftcoredevgroup;
GRANT ALL on staticdata.fips_county_to_cbsa_map_2017 to group dev_redshiftcoreadmingroup;
GRANT SELECT on staticdata.fips_county_to_cbsa_map_2017 to group dev_redshiftcorereadngroup;
GRANT SELECT on staticdata.fips_county_to_cbsa_map_2017 to group dev_redshiftcorereadgroup;


