using { sapbackend_metadata as external } from './external/sapbackend_metadata';

@path: '/sapbackend-exit'
service SAPBackendExit {

    //resolver o erro: "Entity "SAPBackendExit.Incidents" is annotated with "@cds.persistence.skip" and cannot be served generically."
    @cds.persistence : {
        table,
        skip: false
    }
    @cds.autoexpose //Auto exponhe as associações realacionadas as entidas (caso se aplique. Não é o caso atual)
    // entity Incidents as select from  external.IncidentsSet;
    entity Incidents as projection on external.IncidentsSet;
};

@path: '/rest-service'
// @protocol: ['rest', 'graphql']
@protocol: ['rest']
service RestService {
    entity Incidents as projection on SAPBackendExit.Incidents;
};

@path: '/graphql'
@graphql
service GraphQLService {
   entity Incidents as select from  external.IncidentsSet;
}