FROM debian:bullseye
LABEL maintainer="marstonstudio"

WORKDIR /src/git

# Update system
RUN apt-get update && \
    apt-get -y install libunarr-dev qt5-image-formats-plugins p7zip-full git dumb-init qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libpoppler-qt5-dev libpoppler-qt5-1 wget unzip libqt5sql5-sqlite libqt5sql5 sqlite3 libqt5network5 libqt5gui5 libqt5core5a build-essential
RUN git clone https://github.com/YACReader/yacreader.git . && \
    git checkout 9.12.0
RUN cd /src/git/YACReaderLibraryServer && \
    qmake "CONFIG+=server_standalone unarr" YACReaderLibraryServer.pro && \
    make  && \
    make install
RUN cd /     && \
    apt-get purge -y git wget build-essential && \
    apt-get -y autoremove &&\
    rm -rf /src && \
    rm -rf /var/cache/apt
ADD YACReaderLibrary.ini /root/.local/share/YACReader/YACReaderLibrary/

# add specific volumes: configuration, comics repository, and hidden library data to separate them
VOLUME ["/comics"]

EXPOSE 8080

ENV LC_ALL=C.UTF8

ENTRYPOINT ["YACReaderLibraryServer","start"]
