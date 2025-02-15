const cds = require("@sap/cds");

// module.exports = cds.service.impl(async function(srv) {
//     const { Incidents } = srv.entities;
//     const sapbackend = await cds.connect.to("sapbackend_metadata");
//     srv.on("READ", Incidents, async(req) => {
//         return await sapbackend.tx(req).send({
//             query: req.query,
//             headers: {
//                 "Authorization": "Basic c2FwdWk1OnNhcHVpNQ==" //Base64 de sapui5:sapui5
//             }
//         })
//     });
// });

module.exports = async (srv) => {
    const { Incidents } = srv.entities;
    const sapbackend = await cds.connect.to("sapbackend_metadata");

    srv.on(["READ"], Incidents, async (req) => {
        let incidentsQuery = SELECT.from(req.query.SELECT.from).limit(req.query.SELECT.limit);

        req.query.SELECT.where && incidentsQuery.where(req.query.SELECT.where);
        // req.query.SELECT.orderBy && incidentsQuery.where(req.query.SELECT.orderBy);

        let incident = await sapbackend.tx(req).send({
            query: incidentsQuery,
            headers: {
                Authorization: `${process.env.SAP_GATEWAY_AUTH}`
            }
        });

        let arrIncidents = [];
        Array.isArray(incident) ? arrIncidents = incident : arrIncidents[0] = incident;
        return arrIncidents;
    });
};