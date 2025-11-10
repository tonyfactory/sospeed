# Ruby 3.3開発環境
FROM ruby:3.3-slim

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y \
    git \
    curl \
    build-essential \
    zsh \
    vim \
    less \
    locales \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 日本語ロケール設定
RUN sed -i '/ja_JP.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG=ja_JP.UTF-8
ENV LC_ALL=ja_JP.UTF-8

# 開発用ユーザーを作成
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# ワークスペースディレクトリを作成
RUN mkdir -p /workspace && chown -R $USERNAME:$USERNAME /workspace

# Bundlerをインストール
RUN gem install bundler

# デフォルトユーザーを設定
USER $USERNAME

# Gemのインストール先をユーザーホームディレクトリに設定
ENV GEM_HOME=/home/$USERNAME/.gem
ENV PATH=$GEM_HOME/bin:$PATH
RUN mkdir -p $GEM_HOME && bundle config set --global path $GEM_HOME

# デフォルトシェルをbashに設定
SHELL ["/bin/bash", "-c"]

# 作業ディレクトリを設定
WORKDIR /workspace

# デフォルトコマンド
CMD ["/bin/bash"]
