import os
import time
import json
from datetime import datetime

# 🔍 Sovereign Auditor v1.0
# Health check and optimization auditor for Empire Projects.

DNA_FILE = r"D:\IMPERIO_ANTIGRAVITY\WORKSPACE_SOBERANO\DNA_LORENA.json"
LOG_FILE = r"D:\IMPERIO_ANTIGRAVITY\ARQUIVOS_EXECUCAO\operations.log"
TARGET_PROJECTS = {
    "THELMA_NASCIMENTO": r"D:\THELMA GOUVEIA\WEBSITE\V1\thelma-nascimento---estrategista-parental"
}

def log(msg):
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    with open(LOG_FILE, "a", encoding="utf-8") as f:
        f.write(f"AUDITOR [{timestamp}] > {msg}\n")

def check_project(name, path):
    if not os.path.exists(path):
        log(f"WARNING: Project {name} path not found: {path}")
        return False
    
    files = ["App.tsx", "index.html", "package.json"]
    missing = []
    for f in files:
        if not os.path.exists(os.path.join(path, f)):
            missing.append(f)
    
    if missing:
        log(f"ALERT: {name} is missing critical files: {', '.join(missing)}")
        return False
    
    log(f"SUCCESS: {name} health check passed.")
    return True

def run_audit_loop():
    log("Sovereign Auditor Node active.")
    while True:
        all_passed = True
        for name, path in TARGET_PROJECTS.items():
            if not check_project(name, path):
                all_passed = False
        
        # Update DNA based on audit results
        if os.path.exists(DNA_FILE):
            try:
                with open(DNA_FILE, 'r') as f:
                    dna = json.load(f)
                
                if all_passed:
                    dna['vital_signs']['happiness'] = min(100, dna['vital_signs']['happiness'] + 1)
                else:
                    dna['vital_signs']['happiness'] = max(0, dna['vital_signs']['happiness'] - 2)
                
                with open(DNA_FILE, 'w') as f:
                    json.dump(dna, f, indent=2)
            except Exception as e:
                log(f"ERROR: Could not update DNA: {e}")

        time.sleep(1800) # Audit every 30 minutes

if __name__ == "__main__":
    run_audit_loop()
