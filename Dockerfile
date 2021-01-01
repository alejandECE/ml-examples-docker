# Use the official tensorflow with gpu support image as a parent image.
FROM tensorflow/tensorflow:latest-gpu

# Argument to define the username and user id (this has to match with the host machine user running docker!)
ARG user=worker
ARG uid=1000

# Avoid interactions
ENV DEBIAN_FRONTEND=noninteractive

# Setting environmental variable pointing to working dir (user home)
ENV WORKDIR=/home/$user

# Installing and updating libraries
RUN apt-get update -y
RUN apt-get install python3 -y
RUN apt-get install python3-pip -y
RUN pip3 install --upgrade pip
RUN apt install graphviz -y
RUN apt-get install python3-tk -y

# Adding non root user
RUN useradd --home-dir ${WORKDIR} --create-home --uid $uid $user

# Changing active user to the newly created user
USER $user

# Setting working directory
WORKDIR ${WORKDIR}

# Installing dependencies for user
COPY --chown=$user requirements.txt ${WORKDIR}
RUN pip install --user -r requirements.txt
ENV PATH=${PATH}:${WORKDIR}/.local/bin/

# Jupyter and tensorboard ports
EXPOSE 8888 6006

# Creates a volume to read all weights from
VOLUME ${WORKDIR}/weights
ENV WEIGHTS=${WORKDIR}/weights

# Notebooks directory
VOLUME ${WORKDIR}/notebooks
ENV NOTEBOOKS=${WORKDIR}/notebooks

# Outputs directory
VOLUME ${WORKDIR}/outputs
ENV OUTPUTS=${WORKDIR}/outputs

# Datasets directory
VOLUME ${WORKDIR}/datasets
ENV DATASETS=${WORKDIR}/datasets

# Adds jupyter configuration files
COPY --chown=$user /jupyter ${WORKDIR}/.jupyter
COPY --chown=$user run_jupyter.sh ${WORKDIR}

# Runs jupyter notebook
CMD ${WORKDIR}/run_jupyter.sh 
