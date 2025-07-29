FROM python:3.10-slim

# Instala dependências do sistema
RUN apt-get update && apt-get install -y \
    espeak \
    libsndfile1 \
    git \
    curl \
    build-essential \
    gcc \
    libffi-dev \
    libpq-dev \
    libsndfile-dev \
    && rm -rf /var/lib/apt/lists/*

# Instala rust (necessário para sudachipy)
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Atualiza pip e instala TTS e Flask
RUN pip install --upgrade pip
RUN pip install TTS==0.22.0 flask

# Cria diretório e copia app flask
WORKDIR /app
COPY app.py .

# Expõe porta e roda o servidor
EXPOSE 5002
CMD ["python", "app.py"]