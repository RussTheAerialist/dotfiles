FROM debian:stable as onepassword_builder
RUN apt-get update && apt-get install -y curl ca-certificates unzip
RUN curl -sS -o 1password.zip https://cache.agilebits.com/dist/1P/op/pkg/v0.5.5/op_linux_amd64_v0.5.5.zip && unzip 1password.zip op -d /usr/bin &&  rm 1password.zip

FROM debian:stable as terraform_builder
RUN apt-get update && apt-get install -y wget ca-certificates unzip
RUN wget https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip && unzip terraform_0.11.11_linux_amd64.zip && chmod +x terraform && mv terraform /usr/local/bin && rm terraform_0.11.11_linux_amd64.zip

FROM debian:stable as git-town_fetcher
WORKDIR /root
RUN apt-get update && apt-get install -y curl wget ca-certificates jq
RUN curl --silent "https://api.github.com/repos/Originate/git-town/releases/latest" | jq -r ".assets[] | select(.name | contains(\"git-town-amd64.deb\")) | .browser_download_url" | wget -i -

FROM debian:stable AS devbox
ENV DEBIAN_FRONTEND=noninteractive
LABEL name="devbox"
RUN apt-get update -qq -y && apt-get upgrade -y && apt-get install -qq -y \
      apt-utils \
      build-essential \
      ca-certificates \
      curl \
      emacs \
      # fasd \  # Not available on stable yet
      git \
      git-crypt \
      htop \
      cpubars \
      less \
      libffi-dev \
      libssl-dev \
      locales \
      mosh \
      openssh-server \
      python3 \
      python3-dev \
      python3-pip \
      python3-venv \
      qrencode \
      sudo \
      tmux \
      tmate \
      tree \
      zsh \
      --no-install-recommends \
      && rm -rf /var/lib/apt/lists/*

# Install Python packages
COPY python_packages.txt /root/python_packages.txt
RUN pip3 install -r /root/python_packages.txt

# Install Rustup and Nightly
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain nightly
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

ENV LANG="en_US.UTF-8"
ENV LC_ALL="en_US.UTF-8"
ENV LANGUAGE="en_US.UTF-8"

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
	locale-gen --purge $LANG && \
	dpkg-reconfigure --frontend=noninteractive locales && \
	update-locale LANG=$LANG LC_ALL=$LC_ALL LANGUAGE=$LANGUAGE

ENV TERM screen-256color

# Copy from the builder images
COPY --from=terraform_builder /usr/local/bin/terraform /usr/local/bin/
COPY --from=onepassword_builder /usr/bin/op /usr/local/bin/
COPY --from=git-town_fetcher /root/*.deb /root/

# Install debian packages
RUN dpkg -i /root/*.deb

RUN chsh -s /usr/bin/zsh
WORKDIR /root
COPY zshrc /root/.zshrc
COPY entrypoint.sh /bin/entrypoint.sh
CMD [ "/bin/entrypoint.sh" ]
