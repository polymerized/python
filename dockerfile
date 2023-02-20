# syntax=docker/dockerfile:1
ARG IMAGE=ubuntu
ARG TAG=22.04

# = = = = = = = = = = = = = = = = = = = = =

FROM $IMAGE:$TAG

# = = = = = = = = = = = = = = = = = = = = =

RUN apt-get update
RUN export DEBIAN_FRONTEND=noninteractive && apt-get -y install --no-install-recommends sudo git curl ca-certificates

# = = = = = = = = = = = = = = = = = = = = =

RUN export DEBIAN_FRONTEND=noninteractive && apt-get -y install --no-install-recommends python3-pip python3-dev python3-venv
RUN curl -fsSL https://deb.nodesource.com/setup_19.x | sudo -E bash - && export DEBIAN_FRONTEND=noninteractive && apt-get -y install --no-install-recommends nodejs

# = = = = = = = = = = = = = = = = = = = = =

RUN python3 -m pip install pynvim neovim
RUN curl -fLo nvim-linux64.tar.gz https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
RUN <<EOF
tar -xzf nvim-linux64.tar.gz
mv nvim-linux64/share/* /usr/local/share/
mv nvim-linux64/bin/* /usr/local/bin/
mv nvim-linux64/lib/* /usr/local/lib/
rm -rf nvim-linux64*
EOF

# = = = = = = = = = = = = = = = = = = = = =

ARG USER=user
ARG USERCOLOR=30m
ARG HOST=base
ARG HOSTCOLOR=37m

ENV USERCOLOR=$USERCOLOR
ENV HOST=$HOST
ENV HOSTCOLOR=$HOSTCOLOR

RUN useradd -rm -d /home/$USER -s /bin/bash -g root -G sudo -u 1001 $USER
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN touch /home/$USER/.sudo_as_admin_successful

COPY .bashrc /home/$USER/.bashrc

# = = = = = = = = = = = = = = = = = = = = =

USER $USER

# = = = = = = = = = = = = = = = = = = = = =

RUN mkdir /home/$USER/project
WORKDIR /home/$USER/project

# = = = = = = = = = = = = = = = = = = = = =

RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
COPY --chown=$USER init.lua /home/$USER/.config/nvim/init.lua
RUN nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
RUN nvim --headless +"CocInstall -sync coc-pyright coc-json coc-pairs|qa"

# = = = = = = = = = = = = = = = = = = = = =

COPY <<EOF /home/$USER/.bash_aliases
alias vi="nvim"
alias vim="nvim"
alias editor="nvim"

alias setup-venv="python3 -m venv .venv && source .venv/bin/activate && if test -f requirements.txt; then python3 -m pip install -r requirements.txt; fi"
EOF

# = = = = = = = = = = = = = = = = = = = = =

ENTRYPOINT ["/bin/bash"]