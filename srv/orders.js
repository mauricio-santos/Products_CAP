const cds = require("@sap/cds");
const { Orders } = cds.entities("de.training");

module.exports = (srv) => {

    // %%%%%%%%%%%%% BEFORE ALL REQUESTS %%%%%%%%%%%%%
    srv.before("*", (req) => {
        console.log(`Methods: ${req.method}`);
        console.log(`Targets: ${req.target}`);
    });

    // %%%%%%%%%%%%% READ %%%%%%%%%%%%%
    srv.on("READ", "Orders", async (request) => {

        if (request.data.ClientEmail !== undefined) { //Filtrando email
            return await SELECT.from`de.training.Orders`
                .where`ClientEmail = ${request.data.ClientEmail}`;
        }
        return await SELECT.from(Orders);
    });

    srv.after("READ", "Orders", (data) => { //Convertendo todos os valores de Reviewed para true
        return data.map(order => order.Reviewed = true);
    });

    // %%%%%%%%%%%%% CREATE %%%%%%%%%%%%%
    srv.on("CREATE", "Orders", async (req) => {
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

    srv.before("CREATE", "Orders", (req) => {
        return req.data.CreatedOn = new Date().toISOString().slice(0, 10); // YYYY-MM-dd
    });

    // %%%%%%%%%%%%% UPDATE %%%%%%%%%%%%%
    srv.on("UPDATE", "Orders", (async (req) => {
        const ClientEmail = req.data.ClientEmail;
        const newData = {
            FirstName: req.data.FirstName,
            LastName: req.data.LastName,
        };

        const result = await cds.transaction(req)
            .run([UPDATE(Orders, ClientEmail).set(newData)])
            .then((resolve, reject) => {
                console.log("Resolve: ", resolve);
                console.log("Reject: ", reject);

                if (resolve[0] == 0) {
                    req.error(409, "Record Not Found");
                }

            })
            .catch(e => {
                console.log(e);
                req.error(e.code, e.message);
            });
    }));

    // %%%%%%%%%%%%% DELETE %%%%%%%%%%%%%
    srv.on("DELETE", "Orders", async (req) => {
        const clientEmail = req.data.ClientEmail;

        const result = await cds.transaction(req)
            .run(DELETE.from(Orders).where({ClientEmail: clientEmail}))
            .then((resolve, reject) => {
                console.log("Resolve: ", resolve);
                console.log("Reject: ", reject);

                if (resolve !== 1) {
                    req.error(409, "Record Not Found");
                }
            })
            .catch(e => {
                console.log(e);
                req.error(e.code, e.message);
            });
            console.log("results: ", result);
            
    });

    // %%%%%%%%%%%%% FUNÇÕES %%%%%%%%%%%%%
    srv.on("getClientTaxRate", async (req) => {
        //Não é modificado no lado do servidor
        const {clientEmail} = req.data;
        const db = srv.transaction(req);
        const results = await db.read(Orders, ["Country_code"]).where({ClientEmail: clientEmail});
        const countryCode = results[0].Country_code;

        switch (countryCode) {
            case 'ES': return 21.5;
            case 'UK': return 24.6;
            default: return 0;
        }
    });

    // %%%%%%%%%%%%% AÇÕES %%%%%%%%%%%%%
    // É modificado no lado do servidor
    srv.on("cancelOrder", async (req) => {
        const { clientEmail } = req.data;
        const db = srv.transaction(req);
        const results = await db
            .read(Orders, ["FirstName", "LastName", "Approved"])
            .where({ClientEmail: clientEmail});
        
        const returnOrder = {
            status: "",
            message: ""
        };

        console.log(clientEmail);
        console.log(results);
        
        if (!results[0].Approved) {
            const resultsUpdate = await db.update(Orders)
                .set({Status: 'C'})
                .where({ClientEmail: clientEmail});
            returnOrder.status = "Succeeded";
            returnOrder.message = `The Order placed by ${results[0].FirstName} ${results[0].LastName} was cancelled!`;
        }else {
            returnOrder.status = "Failed";
            returnOrder.message = `The Order placed by ${results[0].FirstName} ${results[0].LastName} NOT cancelled becouse was already approved`;
        }

        console.log("Action cancellOrder executed");
        return returnOrder;
        
    });
};