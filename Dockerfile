FROM finalduty/archlinux

MAINTAINER 1m38

RUN pacman -Syyu --noconfirm && \
    pacman -S --noconfirm \
      python python-pip git \
      mathjax pandoc && \
    pip install jupyter numpy chainer pandas matplotlib && \
    pacman -Scc --noconfirm

# add user
RUN useradd -g users -m -s /bin/bash jupyter && echo "jupyter:jupyter" | chpasswd
USER jupyter

# workdir
RUN mkdir -p /home/jupyter/notebooks

USER root
COPY start_jupyter.sh /usr/local/bin

# run jupyter
USER jupyter
WORKDIR /home/jupyter/notebooks
CMD start_jupyter.sh
EXPOSE 8888
