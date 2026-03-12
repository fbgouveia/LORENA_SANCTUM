import tkinter as tk
from tkinter import ttk
import threading
import time
import os

# 🛰️ Painel de Operações Soberanas v2.0 (MODO REAL)
# Local: D:\IMPERIO_ANTIGRAVITY\ARQUIVOS_EXECUCAO\operacoes_painel.py

LOG_FILE = r"D:\IMPERIO_ANTIGRAVITY\ARQUIVOS_EXECUCAO\operations.log"

class OperacoesPainel:
    def __init__(self):
        self.root = tk.Tk()
        self.root.title("Antigravity Operations Center")
        self.root.overrideredirect(True)
        self.root.attributes("-topmost", True)
        self.root.attributes("-alpha", 0.9)
        self.root.geometry("400x300+20+50")
        self.root.config(bg="#0a0a0a")

        # Header
        self.header = tk.Label(self.root, text="ANTIGRAVITY CORE OPS - REAL TIME", fg="#ffae00", bg="#1a1a1a", font=("Consolas", 10, "bold"))
        self.header.pack(fill="x")

        # Console
        self.log = tk.Text(self.root, bg="#000000", fg="#00ff41", font=("Consolas", 8), state="disabled", borderwidth=0)
        self.log.pack(fill="both", expand=True, padx=5, pady=5)

        # Status
        self.footer = tk.Frame(self.root, bg="#1a1a1a")
        self.footer.pack(fill="x")
        
        self.thelma_status = tk.Label(self.footer, text="THELMA: INICIALIZANDO AUDITORIA", fg="#ff00ff", bg="#1a1a1a", font=("Consolas", 8))
        self.thelma_status.pack(side="left", padx=10)

        # Iniciar Monitor de Log Real
        threading.Thread(target=self.watch_logs, daemon=True).start()

    def add_log(self, message):
        self.log.config(state="normal")
        self.log.insert("end", f"[{time.strftime('%H:%M:%S')}] {message}\n")
        self.log.see("end")
        self.log.config(state="disabled")

    def watch_logs(self):
        if not os.path.exists(LOG_FILE):
            with open(LOG_FILE, "w") as f: f.write("INICIANDO FLUXO SOBERANO\n")
        
        last_size = os.path.getsize(LOG_FILE)
        while True:
            current_size = os.path.getsize(LOG_FILE)
            if current_size > last_size:
                with open(LOG_FILE, "r") as f:
                    f.seek(last_size)
                    new_lines = f.readlines()
                    for line in new_lines:
                        self.add_log(line.strip())
                last_size = current_size
            time.sleep(0.5)

    def run(self):
        self.root.mainloop()

if __name__ == "__main__":
    app = OperacoesPainel()
    app.run()
