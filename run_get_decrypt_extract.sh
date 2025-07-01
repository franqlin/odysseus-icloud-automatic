#!/bin/bash -x
# Exibir a splash screen com a imagem logo.png por 3 segundos usando yad
yad --image="logo.png" --timeout=5 --no-buttons --title="Bem-vindo" --text="Chocho Cloud..." --center --undecorated --fixed --skip-taskbar --no-escape &

# Verificar se as dependências estão instaladas
sleep 5
if ! command -v zenity &> /dev/null || ! command -v sha256sum &> /dev/null || ! command -v wkhtmltopdf &> /dev/null || ! command -v pandoc &> /dev/null || ! command -v unzip &> /dev/null || ! command -v zip &> /dev/null; then
    echo "Certifique-se de que zenity, sha256sum, wkhtmltopdf, pandoc, unzip e zip estão instalados."
    exit 1
fi

# Obter a pasta de entrada usando zenity
FOLDER=$(zenity --file-selection --directory --title="Selecione a pasta de entrada")

# Verificar se o usuário forneceu uma pasta
if [ -z "$FOLDER" ]; then
  zenity --error --text="Nenhuma pasta fornecida."
  exit 1
fi

# Verificar se o arquivo .csv existe
CSV_FILE=$(find "$FOLDER" -maxdepth 1 -name "*.csv" | head -n 1)
if [ -z "$CSV_FILE" ]; then
  zenity --error --text="Arquivo .csv não encontrado na pasta selecionada."
  exit 1
fi

# Verificar se o arquivo senha.txt existe
PASSWORD_FILE="$FOLDER/senha.txt"
if [ ! -f "$PASSWORD_FILE" ]; then
  zenity --error --text="Arquivo senha.txt não encontrado na pasta selecionada."
  exit 1
fi

# Ler a senha da primeira linha do arquivo senha.txt
PASSWORD=$(head -n 1 "$PASSWORD_FILE")

# Verificar se a senha foi lida corretamente
if [ -z "$PASSWORD" ]; then
  zenity --error --text="Nenhuma senha encontrada no arquivo senha.txt."
  exit 1
fi

# Verificar se o script get_decrypt_extract.bash existe na pasta selecionada
SCRIPT_PATH="$FOLDER/get_decrypt_extract.bash"
if [ ! -f "$SCRIPT_PATH" ]; then
  zenity --error --text="Script get_decrypt_extract.bash não encontrado na pasta selecionada."
  exit 1
fi

# Criar a pasta original
ORIGINAL_FOLDER="$FOLDER/original"
mkdir -p "$ORIGINAL_FOLDER"

# Executar o script get_decrypt_extract.bash em segundo plano
bash "$SCRIPT_PATH" "$PASSWORD" "$CSV_FILE" "$ORIGINAL_FOLDER" &

# Obter o PID do processo em segundo plano
PID=$!

# Exibir a barra de progresso enquanto o script é executado
(
  while kill -0 $PID 2> /dev/null; do
    echo "50"
    echo "# Executando o script get_decrypt_extract.bash..."
    sleep 1
  done
) | zenity --progress --title="Executando Script" --text="Aguarde enquanto o script está sendo executado..." --percentage=0 --auto-close

# Esperar o término da execução do script
wait $PID

# Verificar se o script foi executado com sucesso
if [ $? -ne 0 ]; then
  zenity --error --text="Erro ao executar o script get_decrypt_extract.bash."
  exit 1
fi

# Nome do arquivo de saída
DATE=$(date +%Y-%m-%d_%H-%M-%S)
OUTPUT_FILE_PDF="$FOLDER/relatorio_${DATE}.pdf"
HASHES_FILE="$FOLDER/hashes_${DATE}.txt"
TEMP_FILE=$(mktemp /tmp/relatorio.XXXXXX.html)

