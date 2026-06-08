#!/usr/bin/env bash

if ! command -v codeql >/dev/null 2>&1; then
  echo "install the CodeQL CLI first"
  exit 1
fi

SRC_DIR="/tmp/codeql-demo"
DB_DIR="/tmp/codeql-db"
# picked OSCommandInjection because the docs called out the path specifically
# TODO: if query run errors about "pack not found," the bundled queries may live
# under a different root — run `find $HOME/codeql*/ -name OSCommandInjection.ql`
QUERY="codeql/javascript:ql/src/CWE-078/OSCommandInjection.ql"
OUT="/tmp/codeql-demo-results.sarif"

mkdir -p "$SRC_DIR"
cat > "$SRC_DIR/app.js" <<'EOF'
const express = require('express');
const app = express();
app.get('/view', (req, res) => {
  const fname = req.query.file;
  res.sendFile(fname);
});
app.listen(3000);
EOF

codeql database create "$DB_DIR" --language=javascript --source-root="$SRC_DIR"
codeql query run "$QUERY" --database="$DB_DIR" --output="$OUT"

echo "results at $OUT"
head "$OUT"
