FROM aiidalab/aiidalab-docker-stack:21.12.0

USER root
RUN apt-get update && apt install -y \
    python3-dev                      \
    libglew-dev                      \
    libpng-dev                       \
    libfreetype6-dev                 \
    libxml2-dev                      \
    libmsgpack-dev                   \
    python3-pyqt5.qtopengl           \
    libglm-dev                       \
    libnetcdf-dev                    \
    && rm -rf /var/lib/apt/lists/*


RUN git clone https://github.com/schrodinger/pymol-open-source.git && cd pymol-open-source && git checkout v2.4.0 && python setup.py install

CMD ["/sbin/my_my_init"]
