FROM canariecaf/docker-cds-core
MAINTAINER Chris Phillips <chris.phillips@canarie.ca>

USER root
ENV HOME /root

### 
### important build arguements
###

###
### Configure our 'base'
###
ARG CDS_BASE=/root/cds
ARG CDS_BASE_TEMPLATE=${CDS_BASE}/template

# where we leave our settings inside the container for everything else to inherit and use

ENV CDS_BUILD_ENV=/root/env


ARG CDSAGGREGATE=https://caf-shib2ops.ca/CoreServices/caf_metadata_signed_sha256.xml
ARG CDS_HTMLWAYFDIR=DS
ARG CDS_WAYFDESTFILENAME=CAF.ds
ARG CDS_REFRESHFREQINMIN=6
ARG CDS_TRIGGER_IMPRINT=""
ARG CDS_HTMLROOTDIR=${CDS_BASE}/html

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
ENV CDS_WAYFDESTFILENAME=$CDS_WAYFDESTFILENAME
ENV CDS_HTMLWAYFDIR=$CDS_HTMLWAYFDIR
ENV CDS_TRIGGER_IMPRINT=$CDS_TRIGGER_IMPRINT

#
# prepare the overlay by dropping in the element and executing the overlay

# The container we run from already has this file populated so we should replace it with our
# customizations.

RUN (NOW=`date`;echo "#${NOW} " >> ${CDS_BUILD_ENV})
RUN echo "CDS_AGGREGATE=${CDS_AGGREGATE}" >> ${CDS_BUILD_ENV}
RUN echo "CDS_HTMLWAYFDIR=${CDS_HTMLWAYFDIR}" >> ${CDS_BUILD_ENV}
RUN echo "CDS_OVERLAYURL=${CDS_OVERLAYURL}" >> ${CDS_BUILD_ENV}
RUN echo "CDS_REFRESHFREQINMIN=${CDS_REFRESHFREQINMIN}" >> ${CDS_BUILD_ENV}
RUN echo "CDS_WAYFDESTFILENAME=${CDS_WAYFDESTFILENAME}" >> ${CDS_BUILD_ENV}
RUN chmod 755 /root/env
RUN chmod 755 /root

#RUN echo "CDS_BASE=${CDS_BASE}" >> ${CDS_BUILD_ENV}
#RUN echo "CDS_BASE_TEMPLATE=${CDS_BASE_TEMPLATE}" >> ${CDS_BUILD_ENV}
#RUN echo "CDS_CODEBASE=${CDS_CODEBASE}" >> ${CDS_BUILD_ENV}
#RUN echo "CDS_HTMLROOTDIR=${CDS_HTMLROOTDIR}" >> ${CDS_BUILD_ENV}

#RUN echo "CDS_WAYFORIGINFILENAME=${CDS_WAYFORIGINFILENAME}" >> ${CDS_BUILD_ENV}


    
EXPOSE 80
EXPOSE 443

RUN (cd ${CDS_BASE}; ${CDS_BASE}/overlay.sh ${CDS_OVERLAYURL} )

CMD ["/bin/bash", "/root/start.sh", "${CDSAGGREGATE}"]



