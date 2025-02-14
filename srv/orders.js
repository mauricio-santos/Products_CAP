const cds = require("@sap/cds");
const { Orders } = cds.entities("de.training");

module.exports = (srv) => {

    // %%%%%%%%%%%%% READ %%%%%%%%%%%%%
    srv.on("READ", "GetOrders", async (request) => {
        return await SELECT.from(Orders);
    });
};