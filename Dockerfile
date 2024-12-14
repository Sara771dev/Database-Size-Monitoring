ARG IMAGE=intersystemsdc/irishealth-community
FROM $IMAGE as builder

WORKDIR /home/irisowner/dev

COPY --chown=${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} . ./
COPY --chown=${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} ./user /usr/irissys/csp/user

USER root
ENV IRISUSERNAME "_SYSTEM"
ENV IRISPASSWORD "IRIS"

USER ${ISC_PACKAGE_MGRUSER}
RUN iris start IRIS  \
    && iris session IRIS < iris.script \
    && iris stop IRIS quietly



