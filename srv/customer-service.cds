using { de.santos as santos } from '../db/schema';


service CustomerService {
    entity Customer_SRV as projection on santos.Customer   

}