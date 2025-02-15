using { sapbackend_metadata as external } from './external/sapbackend_metadata';

service SAPBackendExit {

    entity Incidents as select from  external.IncidentsSet;

}