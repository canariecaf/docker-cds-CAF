FROM canariecaf/docker-cds-core
MAINTAINER Chris Phillips <chris.phillips@canarie.ca>

USER root
ENV HOME /root

### 
### important build arguements
###

# where our environment settings in the container will be stored
ENV CDS_BUILD_ENV=/var/www/env


ARG CDSAGGREGATE=https://caf-shib2ops.ca/CoreServices/caf_metadata_signed_sha256.xml
ARG CDS_HTMLROOTDIR=/var/www/html
ARG CDS_HTMLWAYFDIR=/var/www/html/DS
ARG CDS_WAYFDESTFILENAME=CAF.ds
ARG CDS_REFRESHFREQINMIN=6

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# this is a hack for the variable being mysteriously blank
# The variable is NOT used properly and I want to be consistent with variable names
# it needs to be assigned for docker compose to work, but results in a 'blank'
# value when used. Very strange!

ARG CDS_OVERLAYURL=https://github.com/canariecaf/cds-overlay-CAF/archive/master.zip
ARG CDSOVERLAYURL=https://github.com/canariecaf/cds-overlay-CAF/archive/master.zip
#      ^ -- note the absent of the underscore where we assign the ENV variable below with


### important environment variables for runtime
###

ENV CDS_AGGREGATE=$CDSAGGREGATE
ENV CDS_REFRESHFREQINMIN=$CDS_REFRESHFREQINMIN
ENV CDS_OVERLAYURL=$CDSOVERLAYURL
#					   ^-- where we use the 

#
# prepare the overlay by dropping in the element and executing the overlay

# The container we run from already has this file populated so we should replace it with our
# customizations.

RUN echo "CDS_AGGREGATE=${CDS_AGGREGATE}" > ${CDS_BUILD_ENV}
#										  ^^-- note this is singular to erase the previous file
#											  ||-- the rest are concatenations to the end of the file
RUN echo "CDS_HTMLROOTDIR=${CDS_HTMLROOTDIR}" >> ${CDS_BUILD_ENV}
RUN echo "CDS_HTMLWAYFDIR=${CDS_HTMLWAYFDIR}" >> ${CDS_BUILD_ENV}
RUN echo "CDS_WAYFDESTFILENAME=${CDS_WAYFDESTFILENAME}" >> ${CDS_BUILD_ENV}
RUN echo "CDS_REFRESHFREQINMIN=${CDS_REFRESHFREQINMIN}" >> ${CDS_BUILD_ENV}
RUN echo "CDS_OVERLAYURL=${CDS_OVERLAYURL}" >> ${CDS_BUILD_ENV}

# persist some of our settings in a specific file for each
RUN echo "${CDSAGGREGATE}" > /var/www/aggregate2fetch
RUN echo "${CDSOVERLAYURL}" > /var/www/defaultoverlayurl

    
EXPOSE 80
EXPOSE 443

RUN (cd /var/www; /var/www/overlay.sh ${CDS_OVERLAYURL} )



CMD ["/bin/bash", "/root/start.sh", "${CDSAGGREGATE}"]



