FROM ubuntu:trusty

RUN \
  echo "****** This is my working directory ******" && \
  pwd && \
  echo && \
  echo "++++++ Here's what's in my root directory ++++++++" && \
  ls -hla --color=tty && \
  echo && \
  echo "====== Here's what's one step above me ======" && \
  ls -hla .. && \
  echo

RUN \
  apt-get update && \
  apt-get -y install \
    build-essential \
    wget \
    curl \
    openssh-client \
    software-properties-common \
    unzip

RUN \
  add-apt-repository ppa:git-core/ppa -y && \
  apt-get update && \
  apt-get install -y git && \
  apt-get remove -y --purge software-properties-common

ENV GOPATH /go
ENV PATH /go/bin:/usr/local/go/bin:$PATH
RUN \
  wget https://storage.googleapis.com/golang/go1.6.3.linux-amd64.tar.gz -P /tmp && \
  tar xzvf /tmp/go1.6.3.linux-amd64.tar.gz -C /usr/local && \
  mkdir $GOPATH && \
  rm -rf /tmp/*

# Install the cf CLI
RUN \
  wget -q -O cf.deb "https://cli.run.pivotal.io/stable?release=debian64&version=$(cat cf-cli/tag | sed -r 's/v+//g')&source=github-rel" && \
  dpkg -i cf.deb

# Install the container networking CLI plugin
RUN wget -q -O /tmp/network-policy-plugin "https://github.com/cloudfoundry-incubator/netman-release/releases/download/v0.11.0/network-policy-plugin-linux64" && \
  chmod +x /tmp/network-policy-plugin && \
  cf install-plugin /tmp/network-policy-plugin -f && \
  rm -rf /tmp/*
