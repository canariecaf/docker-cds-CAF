## A Central Discovery Service 

A [Docker](http://docker.com) image for the CAF Central Discovery Service.
Based on: [docker-cds-core](https://hub.docker.com/r/canariecaf/docker-cds-core/), the dockerized version of the  [v1.20.2 SWITCHwayf](https://forge.switch.ch/projects/wayf) built on Ubuntu 14.04.

## To Build the image

### The variables & their defaults for this image


Environment variables with their defaults if they do not exist are:
- CDS_AGGREGATE - the aggregate to point at and ingest via the cron command
	-- defaults to: https://caf-shib2ops.ca/CoreServices/caf_metadata_signed_sha256.xml
- CDS_HTMLROOTDIR - the HTML root directory of the webserver
	-- defaults to: /var/www/html
- CDS_HTMLWAYFDIR - the location in the container where the DS lives
	-- default to: /var/www/html/DS
- CDS_WAYFDESTFILENAME - the actual WAYF file to invoke
	-- defaults to: CAF.ds
- CDS_OVERLAYURL: https://github.com/canariecaf/cds-overlay-CAF/archive/master.zip	

Note that the OVERLAY is at the time of building the image where as runtime changes the values below:

## Runtime overrides of this image
- CDS_AGGREGATE - the aggregate to point at and ingest via the cron command
	-- defaults to: https://caf-shib2ops.ca/CoreServices/caf_metadata_signed_sha256.xml
- CDS_REFRESHFREQINMIN - # of minutes between cron'd processing of the aggregate after intial fetch on start
	-- defaults to: 5 

pass them in on the command line:

```sh
$ sudo docker run -e CDS_AGGREGATE=http://md.example.com/somethings.xml -e CDS_REFRESHFREQINMIN=5 -d -p 80:80 --restart=always canariecaf/docker-cds-core
```

## How to do a basic test?

Open browser and point to: **http://localhost**
If everthing is fine you should see the default Service Discovery Page with your aggregate