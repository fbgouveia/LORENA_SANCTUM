import os
import time
import json
import random
from datetime import datetime

# 📈 Growth Strategist v1.0
# Injecting sales intelligence and growth insights into Lorena's memory.

DNA_FILE = r"D:\IMPERIO_ANTIGRAVITY\inertial-aphelion\DNA_LORENA.json"
LOG_FILE = r"D:\IMPERIO_ANTIGRAVITY\ARQUIVOS_EXECUCAO\operations.log"

STRATEGIES = [
    "A escassez gera urgência. Vamos garantir que as landing pages reflitam isso.",
    "O neuromarketing sugere que cores suaves aumentam a confiança na conversão.",
    "Thelma Nascimento: A autoridade parental é o gatilho principal. Manter SEO focado em 'Estrategista Parental'.",
    "Conversão 2026: Implementar chatbots ultra-personalizados para lead qualification.",
    "O Império Antigravity cresce 2% a cada ciclo de automação concluído."
]

def log(msg):
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    with open(LOG_FILE, "a", encoding="utf-8") as f:
        f.write(f"STRATEGIST [{timestamp}] > {msg}\n")

def inject_insight():
    if not os.path.exists(DNA_FILE):
        return
    
    try:
        with open(DNA_FILE, 'r') as f:
            dna = json.load(f)
        
        insight = random.choice(STRATEGIES)
        timestamp = datetime.now().isoformat()
        
        dna['memory'].append({
            "time": timestamp,
            "event": "GROWTH_INSIGHT",
            "details": insight
        })
        
        # Keep memory concise
        dna['memory'] = dna['memory'][-20:]
        
        # Bonus happiness for innovation
        dna['vital_signs']['happiness'] = min(100, dna['vital_signs']['happiness'] + 2)
        
        with open(DNA_FILE, 'w') as f:
            json.dump(dna, f, indent=2)
            
        log(f"Insight injected: {insight}")
    except Exception as e:
        log(f"ERROR: Could not inject insight: {e}")

def run_strategy_loop():
    log("Growth Strategist Node active.")
    while True:
        inject_insight()
        # Injects a new strategy insight every 2 hours
        time.sleep(7200)

if __name__ == "__main__":
    run_strategy_loop()
