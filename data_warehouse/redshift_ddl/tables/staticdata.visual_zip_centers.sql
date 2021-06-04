CREATE TABLE IF NOT EXISTS staticdata.visual_zip_centers
(
	op VARCHAR(36)   ENCODE zstd
	,"timestamp" VARCHAR(36)   ENCODE zstd
	,colval INTEGER   ENCODE zstd
	,name VARCHAR(300)   ENCODE zstd
	,zip VARCHAR(300)   ENCODE zstd
	,zip_name VARCHAR(300)   ENCODE zstd
	,ziptype VARCHAR(300)   ENCODE zstd
	,state VARCHAR(300)   ENCODE zstd
	,statefips VARCHAR(300)   ENCODE zstd
	,countyfips VARCHAR(300)   ENCODE zstd
	,countyname VARCHAR(300)   ENCODE zstd
	,s3dzip VARCHAR(300)   ENCODE zstd
	,lat VARCHAR(300)   ENCODE zstd
	,lon VARCHAR(300)   ENCODE zstd
	,emptycol VARCHAR(30)   ENCODE zstd
	,totrescnt VARCHAR(300)   ENCODE zstd
	,mfdu VARCHAR(30)   ENCODE zstd
	,sfdu VARCHAR(300)   ENCODE zstd
	,boxcnt VARCHAR(300)   ENCODE zstd
	,bizcnt VARCHAR(300)   ENCODE zstd
	,relver VARCHAR(300)   ENCODE zstd
	,color VARCHAR(300)   ENCODE zstd
	,geographypoint VARCHAR(10000)   ENCODE zstd
)
<<Error - UNKNOWN DISTSTYLE>>
;

GRANT ALL on staticdata.visual_zip_centers to group dev_redshiftcoredevgroup;
GRANT ALL on staticdata.visual_zip_centers to group dev_redshiftcoreadmingroup;
GRANT SELECT on staticdata.visual_zip_centers to group dev_redshiftcorereadngroup;
GRANT SELECT on staticdata.visual_zip_centers to group dev_redshiftcorereadgroup;


