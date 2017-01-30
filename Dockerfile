FROM finalduty/archlinux
# FROM archlinuxjp/archlinux

MAINTAINER 1m38

RUN pacman -Syu --noconfirm && pacman -S --needed base-devel --noconfirm

RUN pacman -S --noconfirm \
      python python-pip jupyter-notebook git \
      mathjax pandoc \
      haskell-stack r && \
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

# run jupyter
RUN mkdir /home/jupyter/notebooks
CMD ["jupyter", "notebook", "--ip=*", "--port=8888", "--notebook-dir=/home/jupyter/notebooks"]
EXPOSE 8888
