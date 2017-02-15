FROM finalduty/archlinux

MAINTAINER 1m38

RUN pacman -Syyu --noconfirm && \
    pacman -S --noconfirm \
      python python-pip git \
      mathjax pandoc && \
    pip install jupyter numpy chainer pandas matplotlib && \
    pacman -Scc --noconfirm

# run jupyter
RUN mkdir -p /root/jupyter/notebooks
WORKDIR /root/jupyter/notebooks
COPY start_jupyter.sh /usr/local/bin
CMD start_jupyter.sh
EXPOSE 8888
