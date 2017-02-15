FROM finalduty/archlinux

MAINTAINER 1m38

RUN pacman -Syyu --noconfirm && \
    pacman -S --noconfirm \
      python python-pip git \
      mathjax pandoc \
      haskell-stack make zeromq pkg-config && \
    pip install jupyter numpy chainer pandas matplotlib && \
    pacman -Scc --noconfirm

# add user
RUN useradd -g users -m -s /bin/bash jupyter && echo "jupyter:jupyter" | chpasswd
USER jupyter

# install ihaskell
RUN cd ~ && \
    git clone https://github.com/gibiansky/IHaskell.git ~/IHaskell && \
    cd ~/IHaskell && \
    stack setup && stack build && stack install && \
    ~/.local/bin/ihaskell install

# workdir
RUN mkdir -p /home/jupyter/notebooks

USER root
COPY start_jupyter.sh /usr/local/bin

# run jupyter
USER jupyter
WORKDIR /home/jupyter/notebooks
CMD start_jupyter.sh
EXPOSE 8888
