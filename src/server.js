const express = require("express");
const app = express();

app.get("/health", (req, res) => res.status(200).json({ status: "ok" }));

const port = process.env.PORT || 3000;
if (require.main === module) {
  app.listen(port, () => console.log(`Listening on ${port}`));
}

module.exports = app;
