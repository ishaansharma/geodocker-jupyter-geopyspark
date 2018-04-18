FROM quay.io/geodocker/jupyter-geopyspark:base-7

ARG VERSION
ARG GEOPYSPARKSHA

ENV PYSPARK_PYTHON=python3.4
ENV PYSPARK_DRIVER_PYTHON=python3.4

# Set up Jupyter
RUN mkdir /home/hadoop/notebooks && \
    pip3 install --user pytest && \
    jupyter nbextension enable --py widgetsnbextension
COPY kernels/local/kernel.json /home/hadoop/.local/share/jupyter/kernels/pyspark/kernel.json

# Install GeoPySpark
RUN pip3 install --user protobuf==3.1.0 "https://github.com/locationtech-labs/geopyspark/archive/$GEOPYSPARKSHA.zip"

# Install Jars
ADD https://s3.amazonaws.com/geopyspark-dependency-jars/geotrellis-backend-assembly-0.3.1.jar /opt/jars/

USER root
RUN chmod ugo+r /opt/jars/*
RUN chown -R hadoop:hadoop /home/hadoop/.local/share
USER hadoop

WORKDIR /tmp
CMD ["jupyterhub", "--no-ssl", "--Spawner.notebook_dir=/home/hadoop/notebooks"]
