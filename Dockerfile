FROM aiidalab/aiidalab-docker-stack:22.01.0

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


ENV AIIDALAB_DEFAULT_APPS "aiidalab-widgets-base~=1.4"



# Jupyter dependencies installed into system python environment
# which runs the jupyter notebook server.
COPY requirements-server.txt .
RUN /usr/local/bin/pip install -r /opt/requirements-server.txt \
    && /usr/local/bin/pip cache purge

# Install some useful packages that are not available on PyPi.
RUN conda install --yes -c conda-forge \
  openbabel==3.1.1 \
  rdkit==2022.03.1 \
  && conda clean --all

# Install AiiDAlab Python packages into user conda environment and populate reentry cache.
COPY requirements.txt .
ARG extra_requirements
RUN pip install --upgrade pip
RUN pip install -r requirements.txt $extra_requirements
RUN reentry scan

# Install the aiidalab-home app.
ARG aiidalab_home_version=v23.03.0
RUN rm -rf aiidalab-home && git clone https://github.com/aiidalab/aiidalab-home && cd aiidalab-home && git checkout $aiidalab_home_version
RUN chmod 774 aiidalab-home


CMD ["/sbin/my_my_init"]
