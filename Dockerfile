FROM ubuntu:latest

# Установить все зависимости за один RUN
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    make \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    python3-openssl \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Установить pyenv
RUN git clone https://github.com/pyenv/pyenv.git /root/.pyenv

# Задать переменные среды для pyenv
ENV PYENV_ROOT="/root/.pyenv"
ENV PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"

# Установить Python 3.12.0 через pyenv + установить UV
RUN bash -c "\
    pyenv install 3.12.0 && \
    pyenv global 3.12.0 && \
    curl -LsSf https://astral.sh/uv/install.sh | sh"

# Создать рабочую папку
WORKDIR /app

# Копировать только файлы зависимостей сначала (для кэширования)
COPY pyproject.toml uv.lock ./

# Создать виртуальное окружение и установить зависимости
RUN uv venv && uv pip install -r pyproject.toml

# Копировать остальной код проекта
COPY manage.py .
COPY testProProject ./testProProject
# Здесь добавьте приложения для иморта

# Открыть порт
EXPOSE 8000

# Команда запуска
CMD ["uv", "run", "python3", "manage.py", "runserver", "0.0.0.0:8000"]