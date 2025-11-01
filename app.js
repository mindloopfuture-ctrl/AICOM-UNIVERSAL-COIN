// AICOM FRONTEND CONTROLLER
const AICOM_VERSION = "AICOM Deployment v2.0";
const OPERATOR = "R-M-P";

const NETWORKS = {
  ethereum: {
    chainId: "0x1",
    name: "Ethereum Mainnet"
  },
  bsc: {
    chainId: "0x38",
    name: "Binance Smart Chain"
  },
  polygon: {
    chainId: "0x89",
    name: "Polygon"
  },
  solana: {
    name: "Solana",
    rpc: "https://api.mainnet-beta.solana.com"
  }
};

function logSentinel(msg) {
  const area = document.getElementById("sentinel-log");
  const time = new Date().toISOString();
  area.textContent = `[${time}] ${msg}\n` + area.textContent;
}
logSentinel("AICOM_SENTINEL v2 iniciado.");
logSentinel("Operador: " + OPERATOR);

async function connect(chain) {
  logSentinel("Solicitud de conexión a " + chain);
  document.getElementById("tx-status").textContent = "Conectando a " + chain + "...";

  if (chain === "solana") {
    document.getElementById("tx-status").textContent = "Solana requiere Phantom o conexión RPC.";
    logSentinel("Solana: modo demostración.");
    return;
  }

  if (typeof window.ethereum === "undefined") {
    document.getElementById("tx-status").textContent =
      "No se detectó wallet. Abre en navegador con MetaMask.";
    logSentinel("Wallet no detectada.");
    return;
  }

  const net = NETWORKS[chain];
  try {
    await window.ethereum.request({
      method: "wallet_switchEthereumChain",
      params: [{ chainId: net.chainId }]
    });
    document.getElementById("tx-status").textContent =
      "✅ Conectado a " + net.name;
    logSentinel("Conectado a " + net.name);
  } catch (err) {
    document.getElementById("tx-status").textContent =
      "No se pudo cambiar de red: " + err.message;
    logSentinel("Error de conexión: " + err.message);
  }
}

function simulateTransfer() {
  const amount = document.getElementById("amount").value || "0";
  document.getElementById("tx-status").textContent =
    "Procesando transferencia simulada de " + amount + " AICOM...";
  logSentinel("Intento de transferencia: " + amount + " AICOM");

  setTimeout(() => {
    const ok = Math.random() < 0.9;
    if (ok) {
      document.getElementById("tx-status").textContent =
        "✅ Transferencia simulada exitosa: -" + amount + " AICOM";
      logSentinel("Transferencia simulada exitosa.");
    } else {
      document.getElementById("tx-status").textContent =
        "❌ Error simulado en la transferencia.";
      logSentinel("Error simulado en la transferencia.");
    }
  }, 1400);
}

// Sentinel ethics mock
const SentinelRules = {
  harm: false,
  bridgeLimit: 1000000,
  allowedChains: ["ethereum", "bsc", "polygon", "solana"]
};
logSentinel("Reglas cargadas: " + JSON.stringify(SentinelRules));
