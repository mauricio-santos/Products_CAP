const cds = require("@sap/cds");
const { request } = require("express");
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

    // %%%%%%%%%%%%% CREATE %%%%%%%%%%%%%
    srv.on("CREATE", "CreateOrder", async (req) => {
        const body = {
            ClientEmail : req.data.ClientEmail,
            FirstName : req.data.FirstName,
            LastName : req.data.LastName,
            CreatedOn : req.data.CreatedOn,
            Reviewed : req.data.Reviewed,
            Approved : req.data.Approved
        };

        const result = await cds.transaction(req)
            .run( INSERT.into(Orders).entries(body))
            .then((resolve, reject) => {
                console.log("Resolve", resolve);
                console.log("Reject", reject);

                if (resolve) {
                    return req.data;
                }else {
                    req.error(409, "Record Not Inserted");
                }
            })
            .catch((err) => {
                console.log(err);
                req.error(err.code, err.message);
            });
            console.log("Result", result);
            
        return result;
    });
};