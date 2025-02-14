const cds = require("@sap/cds");
const { Orders } = cds.entities("de.training");

module.exports = (srv) => {

    // %%%%%%%%%%%%% READ %%%%%%%%%%%%%
    srv.on("READ", "GetOrders", async (request) => {

        if (request.data.ClientEmail !== undefined) { //Filtrando email
            return await SELECT.from`de.training.Orders`
                .where`ClientEmail = ${request.data.ClientEmail}`;
        }
        return await SELECT.from(Orders);
    });

    srv.after("READ", "GetOrders", (data) => { //Convertendo todos os valores de Reviewed para true
        return data.map(order => order.Reviewed = true);
    });
};