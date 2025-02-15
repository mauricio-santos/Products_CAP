// %%%%%%%%%%%%% BOOTSTRAP %%%%%%%%%%%%%
const cds = require("@sap/cds");
const cors = require("cors"); //npm i cors
const cov2ap = require("@sap/cds-odata-v2-adapter-proxy"); // npm i @sap/cds-odata-v2-adapter-proxy

cds.on("bootstrap", (app) => {
    app.use(cov2ap()); // Usando OData V2
    app.use(cors()); //Permite realizar petições a serviços externos
    app.get("/alive", (request, response) => {
        response.status(200).send("Server is Alive");
    });
});

if (process.env.NODE_ENV !== 'production') {
    require("dotenv").config(); //Disponibiliza dotenv
}

module.exports = cds.server;