FROM ubuntu:18.04

ENV HOME /home/radu

RUN apt-get update
RUN apt-get install -y zsh
RUN apt-get install -y wget
RUN apt-get install -y git
RUN apt-get install -y build-essential

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN wget -qO- https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer | bash
RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash

RUN apt-get install -y bison
RUN apt-get install -y  curl

ENV PATH="~/.nvm:${PATH}"
RUN /bin/zsh -c "source ~/.zshrc && nvm install --lts"

WORKDIR /home/radu/tmp
RUN curl -O https://storage.googleapis.com/golang/go1.12.12.linux-amd64.tar.gz
RUN tar -xvf go1.12.12.linux-amd64.tar.gz  && chown -R root:root ./go && mv go /usr/local

ENV GOPATH="/home/radu/projects"
ENV PATH="/usr/local/go/bin/:/home/radu/projects/bin/:${PATH}"

ENV RUSTUP_HOME="/home/radu/.rustup"
ENV CARGO_HOME="/home/radu/.cargo"
ENV PATH="/home/radu/.rustup:/home/radu/.cargo:/home/radu/.cargo/bin:$PATH"

RUN /bin/zsh -c "curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain nightly"
RUN /bin/zsh -c "source ~/.zshrc &&  rustup default nightly"

RUN apt-get install -y nano && apt-get install -y vim
RUN go get -u github.com/justjanne/powerline-go

COPY powerline.sh .
RUN /bin/zsh -c "cat powerline.sh >> ~/.zshrc"

RUN apt-get install -y unzip
RUN /bin/zsh -c "wget https://github.com/ogham/exa/releases/download/v0.9.0/exa-linux-x86_64-0.9.0.zip && unzip exa-linux-x86_64-0.9.0.zip && mv exa-linux-x86_64 $GOPATH/bin/exa"

RUN /bin/bash -c "wget https://github.com/sharkdp/bat/releases/download/v0.12.1/bat-v0.12.1-x86_64-unknown-linux-musl.tar.gz && tar xfv bat-v0.12.1-x86_64-unknown-linux-musl.tar.gz && mv bat-v0.12.1-x86_64-unknown-linux-musl/bat $GOPATH/bin"

RUN apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

RUN apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io
RUN wget https://github.com/kubernetes-sigs/kind/releases/download/v0.5.1/kind-linux-amd64 && chmod +x kind-linux-amd64 && mv kind-linux-amd64 $GOPATH/bin/kind

RUN apt-get install -y chromium-browser
RUN apt-get -y install sudo

RUN useradd -ms /bin/zsh radu
RUN usermod -aG sudo radu
RUN sudo chown -R radu /home

ARG pwd
RUN echo radu:${pwd} | chpasswd
RUN sudo usermod -aG docker radu
USER radu

RUN /bin/zsh -c "mkdir -p ~/.zsh && cd ~/.zsh && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git && git clone https://github.com/zsh-users/zsh-autosuggestions"
COPY zshrc.sh .
RUN /bin/zsh -c "cat zshrc.sh >> ~/.zshrc"

CMD ["zsh"]
