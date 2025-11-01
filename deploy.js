// AICOM Deploy Portal (BSC)
// Owner fijo dado por R-M-P
const OWNER_ADDRESS = "0x8a898a58d96013c33477b0a7606a83fd5bec7abc";

// Supply fijo: 1,000,000,000 * 10^18
const SUPPLY = ethers.BigNumber.from("1000000000").mul(ethers.BigNumber.from("10").pow(18));

// ABI mínimo del contrato (lo suficiente para desplegar y ver el totalSupply)
const AICOM_ABI = [
  "function name() view returns (string)",
  "function symbol() view returns (string)",
  "function decimals() view returns (uint8)",
  "function totalSupply() view returns (uint256)",
  "function balanceOf(address) view returns (uint256)",
  "function transfer(address,uint256) returns (bool)"
];

// ⚠️ IMPORTANTE ⚠️
// Aquí debes pegar el BYTECODE que te da Remix cuando compilas AICOMUniversalToken_BSC.sol
// Ejemplo: const AICOM_BYTECODE = "0x6080...";
// Si dejas "0xBYTECODE_AQUI", la app te avisará que falta.
const AICOM_BYTECODE = "0xBYTECODE_AQUI";

const logBox = document.getElementById("log");
function log(msg) {
  logBox.textContent = `[${new Date().toLocaleTimeString()}] ${msg}\n` + logBox.textContent;
}

let provider, signer;

async function connectWallet() {
  if (!window.ethereum) {
    log("❌ No se encontró wallet. Abre esto en el navegador de MetaMask / Trust / OKX.");
    return;
  }
  provider = new ethers.providers.Web3Provider(window.ethereum);
  await provider.send("eth_requestAccounts", []);
  signer = provider.getSigner();
  const addr = await signer.getAddress();
  const net = await provider.getNetwork();
  log(`✅ Wallet conectada: ${addr}`);
  log(`🌐 Red actual: chainId=${net.chainId}`);
  if (net.chainId !== 56) {
    log("⚠️ No estás en BSC Mainnet. Cambia de red en tu wallet a Binance Smart Chain.");
  }
}

async function deployToken() {
  if (!signer) {
    log("Conecta la wallet primero.");
    return;
  }
  if (AICOM_BYTECODE === "0xBYTECODE_AQUI") {
    log("⚠️ Falta pegar el bytecode compilado del contrato.");
    log("➡️ En Remix: compila → pestaña Artifacts → copia el 'Bytecode' → pégalo aquí en deploy.js.");
    return;
  }

  log("🚀 Preparando despliegue en BSC...");
  try {
    const factory = new ethers.ContractFactory(AICOM_ABI, AICOM_BYTECODE, signer);
    const contract = await factory.deploy();
    log(`⏳ Tx enviada: ${contract.deployTransaction.hash}`);
    const receipt = await contract.deployTransaction.wait();
    log(`✅ Contrato desplegado en: ${contract.address}`);
  } catch (err) {
    console.error(err);
    log("❌ Error al desplegar: " + (err.message || err));
  }
}

document.getElementById("btn-connect").addEventListener("click", connectWallet);
document.getElementById("btn-deploy").addEventListener("click", deployToken);
