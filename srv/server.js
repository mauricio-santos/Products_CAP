// %%%%%%%%%%%%% BOOTSTRAP %%%%%%%%%%%%%
const cds = require("@sap/cds");

cds.on("bootstrap", (app) => {
    app.get("/alive", (request, response) => {
        response.status(200).send("Server is Alive");
    });
});

module.exports = cds.server;