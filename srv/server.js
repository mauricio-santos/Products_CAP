// %%%%%%%%%%%%% BOOTSTRAP %%%%%%%%%%%%%
const cds = require("@sap/cds");
const cors = require("cors"); //npm i cors

cds.on("bootstrap", (app) => {
    app.use(cors()); //Permite realizar petições a serviços externos
    app.get("/alive", (request, response) => {
        response.status(200).send("Server is Alive");
    });
});

module.exports = cds.server;