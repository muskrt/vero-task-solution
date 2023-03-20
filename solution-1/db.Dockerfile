FROM  mcr.microsoft.com/mssql/server:latest

USER root
ENV ID sa  
ENV ACCEPT_EULA Y 
ENV MSSQL_SA_PASSWORD 'Un!q@to2023' 
ENV MSSQL_PID Express
 
COPY setup.sql setup.sql
COPY import.sh import.sh
COPY entrypoint.sh entrypoint.sh

RUN chmod +x entrypoint.sh
RUN chmod +x import.sh

CMD /bin/bash ./entrypoint.sh
