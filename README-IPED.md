# Script IPED - Automação para Processamento Forense


### IPED (Indexador e Processador de Evidências Digitais)

> **📋 Nota Importante**: O **Odysseus OS** já vem com o IPED 4 pré-configurado e pronto para uso. Se você está usando esta distribuição, pode pular a seção de instalação e ir diretamente para o [Uso](#uso).

#### Instalação no Odysseus OS
Se você está usando o Odysseus OS, o IPED já está instalado e configurado em `/opt/iped-4/`. Verifique a instalação com:

```bash
# Verificar se o IPED está instalado
ls -la /opt/iped-4/iped.jar

# Testar funcionamento
java -jar /opt/iped-4/iped.jar --help
```

#### Instalação Manual (Outras Distribuições)

Para instalações em outras distribuições Linux ou instalações personalizadas, consulte o **manual oficial da Polícia Federal**:

**🔗 [Manual de Instalação IPED - Polícia Federal](https://github.com/sepinf-inc/IPED/wiki/Linux)**

##### Instalação Básica (Referência)
```bash
# Criar diretório de instalação
sudo mkdir -p /opt/iped-4

# Baixar IPED (substitua pela versão mais recente)
wget https://github.com/sepinf-inc/IPED/releases/latest/download/iped-4.x.x.zip

# Extrair para o diretório de instalação
sudo unzip iped-4.x.x.zip -d /opt/iped-4/

# Definir permissões
sudo chmod +x /opt/iped-4/iped.jar
```

⚠️ **Atenção**: Para instalações manuais, sempre consulte a documentação oficial da Polícia Federal, pois os procedimentos podem ser atualizados e incluir configurações específicas importantes para o funcionamento correto da ferramenta.



## Descrição

Este script automatiza o processamento de arquivos forenses usando a ferramenta IPED (Indexador e Processador de Evidências Digitais). Ele permite o processamento em lote de arquivos `.zip`, `.E01` e `.ISO` através de uma interface gráfica intuitiva.

## Funcionalidades Principais

### 🔍 Processamento Forense
- **IPED Integration**: Integração com ferramenta IPED versão 4
- **Múltiplos Formatos**: Suporte para arquivos ZIP, E01 e ISO
- **Processamento em Lote**: Processamento sequencial de múltiplos arquivos
- **Interface Gráfica**: Seleção de pastas via Zenity

### 📁 Gerenciamento de Arquivos
- **Detecção Automática**: Localiza automaticamente arquivos suportados
- **Organização**: Cria subpastas individuais para cada arquivo processado
- **Validação**: Verifica existência de arquivos e dependências

### 🖥️ Interface do Usuário
- **Seleção Intuitiva**: Interface gráfica para seleção de pastas
- **Relatórios Visuais**: Exibe lista de arquivos encontrados
- **Notificações**: Alertas de erro e confirmações de conclusão

## Pré-requisitos

### Java OpenJDK 11

O IPED requer Java OpenJDK 11 para funcionar corretamente.

#### Instalação no Ubuntu/Debian
```bash
# Atualizar repositórios
sudo apt update

# Instalar OpenJDK 11
sudo apt install openjdk-11-jdk openjdk-11-jre

# Verificar instalação
java -version
```

#### Saída esperada:
```
openjdk version "11.0.25" 2024-10-15
OpenJDK Runtime Environment (build 11.0.25+9-post-Ubuntu-1ubuntu122.04)
OpenJDK 64-Bit Server VM (build 11.0.25+9-post-Ubuntu-1ubuntu122.04, mixed mode, sharing)
```

#### Configuração da Variável JAVA_HOME
```bash
# Verificar local da instalação
sudo update-alternatives --config java

# Adicionar ao ~/.bashrc ou ~/.profile
echo 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64' >> ~/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc

# Recarregar configurações
source ~/.bashrc
```

### IPED (Indexador e Processador de Evidências Digitais)

#### Download e Instalação
```bash
# Criar diretório de instalação
sudo mkdir -p /opt/iped-4

# Baixar IPED (substitua pela URL atual)
wget https://github.com/sepinf-inc/IPED/releases/download/4.x.x/iped-4.x.x.zip

# Extrair para o diretório de instalação
sudo unzip iped-4.x.x.zip -d /opt/iped-4/

# Definir permissões
sudo chmod +x /opt/iped-4/iped.jar
```

### Dependências Adicionais
```bash
# Ubuntu/Debian
sudo apt install zenity

# Fedora
sudo dnf install zenity

# Arch Linux
sudo pacman -S zenity
```

## Uso

### Execução do Script
```bash
# Tornar executável
chmod +x iped

# Executar
./iped
```

### Fluxo de Operação

1. **Seleção da Pasta de Entrada**
   - O script abre um diálogo para seleção da pasta contendo os arquivos
   - Suporta arquivos: `.zip`, `.E01`, `.ISO`

2. **Seleção da Pasta de Saída**
   - Escolha onde os resultados processados serão salvos
   - O script cria a pasta automaticamente se não existir

3. **Detecção de Arquivos**
   - Busca recursiva por arquivos suportados
   - Exibe lista dos arquivos encontrados

4. **Processamento**
   - Cria subpasta individual para cada arquivo
   - Executa IPED sequencialmente para cada arquivo
   - Notifica conclusão do processamento

## Estrutura de Arquivos

### Antes do Processamento
```
pasta_entrada/
├── evidencia1.zip
├── evidencia2.E01
└── evidencia3.ISO
```

### Após o Processamento
```
pasta_saida/
├── evidencia1/
│   ├── IndexDados/
│   ├── relatorio.html
│   └── ... (arquivos IPED)
├── evidencia2/
│   ├── IndexDados/
│   ├── relatorio.html
│   └── ... (arquivos IPED)
└── evidencia3/
    ├── IndexDados/
    ├── relatorio.html
    └── ... (arquivos IPED)
```

## Configuração

### Caminho do IPED
O script usa caminho fixo para o IPED:
```bash
IPED_JAR="/opt/iped-4/iped.jar"
```

Para alterar o caminho, edite a variável no início do script:
```bash
IPED_JAR="/caminho/personalizado/iped.jar"
```

## Tratamento de Erros

### Erros Comuns e Soluções

| Erro | Causa | Solução |
|------|-------|---------|
| "O arquivo Iped.jar não foi encontrado" | IPED não instalado ou caminho incorreto | Verifique instalação do IPED em `/opt/iped-4/` |
| "Nenhuma pasta selecionada" | Usuário cancelou seleção | Execute novamente e selecione uma pasta |
| "Nenhum arquivo encontrado" | Pasta não contém arquivos suportados | Verifique se existem arquivos .zip, .E01 ou .ISO |
| Erro de Java | Java não instalado ou versão incorreta | Instale OpenJDK 11 conforme instruções |

### Validação da Instalação

#### Verificar Java
```bash
java -version
javac -version
```

#### Verificar IPED
```bash
ls -la /opt/iped-4/iped.jar
java -jar /opt/iped-4/iped.jar --help
```

#### Verificar Zenity
```bash
zenity --version
```

## Recursos Avançados

### Processamento Paralelo
Atualmente o script processa arquivos sequencialmente. Para processamento paralelo, modifique o loop:

```bash
# Processamento paralelo (use com cuidado - consome mais recursos)
for FILE in $FILES; do
    BASENAME=$(basename "$FILE")
    SUBFOLDER="$OUTPUT_FOLDER/${BASENAME%.*}"
    mkdir -p "$SUBFOLDER"
    java -jar "$IPED_JAR" -d "$FILE" -o "$SUBFOLDER" &
done
wait  # Aguarda todos os processos terminarem
```

### Personalização de Parâmetros IPED
```bash
# Exemplo com parâmetros adicionais
java -Xmx8G -jar "$IPED_JAR" -d "$FILE" -o "$SUBFOLDER" --profile forensic
```

## Logs e Depuração

### Ativar Modo Debug
```bash
#!/bin/bash -x  # Adicionar no início do script
```

### Logs do IPED
Os logs do IPED são salvos automaticamente em cada pasta de saída:
- `processing.log` - Log principal do processamento
- `error.log` - Erros encontrados durante o processamento

## Requisitos de Sistema

### Hardware Mínimo
- **RAM**: 4 GB (recomendado 8 GB ou mais)
- **Espaço em Disco**: 3x o tamanho dos arquivos de entrada
- **CPU**: Processador dual-core (recomendado quad-core)

### Sistema Operacional
- **Linux**: Ubuntu 18.04+, Debian 10+, Fedora 30+, Arch Linux
- **Interface Gráfica**: X11 ou Wayland com suporte ao Zenity

## Observações Importantes

- **Tempo de Processamento**: Varia drasticamente conforme tamanho dos arquivos
- **Recursos do Sistema**: IPED pode consumir muita RAM e CPU
- **Espaço em Disco**: Certifique-se de ter espaço suficiente na pasta de saída
- **Interrupção**: Use Ctrl+C para interromper o processamento se necessário

## Suporte e Documentação

### Links Úteis
- [IPED GitHub](https://github.com/sepinf-inc/IPED)
- [Documentação IPED](https://iped.readthedocs.io/)
- [OpenJDK](https://openjdk.java.net/)

### Solução de Problemas
1. Verifique logs de erro do IPED
2. Confirme versão correta do Java
3. Valide permissões de arquivo
4. Monitore uso de recursos do sistema