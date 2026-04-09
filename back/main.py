from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
import re
import cv2
import numpy as np
import pytesseract
from pdf2image import convert_from_bytes
from PIL import Image
import os

# ==========================================
# CONFIGURAÇÃO PARA O WINDOWS
# ==========================================
# Avisa ao Python onde o Tesseract.exe foi instalado
pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'
os.environ['TESSDATA_PREFIX'] = r'C:\Program Files\Tesseract-OCR\tessdata'
app = FastAPI()

# Configuração do CORS para permitir a comunicação com o Flutter
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/extrair/")
async def extrair_arquivo(file: UploadFile = File(...)):
    print("\n=========================================")
    print(f"[PYTHON] 1. OPA! Recebi um arquivo chamado: {file.filename}")
    
    try:
        # 1. Lê os BYTES do arquivo recebido pelo Flutter
        conteudo_pdf = await file.read()
        print(f"[PYTHON] 2. Tamanho do arquivo lido: {len(conteudo_pdf)} bytes")
        
        # 2. Converte o PDF em imagem (Avisando onde está o Poppler no Windows)
        print("[PYTHON] 3. Convertendo PDF para imagem com Poppler...")
        paginas = convert_from_bytes(conteudo_pdf, poppler_path=r'C:\poppler\Library\bin')
        primeira_pagina = paginas[0]

        # 3. Visão Computacional (Separação do canal verde e limpeza)
        print("[PYTHON] 4. Aplicando filtros de Visão Computacional (OpenCV)...")
        imagem_colorida = np.array(primeira_pagina)
        r, g, b = cv2.split(imagem_colorida)
        imagem_gigante = cv2.resize(g, None, fx=2, fy=2, interpolation=cv2.INTER_CUBIC)
        _, imagem_limpa = cv2.threshold(imagem_gigante, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)

        # 4. Tesseract OCR (Leitura da Imagem)
        print("[PYTHON] 5. Lendo a imagem com Tesseract OCR...")
        imagem_final_pil = Image.fromarray(imagem_limpa)
        config_ocr = r'--psm 6'
        texto_extraido = pytesseract.image_to_string(imagem_final_pil, lang='por', config=config_ocr)
        print(f"[PYTHON] 5.1. Texto extraido: {texto_extraido[:100]}...")  # Mostra os primeiros 100 caracteres

        # 5. Regex para capturar CPF e RG
        print("[PYTHON] 6. Procurando CPF e RG no texto extraido...")
        padrao_cpf = r'\d{3}\.?\d{3}\.?\d{3}-?\d{2}'
        padrao_rg = r'\d{2}\.?\d{3}\.?\d{3}-?[\dXx]{1}'

        resultado_cpf = re.search(padrao_cpf, texto_extraido)
        resultado_rg = re.search(padrao_rg, texto_extraido)

        cpf_final = resultado_cpf.group() if resultado_cpf else "CPF Nao Encontrado"
        rg_final = resultado_rg.group() if resultado_rg else "RG Nao Encontrado"

        # 6. Retorna o JSON de volta para o Flutter
        print(f"[PYTHON] 7. SUCESSO! Dados extraidos: CPF {cpf_final} | RG {rg_final}")
        print("=========================================\n")
        
        return {
            "status": "sucesso",
            "nome_arquivo": file.filename,
            "tipo_documento": "CNH / Documento Pessoal",
            "cpf": cpf_final,
            "rg": rg_final,
            "status_validacao": "pendente_de_analise"
        }

    except Exception as e:
        # TIREI O EMOJI DAQUI PARA O WINDOWS NÃO CHORAR!
        print(f"[PYTHON] [ERRO CRITICO]: {str(e)}")
        print("=========================================\n")
        return {"status": "erro", "mensagem": str(e)}
    
@app.get("/ping")
def testar_conexao():
    return {"mensagem": "Oi, tudo bem! O Flutter e o Python estao conversando!"}

if __name__ == "__main__":
    # Comando para rodar o servidor na porta 8000
    uvicorn.run(app, host="0.0.0.0", port=8000)