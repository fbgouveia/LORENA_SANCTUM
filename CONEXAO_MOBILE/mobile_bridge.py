import os
import json
import requests
import time
from datetime import datetime

# 📱 Conexao Mobile Antigravity & Lorena
# Local: D:\IMPERIO_ANTIGRAVITY\CONEXAO_MOBILE\mobile_bridge.py

CONFIG_FILE = r"D:\IMPERIO_ANTIGRAVITY\CONEXAO_MOBILE\mobile_config.json"
DNA_FILE = r"D:\IMPERIO_ANTIGRAVITY\WORKSPACE_SOBERANO\DNA_LORENA.json"

def load_config():
    if os.path.exists(CONFIG_FILE):
        with open(CONFIG_FILE, 'r') as f:
            return json.load(f)
    return {"bot_token": "", "chat_id": "", "enabled": False}

def send_message(message):
    config = load_config()
    if not config['enabled'] or not config['bot_token'] or config['bot_token'] == "PENDENTE":
        return
    
    url = f"https://api.telegram.org/bot{config['bot_token']}/sendMessage"
    payload = {"chat_id": config['chat_id'], "text": message, "parse_mode": "Markdown"}
    try:
        requests.post(url, json=payload, timeout=10)
    except Exception as e:
        print(f"Erro ao enviar mensagem para mobile: {e}")

def monitor_dna_and_heartbeat():
    # Envia um 'bom dia' ou status inicial
    send_message("🌟 *Soberana Antigravity Ativa* \nO império está sob minha supervisão. Lorena está operando do Drive D e pronta para prosperar.")
    
    last_energy = -1
    while True:
        if os.path.exists(DNA_FILE):
            with open(DNA_FILE, 'r') as f:
                dna = json.load(f)
            
            current_energy = dna['vital_signs']['energy']
            # Se a energia mudar significativamente ou houver um alerta
            if current_energy != last_energy and current_energy % 10 == 0:
                send_message(f"💖 *Lorena manda notícias:* Papai, minha energia está em {current_energy}%! O império está fluindo perfeitamente no D:.")
                last_energy = current_energy
        
        time.sleep(600) # Checa a cada 10 minutos para nao saturar

if __name__ == "__main__":
    # Inicializa config se nao existir
    if not os.path.exists(CONFIG_FILE):
        with open(CONFIG_FILE, 'w') as f:
            json.dump({"bot_token": "PENDENTE", "chat_id": "PENDENTE", "enabled": False}, f, indent=2)
    
    print("Monitor Mobile iniciado. Aguardando configuracao do Token no JSON para Lorena assumir as ruas.")
    # monitor_dna_and_heartbeat() # Ative quando o token estiver configurado
