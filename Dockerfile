FROM finalduty/archlinux

MAINTAINER 1m38

RUN pacman -Syyu --noconfirm && \
    pacman -S --noconfirm \
      python python-pip git \
      mathjax pandoc \
      haskell-stack make zeromq pkg-config r \
      python2 nodejs npm && \
    pip install jupyter numpy chainer pandas matplotlib && \
    pacman -Scc --noconfirm

# setup iRkernel
RUN R -q -e "install.packages(c('repr', 'IRdisplay', 'crayon', 'pbdZMQ', 'devtools'), repos='http://cran.rstudio.com'); devtools::install_github('IRkernel/IRkernel')"

# install ijavascript
RUN npm install -g ijavascript && ijs --ijs-install=global

# add user
RUN useradd -g users -m -s /bin/bash jupyter && echo "jupyter:jupyter" | chpasswd
USER jupyter

# install ihaskell
RUN cd ~ && \
    git clone https://github.com/gibiansky/IHaskell.git ~/IHaskell && \
    cd ~/IHaskell && \
    stack setup && stack build && stack install && \
    ~/.local/bin/ihaskell install

# install iRkernel
RUN R -q -e "IRkernel::installspec()"

# workdir
RUN mkdir -p /home/jupyter/notebooks

COPY start_jupyter.sh /home/jupyter

# run jupyter
WORKDIR /home/jupyter/notebooks
CMD /home/jupyter/start_jupyter.sh
EXPOSE 8888
