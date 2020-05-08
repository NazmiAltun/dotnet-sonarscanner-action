FROM mcr.microsoft.com/dotnet/core/sdk:latest
LABEL "maintainer"="Nazmi Altun <nazmialtun@windowslive.com>"

RUN echo "deb http://http.us.debian.org/debian/ testing contrib main" >> /etc/apt/sources.list && \
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg && \
    mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ && \
    wget -q https://packages.microsoft.com/config/debian/10/prod.list && \
    mv prod.list /etc/apt/sources.list.d/microsoft-prod.list && \
    chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg && \
    chown root:root /etc/apt/sources.list.d/microsoft-prod.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends default-jre apt-transport-https aspnetcore-runtime-2.1 mono-complete && \
    apt-get -t testing install -y --no-install-recommends python3.7 python3-distutils && \
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3.7 get-pip.py && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* && \
    apt-get autoremove -y && \
    dotnet tool install dotnet-sonarscanner --tool-path . --version 4.8.0

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]