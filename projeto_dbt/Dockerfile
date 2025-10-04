FROM python:3.9-slim

# Variáveis para criar o usuário "dbt"
ARG USER=dbt
ARG UID=1000
ARG GID=1000

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Criar grupo e usuário não-root
RUN groupadd -g ${GID} ${USER} && \
    useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USER}

# Instalar o dbt e o dbt-postgres
RUN pip install --no-cache-dir dbt-core==1.9.4 dbt-postgres==1.9.0

# Definir diretório de trabalho
WORKDIR /dbt

# Trocar para o usuário "dbt"
USER ${USER}

EXPOSE 9100 8080 9000

# Manter o container ativo
CMD ["tail", "-f", "/dev/null"]