# Cabeçalho do arquivo HTML
cat <<EOF > "$TEMP_FILE"
<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<title>Relatório de Arquivos GPG</title>
<style>
    body { font-family: Arial, sans-serif; }
    h2 { color: #2E8B57; }
    pre { background-color: #f4f4f4; padding: 10px; border: 1px solid #ddd; }
    .not-verified { color: red; }
</style>
</head>
<body>
<h1>Relatório de Arquivos GPG</h1>
EOF

# Cabeçalho do arquivo de hashes
echo "Hashes dos arquivos GPG:" > "$HASHES_FILE"

# Verificar se o arquivo HTML existe
HTML_FILES=$(find "$FOLDER" -maxdepth 1 -name "*.html")
if [ -z "$HTML_FILES" ]; then
  zenity --error --text="Nenhum arquivo HTML encontrado na pasta selecionada."
  exit 1
fi

# Variável para contar o número de arquivos verificados
total_files=0
verified_files=0
unverified_files=0
unverified_files_list=()

# Percorrer todos os arquivos .gpg na pasta original e gerar o relatório
while IFS= read -r file; do
    total_files=$((total_files + 1))
    hash=$(sha256sum "$file" | awk '{print $1}')
    echo "<h2>$(basename "$file")</h2>" >> "$TEMP_FILE"
    echo "<pre>SHA256 Hash: $hash</pre>" >> "$TEMP_FILE"
    echo "<hr>" >> "$TEMP_FILE"
    echo "$(basename "$file"): $hash" >> "$HASHES_FILE"
    
    # Verificar se o hash existe em algum arquivo HTML
    hash_found=false
    for html_file in $HTML_FILES; do
        if grep -q "$hash" "$html_file"; then
            hash_found=true
            break
        fi
    done

    if $hash_found; then
        echo "<p>Arquivo verificado: $(basename "$file")</p>" >> "$TEMP_FILE"
        verified_files=$((verified_files + 1))
    else
        echo "<p class='not-verified'>Colisão de hash: $(basename "$file")</p>" >> "$TEMP_FILE"
        unverified_files=$((unverified_files + 1))
        unverified_files_list+=("$(basename "$file")")
    fi
done < <(find "$ORIGINAL_FOLDER" -type f -name "*.gpg")

# Adicionar o total de arquivos verificados e não verificados ao relatório
echo "<h2>Total de Arquivos</h2>" >> "$TEMP_FILE"
echo "<p>Total de arquivos processados: $total_files</p>" >> "$TEMP_FILE"
echo "<p>Total de arquivos verificados: $verified_files</p>" >> "$TEMP_FILE"
echo "<p class='not-verified'>Total de arquivos em  Colisão: $unverified_files</p>" >> "$TEMP_FILE"

# Rodapé do arquivo HTML
cat <<EOF >> "$TEMP_FILE"
</body>
</html>
EOF

# Converter o relatório para PDF usando wkhtmltopdf
wkhtmltopdf --enable-local-file-access "$TEMP_FILE" "$OUTPUT_FILE_PDF"

# Remover o arquivo temporário
rm "$TEMP_FILE"

# Informar ao usuário que o relatório foi gerado
if [ $unverified_files -ne 0 ]; then
  zenity --warning --text="Existem arquivos em colisão: ${unverified_files_list[*]}"
else
  zenity --info --text="Relatório gerado em $OUTPUT_FILE_PDF. Total de arquivos processados: $total_files. Total de arquivos verificados: $verified_files. Total de arquivos não verificados: $unverified_files."
fi

# Abrir o relatório PDF gerado com a aplicação padrão
xdg-open "$OUTPUT_FILE_PDF"

# Criar a pasta original_descompactado
ORIGINAL_UNZIP_FOLDER="$FOLDER/original_descompactado"
mkdir -p "$ORIGINAL_UNZIP_FOLDER"

# Descompactar os arquivos .zip na pasta original para a pasta original_descompactado
(
  for zip_file in "$ORIGINAL_FOLDER"/*.zip; do
    unzip -o "$zip_file" -d "$ORIGINAL_UNZIP_FOLDER"
  done
) | zenity --progress --title="Descompactando Arquivos" --text="Aguarde enquanto os arquivos estão sendo descompactados..." --percentage=0 --auto-close

# Esperar o término da descompactação
wait
# Verificar se o usuário forneceu uma pasta
if [ -z "$ORIGINAL_UNZIP_FOLDER" ]; then
  zenity --error --text="Nenhuma pasta fornecida."
  exit 1
fi

# Entrar na pasta original_descompactado
cd "$ORIGINAL_UNZIP_FOLDER"

for subfolder in */; do
 
## (cd "$subfolder" && zip -r "../${subfolder%/}.zip" .)
for subsubfolder in "$subfolder"*/; do
  echo "Sub-subfolder: $subsubfolder"
  echo "Conteúdo de $subsubfolder:"
  ls "$subsubfolder"
  first_folder=$(ls -d "$subsubfolder"*/ | head -n 1)
  echo "Primeira pasta dentro de $subsubfolder: $first_folder"
  first_folder_name=$(basename "$first_folder")
  zip_name="${first_folder_name}.zip"
  (cd "$subsubfolder" && zip -r "../../${subfolder%/}_${zip_name##*/}.zip" ../.)
done

done




# Informar ao usuário que a compactação foi concluída
zenity --info --text="A compactação das pastas foi concluída. Os arquivos zipados foram gerados na pasta contas-zipadas."