const cds = require("@sap/cds");
const { Orders } = cds.entities("de.training");

module.exports = (srv) => {

    // %%%%%%%%%%%%% READ %%%%%%%%%%%%%
    srv.on("READ", "GetOrders", async (request) => {

        if (request.data.ClientEmail !== undefined) {
            return await SELECT.from`de.training.Orders`
                .where`ClientEmail = ${request.data.ClientEmail}`;
        }
        return await SELECT.from(Orders);
    });
};