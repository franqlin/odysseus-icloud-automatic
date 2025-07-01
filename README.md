# Script de Automação GPG - run_get_decrypt_extract.sh

## Descrição

Este script automatiza o processo completo de verificação, extração, geração de relatórios e compactação de arquivos relacionados a dados GPG. Oferece uma interface gráfica amigável com splash screen personalizada e barras de progresso para acompanhamento das operações.

## Funcionalidades Principais

### 🖥️ Interface Gráfica
- **Splash Screen**: Exibe imagem de boas-vindas (`logo01.png`) por 5 segundos
- **Seleção de Pasta**: Interface gráfica para escolha da pasta de entrada
- **Barras de Progresso**: Acompanhamento visual das operações em andamento
- **Notificações**: Alertas e confirmações através de diálogos gráficos

### 🔧 Gerenciamento de Dependências
- Verificação automática de dependências necessárias
- Instalação automática via gerenciadores de pacotes suportados:
  - `apt-get` (Debian/Ubuntu)
  - `dnf` (Fedora)
  - `yum` (CentOS/RHEL)
  - `pacman` (Arch Linux)

### 📁 Validação de Arquivos
- Verifica existência de arquivo `.csv` na pasta selecionada
- Valida presença do arquivo `senha.txt`
- Confirma existência do script `get_decrypt_extract.bash`

### 🔐 Processamento GPG
- Execução do script de extração e descriptografia em segundo plano
- Geração de relatórios detalhados em HTML e PDF
- Cálculo e verificação de hashes SHA256 dos arquivos GPG
- Detecção de colisões de hash

### 📋 Geração de Relatórios
- Relatório HTML estilizado com informações detalhadas
- Conversão automática para PDF
- Abertura automática do relatório gerado
- Arquivo de hashes separado para referência

### 📦 Gerenciamento de Arquivos
- Descompactação automática de arquivos `.zip`
- Recompactação inteligente de subpastas
- Organização estruturada dos arquivos processados

## Uso

### Execução Básica
```bash
./run_get_decrypt_extract.sh
```

### Pré-requisitos
1. **Sistema Operacional**: Linux com interface gráfica
2. **Permissões**: Usuário com privilégios sudo para instalação de dependências
3. **Arquivos Necessários**:
   - Um arquivo `.csv` na pasta de entrada
   - Arquivo `senha.txt` com a senha na primeira linha
   - Script `get_decrypt_extract.bash`
   - Imagem `logo01.png` (opcional, para splash screen)

## Dependências

### Pacotes Obrigatórios
- `bash` - Shell para execução
- `yad` - Interface gráfica para splash screen
- `zenity` - Diálogos gráficos
- `sha256sum` - Cálculo de hashes
- `wkhtmltopdf` - Conversão HTML para PDF
- `pandoc` - Processamento de documentos
- `unzip` - Descompactação de arquivos
- `zip` - Compactação de arquivos
- `xdg-open` - Abertura de arquivos padrão

### Instalação Manual (se necessário)
```bash
# Ubuntu/Debian
sudo apt-get install yad zenity wkhtmltopdf pandoc unzip zip

# Fedora
sudo dnf install yad zenity wkhtmltopdf pandoc unzip zip

# Arch Linux
sudo pacman -S yad zenity wkhtmltopdf pandoc unzip zip
```

## Estrutura de Arquivos

### Antes da Execução
```
pasta_entrada/
├── arquivo.csv
├── senha.txt
├── get_decrypt_extract.bash
└── logo01.png (opcional)
```

### Após a Execução
```
pasta_entrada/
├── arquivo.csv
├── senha.txt
├── get_decrypt_extract.bash
├── logo01.png
├── original/                    # Arquivos GPG extraídos
│   └── *.gpg
├── original_descompactado/      # Arquivos descompactados
├── relatorio_YYYY-MM-DD_HH-MM-SS.pdf
├── hashes_YYYY-MM-DD_HH-MM-SS.txt
└── *.html                       # Arquivos HTML gerados
```

## Fluxo de Execução

1. **Inicialização**
   - Exibe splash screen de boas-vindas
   - Verifica e instala dependências necessárias

2. **Seleção e Validação**
   - Solicita seleção da pasta de entrada
   - Valida existência dos arquivos obrigatórios
   - Lê e valida a senha do arquivo `senha.txt`

3. **Processamento**
   - Cria pasta `original` para arquivos GPG
   - Executa script de extração em segundo plano
   - Exibe barra de progresso durante o processamento

4. **Geração de Relatórios**
   - Calcula hashes SHA256 dos arquivos GPG
   - Verifica presença dos hashes em arquivos HTML
   - Gera relatório detalhado em HTML e PDF
   - Identifica e reporta colisões de hash

5. **Pós-processamento**
   - Descompacta arquivos ZIP encontrados
   - Recompacta subpastas organizadamente
   - Abre relatório PDF automaticamente

## Tratamento de Erros

### Erros Comuns e Soluções

| Erro | Causa | Solução |
|------|-------|---------|
| "Nenhuma pasta fornecida" | Usuário cancelou seleção | Execute novamente e selecione uma pasta |
| "Arquivo .csv não encontrado" | Pasta não contém arquivo CSV | Verifique se existe um arquivo .csv na pasta |
| "Arquivo senha.txt não encontrado" | Arquivo de senha ausente | Crie arquivo `senha.txt` com a senha na primeira linha |
| "Script get_decrypt_extract.bash não encontrado" | Script principal ausente | Certifique-se que o script está na pasta selecionada |
| "Gerenciador de pacotes não suportado" | Sistema não suportado | Instale dependências manualmente |

## Saídas do Script

### Relatório PDF
- Lista completa de arquivos GPG processados
- Hashes SHA256 de cada arquivo
- Status de verificação (verificado/colisão)
- Estatísticas totais de processamento

### Arquivo de Hashes
- Lista simples de arquivos e seus respectivos hashes
- Formato: `nome_arquivo: hash_sha256`

### Notificações
- **Sucesso**: Informações sobre arquivos processados
- **Aviso**: Detecção de colisões de hash
- **Erro**: Problemas durante execução

## Observações Importantes

- **Interface Gráfica**: O script requer ambiente gráfico ativo
- **Permissões**: Pode solicitar senha sudo para instalação de dependências
- **Tempo de Execução**: Varia conforme tamanho e quantidade de arquivos
- **Espaço em Disco**: Certifique-se de ter espaço suficiente para arquivos descompactados
- **Backup**: Recomenda-se backup dos dados originais antes da execução

## Suporte

Para problemas ou dúvidas:
1. Verifique se todas as dependências estão instaladas
2. Confirme que os arquivos obrigatórios estão presentes
3. Execute o script com privilégios adequados
4. Consulte os logs de erro