#!/usr/bin/env bash
# last_verified: 2026-07-13 · terraform n/a

mkdir -p src
cat > src/index.js <<'JS'
exports.handler = async () => ({ statusCode: 200, body: "Hello from Lambda!" });
JS
zip -j lambda_function.zip src/index.js
echo "[+] Built lambda_function.zip"
